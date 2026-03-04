%{
#include <stdio.h>
#include <stdlib.h>
#include "lr.tab.h"
%}

%option noyywrap

DIGIT      [0-9]
NUMBER     {DIGIT}+

%%

[ \t\r]+		;
"\n" 			{ return '\n'; }
{NUMBER}		{
			  yylval = atoi(yytext);
			  return NUMBER;
			}
[()+*]			{ return yytext[0]; }
.			{
			  fprintf(stderr, "Caracter no reconocido: %s\n", yytext);
			  return yytext[0];
			}
%%
