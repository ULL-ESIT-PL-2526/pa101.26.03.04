CC=gcc
BISON=bison
FLEX=flex
CFLAGS=-Wall -Wextra -O2
LDFLAGS=-lfl -lm

all: lr

lr: lr.tab.c lex.yy.c
	$(CC) $(CFLAGS) -DYYDEBUG=0 -o $@ lr.tab.c lex.yy.c $(LDFLAGS)

lr.tab.c lr.tab.h: lr.y
	$(BISON) -d lr.y

lex.yy.c: lr.l lr.tab.h
	$(FLEX) lr.l

clean:
	rm -f lr lr_dbg lr.tab.c lr.tab.h slr.tab.h lex.yy.c lr.output

run: lr
	./lr

debug:
	$(BISON) -d -t -v lr.y
	cp lr.tab.h slr.tab.h
	$(FLEX) lr.l
	$(CC) $(CFLAGS) -DYYDEBUG=1 -o lr_dbg lr.tab.c lex.yy.c $(LDFLAGS)

run-debug: debug
	./lr_dbg
