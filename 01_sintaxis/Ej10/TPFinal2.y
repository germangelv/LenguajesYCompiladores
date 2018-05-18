
%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
int yylval;
int yystopparser=0;
FILE  *yyin;
char *yyltext;
char *yytext;

%}
%token ID
%token ENTERO OP_SUMA OP_RESTA OP_MUL OP_DIV ASIG P_A P_C PYC INICIO FIN
%%

P: INICIO B FIN {printf("P -> inicio L fin; OK\n");}
;

B:B S PYC	{printf("B -> B S;\n");}
| S PYC			{printf("B -> S;\n");}
;

S:L			{printf("S -> L\n");}
;

L:ID ASIG L			{printf("L -> id=L\n");}
| ID ASIG E		{printf("L -> id=E\n");}
;
E : E OP_SUMA T 	{printf("E -> E+T\n");}
| E OP_RESTA T 		{printf("E -> E-T\n");}
| T 				{printf("E -> T\n");}
;

T : T OP_MUL F 		{printf("T -> T*F\n");}
| T OP_DIV F 		{printf("T -> T/F\n");}
| F					{printf("T -> F\n");}
;

F : ID 				{printf("F -> id\n");}
| ENTERO 			{printf("F -> cte\n");}
| P_A E P_C			{printf("F -> (E)\n");}
;

%%
int main(int argc,char *argv[])
{
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
	yyparse();
  }
  fclose(yyin);
  return 0;
}
int yyerror(void)
     {
       printf("Syntax Error\n");
	 system ("Pause");
	 exit (1);
     }




