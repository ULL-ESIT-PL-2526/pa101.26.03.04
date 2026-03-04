%{
#ifndef YYDEBUG
#define YYDEBUG 1
#endif

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%token NUMBER
%type  E

%%
L
			: '\n'
			| E  '\n' { printf("= %d\n", $1); }
			;

E
			: E '+' E	{ $$ = $1 + $3; }
			| E '*' E	{ $$ = $1 * $3; }
			| '(' E ')'	{ $$ = $2; }
			| NUMBER	{ $$ = $1; }
			;

%%

void yyerror(const char *s) {
	fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
#if YYDEBUG
    extern int yydebug;
    yydebug = 1;
#endif
	printf("Calculadora aritmética (Ctrl+D para salir)\n");
	printf("Operadores: +, *, (, )\n");
	return yyparse();
}

