# Automáta LR

Al ejecutar `bison -v lr.y` se crea el fichero `lr.output` que contiene los estados del DFA.

```text
State 12 conflicts: 2 shift/reduce
State 13 conflicts: 2 shift/reduce


Grammar

    0 $accept: L $end

    1 L: '\n'
    2  | E '\n'

    3 E: E '+' E
    4  | E '*' E
    5  | '(' E ')'
    6  | NUMBER


Terminals, with rules where they appear

    $end (0) 0
    '\n' (10) 1 2
    '(' (40) 5
    ')' (41) 5
    '*' (42) 4
    '+' (43) 3
    error (256)
    NUMBER (258) 6


Nonterminals, with rules where they appear

    $accept (9)
        on left: 0
    L (10)
        on left: 1 2
        on right: 0
    E (11)
        on left: 3 4 5 6
        on right: 2 3 4 5


State 0

    0 $accept: • L $end

    NUMBER  shift, and go to state 1
    '\n'    shift, and go to state 2
    '('     shift, and go to state 3

    L  go to state 4
    E  go to state 5


State 1

    6 E: NUMBER •

    $default  reduce using rule 6 (E)


State 2

    1 L: '\n' •

    $default  reduce using rule 1 (L)


State 3

    5 E: '(' • E ')'

    NUMBER  shift, and go to state 1
    '('     shift, and go to state 3

    E  go to state 6


State 4

    0 $accept: L • $end

    $end  shift, and go to state 7


State 5

    2 L: E • '\n'
    3 E: E • '+' E
    4  | E • '*' E

    '\n'  shift, and go to state 8
    '+'   shift, and go to state 9
    '*'   shift, and go to state 10


State 6

    3 E: E • '+' E
    4  | E • '*' E
    5  | '(' E • ')'

    '+'  shift, and go to state 9
    '*'  shift, and go to state 10
    ')'  shift, and go to state 11


State 7

    0 $accept: L $end •

    $default  accept


State 8

    2 L: E '\n' •

    $default  reduce using rule 2 (L)


State 9

    3 E: E '+' • E

    NUMBER  shift, and go to state 1
    '('     shift, and go to state 3

    E  go to state 12


State 10

    4 E: E '*' • E

    NUMBER  shift, and go to state 1
    '('     shift, and go to state 3

    E  go to state 13


State 11

    5 E: '(' E ')' •

    $default  reduce using rule 5 (E)


State 12

    3 E: E • '+' E
    3  | E '+' E •
    4  | E • '*' E

    '+'  shift, and go to state 9
    '*'  shift, and go to state 10

    '+'       [reduce using rule 3 (E)]
    '*'       [reduce using rule 3 (E)]
    $default  reduce using rule 3 (E)


State 13

    3 E: E • '+' E
    4  | E • '*' E
    4  | E '*' E •

    '+'  shift, and go to state 9
    '*'  shift, and go to state 10

    '+'       [reduce using rule 4 (E)]
    '*'       [reduce using rule 4 (E)]
    $default  reduce using rule 4 (E)

```


# Traza del análisis LR para la entrada `1+2*3+4`

La secuencia de operaciones del parser LR sobre la entrada `1+2*3+4` es la siguiente:

| Paso | Pila de estados | Lookahead | Acción |
|---:|:---|:---:|:---|
| 1 | 0 | `NUMBER` | `shift` a 1 |
| 2 | 0 1 | `+` | `reduce r6: E → NUMBER`, `goto 5` |
| 3 | 0 5 | `+` | `shift` a 9 |
| 4 | 0 5 9 | `NUMBER` | `shift` a 1 |
| 5 | 0 5 9 1 | `*` | `reduce r6: E → NUMBER`, `goto 12` |
| 6 | 0 5 9 12 | `*` | `shift` a 10 |
| 7 | 0 5 9 12 10 | `NUMBER` | `shift` a 1 |
| 8 | 0 5 9 12 10 1 | `+` | `reduce r6: E → NUMBER`, `goto 13` |
| 9 | 0 5 9 12 10 13 | `+` | `shift` a 9 |
| 10 | 0 5 9 12 10 13 9 | `NUMBER` | `shift` a 1 |
| 11 | 0 5 9 12 10 13 9 1 | `\n` | `reduce r6: E → NUMBER`, `goto 12` |
| 12 | 0 5 9 12 10 13 9 12 | `\n` | `reduce r3: E → E + E`, `goto 13` |
| 13 | 0 5 9 12 10 13 | `\n` | `reduce r4: E → E * E`, `goto 12` |
| 14 | 0 5 9 12 | `\n` | `reduce r3: E → E + E`, `goto 5` |
| 15 | 0 5 | `\n` | `shift` a 8 |
| 16 | 0 5 8 | `EOF` | `reduce r2: L → E \n`, salida `= 15`, `accept` |

En los paso de traza muestra decisiones para hacer acciones de __Shift__ en el paso 6 y el paso 9.

En el paso 6 mirando el `*` hace un `shift a 10`.
En este estado se podría reducir por `E -> E + E` pero se elige desplazar el `*`.

Ocurre lo mismo en el paso 9, mirando el `+` hace un `shift a 9`.
En este estado se podría reducir por `E -> E * E` pero se elige desplazar el `+`.

En los pasos 12, 13 y 14 de la traza el orden de las acciones de __Reduce__ es: `E+E`, luego `E*E`, y finalmente `E+E`.

Esto hace que la una agrupación de las operaciones sea `(1+2)*(3+4)`.

Por tanto, el evaluador produce `15`, que difiere del valor con precedencia aritmética estándar que es `11`.

# Gramática ambigua

 
```text
%%
...
E
			: E '+' E	{ $$ = $1 + $3; }
			| E '*' E	{ $$ = $1 * $3; }
			| '(' E ')'	{ $$ = $2; }
			| NUMBER	{ $$ = $1; }
			;
%%
...
```

# Gramática ambigua y directivas de precedencia y asociatividad

```text
...
%left '+' 
%left '*' 
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
```

