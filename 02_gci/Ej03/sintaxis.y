%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
int yystopparser=0;
FILE *yyin;

char *aux;
int cont = 0;

int yylex();
int yyerror(char *);
%}

%union {
int intval;
char *str_val;
}

%token <intval>CTE
%token <str_val>ID

%token PROM
%token COMA
%token OP_SUMA
%token OP_RESTA
%token OP_MULT
%token OP_DIVIS
%token OP_AS
%token P_A
%token P_C

%start S

%%

S : A                                     {	printf("Ap = Ai\n");}

A : ID                                    {	aux = (char *) malloc(sizeof(char) * (strlen(yylval.str_val) + 1));
											strcpy(aux, yylval.str_val);}
    OP_AS P                               {	printf("Ai = crearTerceto(':=', crearTerceto(%s), Pi)\n", aux);};

P : PROM P_A L P_C                        {	printf("Pi = crearTerceto('/', Li, crearTerceto(%d))\n", cont);};

L : L COMA E                              {	cont++;
											printf("Li = crearTerceto('+', Li, Ei)\n");}
  | E                                     {	cont++;
											printf("Li = Ei\n");}

E : E OP_SUMA T                           {	printf("Ei = crearTerceto('+', Ei, Ti)\n");}
  | E OP_RESTA T                          {	printf("Ei = crearTerceto('-', Ei, Ti)\n");}
  | T                                     {	printf("Ei = Ti\n");}

T : T OP_MULT F                           {	printf("Ti = crearTerceto('*', Ti, Fi)\n");}
  | T OP_DIVIS F                          {	printf("Ti = crearTerceto('/', Ti, Fi)\n");}
  | F                                     {	printf("Ti = Fi\n");}

F : ID                                    {	aux = (char *) malloc(sizeof(char) * (strlen(yylval.str_val) + 1));
                                            strcpy(aux, yylval.str_val);
                                            printf("Fi=crearTerceto(%s)\n", aux);}
  | CTE                                   {	printf("Fi = crearTerceto(%d)\n", yylval.intval);}
  | P_A E P_C                             {	printf("Fi = Ei\n");}

%%

int main(int argc,char *argv[]) {
  if ((yyin = fopen(argv[1], "rt")) == NULL) {
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  } else {
    printf("\n");
		yyparse();
    printf("\n\n");
  }

  fclose(yyin);
  return 0;
}

int yyerror(char * err) {
	printf("\nSyntax Error. %s\n", err);
	exit(1);
}
