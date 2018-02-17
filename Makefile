myaha: y.tab.c lex.yy.c
	gcc -o myaha y.tab.c lex.yy.c
lex.yy.c: lex.l
	flex lex.l
y.tab.c: parse.y
	yacc -d -t parse.y
