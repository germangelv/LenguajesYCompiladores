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

S : A                                     {	printf("generar_(polaca)\n");}

A : ID                                    {	aux = (char *) malloc(sizeof(char) * (strlen(yylval.str_val) + 1));
											strcpy(aux, yylval.str_val);}
    OP_AS P                               {	printf("insertar_pol(%s)\ninsertar_pol(=)", aux);};

P : PROM P_A L P_C                        {	printf("insertar_pol(@acum)\ninsertar_pol(=)\ninsertar_pol(%d)\ninsertar_pol(/)\n", 											cont);}




L : L COMA E                              {	cont++;
											printf("insertar_pol(+)\n");}
  | E                                     {	cont=1;}
											

E : E OP_SUMA T                           {	printf("insertar_pol(+)\n");}
  | E OP_RESTA T                          {	printf("insertar_pol(-)\n");}
  | T                                     

T : T OP_MULT F                           {	printf("insertar_pol(*)\n");}
  | T OP_DIVIS F                          {	printf("insertar_pol(/)\n");}
  | F                                     

F : ID                                    {	aux = (char *) malloc(sizeof(char) * (strlen(yylval.str_val) + 1));
                                            strcpy(aux, yylval.str_val);
                                            printf("insertar_pol(%s)\n", aux);}
  | CTE                                   {	printf("insertar_pol(%d)\n", yylval.intval);}
  | P_A E P_C                             

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
