myaha: y.tab.c lex.yy.c
	gcc -o myaha incdec.c y.tab.c lex.yy.c -DYYERROR_VERBOSE
lex.yy.c: lex.l
	flex lex.l
y.tab.c: parse.y
	yacc -d -t parse.y
