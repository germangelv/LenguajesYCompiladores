%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
FILE  *yyin;
int yylval;

%}
%option noyywrap  
%option yylineno 

			
DIGITO			[0-9]
LETRA			[a-zA-Z]
ID			{LETRA}({LETRA}|{DIGITO}|_)*



%%
"INICIO"	{ return INICIO;}
"FIN"		{ return FIN;}
"="			{ return ASIG;}
"+"			{ return OP_SUMA;}
"-"			{ return OP_RESTA;}
"*"			{ return OP_MUL;}
"/"			{ return OP_DIV;}
"("			{ return P_A;}
")"			{ return P_C;}
{ID}		{ return ID;}
";"			{ return PYC;}

{DIGITO}+	      { yylval = atoi( yytext ) ;return ENTERO;}

"\n"      		
"\t"		



