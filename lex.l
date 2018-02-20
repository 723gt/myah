%{
  #include <stdio.h>
  #include <string.h>
  #include "y.tab.h"

  int yywrap(void){
    return 1;
  }
%}

letter [a-zA-Z]+
add "+"
sub "-"
mul "*"
div "/"
subsit "="
equal "=="
not_equal "!="
semicolon ";"
cr  "\n"
integer [0-9]+
double [0-9]+\.[0-9]+
increment "++"

%%
{add} return ADD;
{sub} return SUB;
{mul} return MUL;
{div} return DIV;
{subsit} return SUBSIT;
{equal} return EQUAL;
{not_equal} return NOT_EQUAL;
{semicolon} return SEMICOL;
{cr} return CR;
{increment} return INCREMENT;

"let" return LET;



{integer} {
  sscanf(yytext,"%d",&yylval.ival);
  return INTEGER;
}

{double} {
  sscanf(yytext,"%lf",&yylval.dval);
  return DOUBLE;
}

"if" {
  return IF;
}

"then" {
  return THEN;
}

"else" {
  return ELSE;
}

"end" {
  return END;
}

"exit" {
  return EXIT;
}
{letter} {
  //yylval.cval = yytext[0];
  strcpy(yylval.cval,yytext);
  return LETTER;
}
%%
