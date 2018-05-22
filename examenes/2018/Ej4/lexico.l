%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
FILE  *yyin;
%}

%option noyywrap
%option yylineno

DIGITO			      	[0-9]
LETRA			        [a-zA-Z]
CTE               		{DIGITO}+
ID			          	{LETRA}({LETRA}|{DIGITO}|_)*
OP_MENOR          		"<"
OP_MAYOR          		">"
OP_MENOR_IGUAL    		"<="
OP_MAYOR_IGUAL    		"<="
OP_DISTINTO       		"<>"
OP_EQUIVALENTE    		"=="
P_A						"("
P_C						")"
COMA					","
PYC						";"
SUMASI					"SUMASI"

%%
{OP_MENOR}			    {return OP_MENOR; 		}
{OP_MAYOR}              {return OP_MAYOR;		} 
{OP_MENOR_IGUAL}        {return OP_MENOR_IGUAL;	} 
{OP_MAYOR_IGUAL}    	{return OP_MAYOR_IGUAL;	}
{OP_DISTINTO}       	{return OP_DISTINTO;	}
{OP_EQUIVALENTE}    	{return OP_EQUIVALENTE;	}
{P_A}					{return P_A;			}
{P_C}					{return P_C;			}
{COMA}					{return COMA;			}
{PYC}					{return PYC;			}
{SUMASI}				{return SUMASI;			}

{ID}					{	yylval.str_val = yytext;
							return ID;
						}
{CTE}		  			{	yylval.intval = atoi(yytext);
							return CTE;
						}

"\n"
"\t"
