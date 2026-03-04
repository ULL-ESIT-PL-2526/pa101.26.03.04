# Clase de problemas 04.03.26

Análisis sintáctico con **Bison/Flex** y **Jison**.

Se compara el comportamiento de gramáticas ambiguas frente a gramáticas con precedencia/asociatividad declarada.

Se observa cómo aparecen y se resuelven conflictos `shift/reduce`.

Enlaces de referencia:

- Manual de GNU Bison: https://www.gnu.org/software/bison/manual/
- Documentación de Jison: https://gerhobbelt.github.io/jison/docs/

## Estructura del directorio

- `bison/`: implementaciones y materiales con Bison.
  - `README.md`: explicación del autómata, conflictos shift/reduce y traza.
  - `ambigua/`: versión con gramática ambigua.
  - `prec/`: versión con precedencia/asociatividad.
- `jison/`: calculadora aritmética con Jison.
  - `src/arith.jison`: gramática + lexer.
  - `src/parser.js`: parser generado.
  - `src/index.js`: punto de entrada.

## Uso rápido

### 1) Bison

Desde el directorio `bison` (o en cada subdirectorio correspondiente):

```bash
make
./lr
```

Para depuración en la versión LR (si el `Makefile` incluye objetivos de debug):

```bash
make debug
./lr_dbg
```

### 2) Jison

Desde `jison/`:

```bash
npm install
npm run build
npm run start
```

## Notas de depuración

- En Bison, para traza de parsing:
  - generar con `-t` (o `--debug`) y `-v`
  - activar `yydebug = 1` en ejecución
- En Jison:
  - generar parser con `jison src/arith.jison -o src/parser.js`
  - activar traza en runtime con `parser.trace = console.log`
