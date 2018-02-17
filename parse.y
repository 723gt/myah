%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <math.h>
  #include <string.h>

  #define YYDEBUG 1
  #define IDENTSIZE 16

  typedef struct _identmap{
    char name;
    double value;
  } identmap;
  
  identmap imap[IDENTSIZE];
  double getvalue(char name);
  int identregister(char name,double value);
  double it; 
%}

%union{
  int ival;
  double dval;
  char cval;
}

%token <ival> INTEGER IF THEN ELSE END EXIT
%token <dval> DOUBLE
%token <cval> LETTER
%token ADD SUB MUL DIV SUBSIT SEMICOL EQUAL NOT_EQUAL CR
/*
program: プログラム全体
expr: 式
term: 項
factor: 1次式
if_st: if文
 */
%type <dval> program expr term factor if_st block
%start program
%%
program: { $$ = it; }
       |block CR
       { 
        $$ = it = $1;
        printf(">> %lf\n",it);
       }
       | block SEMICOL
       {
        printf(">>%lf\n",it);
       }
       |program block CR
       {
        $$ = it = $2;
        printf(">> %lf\n",it);
       }
       |program EXIT CR
       {
        $$ = it;
        printf(">> %lf\n",it);
       }
       ;
block: expr {$$ = $1;}
     |if_st {$$ = $1;}
     ;
if_st: IF expr EQUAL expr THEN expr END
     {
      if($2 == $4){
        $$ = $6;
      }
      else{
        $$ = -1;
      }
     }
     | IF expr NOT_EQUAL expr THEN expr END
     {
      if($2 != $4){
        $$ = $6;
      }
      else{
        $$ = -1;
      }
     }
     ;
expr: term {$$ = $1;}
    | LETTER SUBSIT expr {identregister($1,$3); $$ = $3;}
    | expr ADD term {$$ = $1 + $3;}
    | expr SUB term {$$ = $1 - $3;}
    ;
term: factor {$$ = $1;}
    | term MUL factor { $$ = $1 * $3;}
    | term DIV factor { $$ = $1 / $3;}
    ;
factor: INTEGER { $$ = (double) $1;}
      | DOUBLE { $$ = $1;}
      | LETTER {$$ = getvalue($1);}
      | factor LETTER { $$ = (double) $1 * getvalue($2);}
      | '('expr')' { $$ = $2;}
%%

int main(void){
  yyparse();
  return 0;
}

int yyerror(char *msg){
  fprintf(stderr,"ERROR:%s\n",msg);
  return 0;
}

int indexident(char name){
  int i;
  for( i = 0; i < IDENTSIZE; i++){
    if( imap[i].name == name){
      return i;
    }
  }
  return -1;
}

int identregister(char name,double value){
  int i = indexident(name);
  if( i == -1){
    static int usedi = 0;
    imap[usedi].name = name;
    imap[usedi].value = value;
    usedi++;
  }
  else{
    imap[i].value = value;
  }
  return 0;
}

double getvalue(char name){
  int i = indexident(name);
  if(i != -1){
    return imap[i].value;
  }
  else{
    printf("LOG:%c",name);
  }
  return 0.0;
}
