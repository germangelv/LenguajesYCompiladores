%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
int yystopparser = 0;
FILE *yyin;

/* ************************************************** */
/* ********************* RPN  *********************** */
/* ************************************************** */

int currentCell = 1;

// Celda RPN
struct cell {
  int index;
  char *value;
};
typedef struct cell cell;

// Pila RPN
struct rpn {
  struct cell *value;
  struct rpn *next;
  struct rpn *prev;
};
typedef struct rpn rpn;

// Pila Indices RPN
typedef struct{
    cell* stack[100];
    int top;
} t_stack;

rpn *rpnQueue = NULL;
rpn *rpnFirst = NULL;
t_stack *indexes;

void initPolaca();
void mostrarPolaca();
cell* insertarEnPolaca(char *);
void apilarIndice(struct cell *cell);
cell* desapilarIndice(int isElse);

/* ************************************************** */
/* ******************** FIN - RPN  ****************** */
/* ************************************************** */

char *aux;

int yylex();
int yyerror(char *);
%}

%union {
int intval;
char *str_val;
}

%token <intval>CTE
%token <str_val>ID

%token OP_MENOR
%token OP_MAYOR
%token OP_MENOR_IGUAL
%token OP_MAYOR_IGUAL
%token OP_DISTINTO
%token OP_EQUIVALENTE
%token P_A
%token P_C
%token COMA		
%token PYC
%token SUMASI

%start S

%%

S  : 	SUMASI P_A O _ID COMA _ID PYC L P_C 
										{	
											printf("R01 S-> sumasi(O id, id; L)\n");
										}

O  : 	OP_MENOR 						{	
											printf("R02 O-><\n");
                                            insertarEnPolaca("CMP");
                                            insertarEnPolaca("BGE");
											cell* c = insertarEnPolaca("@salto_BGE");
                                            apilarIndice(c);
											

										}	
	|	OP_MAYOR 						{	
											printf("R02 O->>\n");
											cell* aux1 = insertarEnPolaca("@aux1");
											apilarIndice(aux1); //10
											cell* aux2 = insertarEnPolaca("@aux2");
											apilarIndice(aux2); //10 deberia ser 11
                                            insertarEnPolaca("CMP");
                                            insertarEnPolaca("BLE");
											cell* salto = insertarEnPolaca("@salto_BLE");
                                            apilarIndice(salto);//11 deberia ser 12
											
										}	
	|	OP_MENOR_IGUAL 					{	
											printf("R02 O-><=\n");
                                            insertarEnPolaca("CMP");
                                            insertarEnPolaca("BGT");
											cell* c = insertarEnPolaca("@salto_BGT");
                                            apilarIndice(c);
										}	
	|	OP_MAYOR_IGUAL 					{	
											printf("R02 O->>=\n");
                                            insertarEnPolaca("CMP");
                                            insertarEnPolaca("BLT");
											cell* c = insertarEnPolaca("@salto_BLT");
                                            apilarIndice(c);
										}	
	|	OP_DISTINTO 					{	
											printf("R02 O-><>\n");
                                            insertarEnPolaca("CMP");
                                            insertarEnPolaca("BEQ");
											cell* c = insertarEnPolaca("@salto_BEQ");
                                            apilarIndice(c);
										}	
	|	OP_EQUIVALENTE					{	
											printf("R02 O->==\n");
                                            insertarEnPolaca("CMP");
                                            insertarEnPolaca("BNE");
											cell* c = insertarEnPolaca("@salto_BNE");
                                            apilarIndice(c);
										}	
L:		L COMA CTE	 					{	
											printf("R03 L->L, cte\n");
											char str[12];
											sprintf(str, "%d", yylval.intval);	
											insertarEnPolaca(str);
											insertarEnPolaca("BI");
											//desapilarIndice(0);
											cell* c = insertarEnPolaca("@salto_BI");
										}
	|	CTE	 							{	
											printf("R04 L->cte\n");
											char str[12];
											sprintf(str, "%d", yylval.intval);	
											insertarEnPolaca(str);
											
											insertarEnPolaca("BI");
											cell *c1 = desapilarIndice(3);
											cell *c2 = desapilarIndice(2);
											cell *c3 = desapilarIndice(0);
											insertarEnPolaca(c1->value);
										
										}
_ID:	ID								{	
											aux = (char *) malloc(sizeof(char) * (strlen(yylval.str_val) + 1));
                                            strcpy(aux, yylval.str_val);
											cell* c = insertarEnPolaca(aux);											
										};
											
			
%%

/* ************************************************** */
/* *********************** RPN ********************** */
/* ************************************************** */

void initPolaca() {
  indexes = (t_stack *) malloc(sizeof(t_stack));
  indexes->top = -1;
}

cell* insertarEnPolaca(char *value) {
  rpn *ptr = (rpn *) malloc (sizeof (rpn));
  cell *c = (cell *) malloc (sizeof (cell));
  c->value = (char *) malloc (strlen (value) + 1);
  strcpy (c->value, value);
  ptr->value = c;
  ptr->next = rpnQueue;
  if (rpnFirst == NULL) {
    rpnFirst = ptr;
  } else {
    rpnQueue->prev = ptr;
  }
  rpnQueue = ptr;
  currentCell++;
  return c;
}

void apilarIndice(cell *c) {
  indexes->top++;
  indexes->stack[indexes->top] = c;
  //Ver que apile
  char str[10];
  strcpy(str, c->value);
  printf("\tApilando ...%s a la ubicacion%d \n",str,indexes->top);
}

cell* desapilarIndice(int isElse) {
  cell *c = indexes->stack[indexes->top];
  char str[10];
  sprintf(str, "%d", isElse ? currentCell : currentCell + 1);
  strcpy(c->value, str);
  printf("\tDesapilando ...%s de la ubicacion%d \n",c->value,indexes->top);
  indexes->top--;
  printf("\tEl nuevo tope de la pila es %d \n",indexes->top);
  return c;
}

void mostrarPolaca() {
  rpn *ptr;
  printf("\t");
  for (ptr = rpnFirst; ptr != (rpn *) 0; ptr = (rpn *)ptr->prev) {
     printf("%s ", ptr->value->value);
  }
}

/* ************************************************** */
/* ******************** FIN - RPN  ****************** */
/* ************************************************** */

int main(int argc,char *argv[]) {
  if ((yyin = fopen(argv[1], "rt")) == NULL) {
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  } else {
    printf("\n");
	
    initPolaca();
	printf("\tParcing...\n\t----------\n\n");
	yyparse();
	printf("\n\tPolaca\n\t------\n\n");
    mostrarPolaca();
    printf("\n\n");
  }

  fclose(yyin);
  return 0;
}

int yyerror(char * err) {
	printf("\nSyntax Error. %s\n", err);
	exit(1);
}
