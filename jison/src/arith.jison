%lex
%%
\s+                   /* skip whitespace */
\/\/[^\n]*            /* skip line comments */
([0-9]+(\.[0-9]*)?|\.[0-9]+)([eE][+-]?[0-9]+)?\b   return 'NUMBER';
"**"                  return 'POW';
[-+*/]                return yytext;
\n                    return 'EOL';
<<EOF>>               return 'EOF';
.                     return 'INVALID';
/lex

%start line

%left '+' '-'
%left '*' '/'
%right UMINUS
%right POW

%%

line
  :
    { return null; }
  | expr 'EOF'
    { return $1; }
  ;

expr
  : NUMBER
    { $$ = Number(yytext); }
  | '(' expr ')'
    { $$ = $2; }
  | expr '+' expr
    { $$ = $1 + $3; }
  | expr '-' expr
    { $$ = $1 - $3; }
  | expr '*' expr
    { $$ = $1 * $3; }
  | expr '/' expr
    {
      if ($3 === 0) {
        throw new Error('division by zero');
      }
      $$ = $1 / $3;
    }
  | expr POW expr
    { $$ = Math.pow($1, $3); }
  | '+' expr %prec UMINUS
    { $$ = +$2; }
  | '-' expr %prec UMINUS
    { $$ = -$2; }
  ;
