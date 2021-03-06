%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <math.h>
  #include <string.h>
  #include "incdec.h"

  #define YYDEBUG 1
  #define IDENTSIZE 16

  typedef struct _identmap{
    char name[255];
    double value;
  } identmap;
  
  identmap imap[IDENTSIZE];
  double getvalue(char *name);
  int identregister(char *name,double value);
  double it; 
%}

%union{
  int ival;
  double dval;
  char cval[255];
}

%token <ival> INTEGER IF THEN ELSE END EXIT LET
%token <dval> DOUBLE
%token <cval> LETTER
%token ADD SUB MUL DIV SUBSIT SEMICOL EQUAL NOT_EQUAL CR INCREMENT DECREMENT
/*
program: プログラム全体
expr: 式
term: 項
factor: 1次式
if_st: if文
 */
%type <dval> program expr term factor blocks block sep
%start program
%%
program: { $$ = it; }
       |blocks CR
       { 
        $$ = it = $1;
        printf(">> %lf\n",it);
       }
       | blocks SEMICOL
       {
        printf(">>%lf\n",it);
       }
       |program blocks CR
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
sep: SEMICOL CR
   | CR;
blocks: expr {$$ = $1;}
      | blocks sep expr { $$ = $1;}
      |block {$$ = $1;}
     ;
block: IF expr THEN sep blocks sep END
     {
      if($2){
        $$ = $5;
      }
      else{
        $$ = -1;
      }
     }
     ;
expr: term {$$ = $1;}
    | LETTER SUBSIT term { $$ = $3;}
    | LETTER SUBSIT expr {identregister($1,$3); $$ = $3;}
    | expr EQUAL expr
    {
      if($1 == $3){
        $$ = 1;
      }
      else{
        $$ = -1;
      }
    }
    | expr NOT_EQUAL expr
    {
      if($1 != $3){
        $$ = 1;
      }
      else{
        $$ = -1;
      }
    }
    | LETTER DECREMENT
    {
      double getval = getvalue($1);
      $$ = setdecrement($1,getval,AFTER);
    }
    | LETTER INCREMENT 
    {
      double getval = getvalue($1);
      $$ = setincrement($1,getval,AFTER);
    }
    | DECREMENT LETTER 
    {
      double getval = getvalue($2);
      $$ = setdecrement($2,getval,BEFORE);
    }
    | INCREMENT LETTER 
    {
       double getval = getvalue($2);
       $$ = setincrement($2,getval,BEFORE);
    }
    | expr ADD term {$$ = $1 + $3;}
    | expr SUB term {$$ = $1 - $3;}
    ;
term: factor {$$ = $1;}
    | LET LETTER {identregister($2,0);$$ = 0;}
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

int indexident(char *name){
  int i;
  for( i = 0; i < IDENTSIZE; i++){
    if(strcmp(imap[i].name,name) == 0){
      return i;
    }
  }
  return -1;
}

int identregister(char *name,double value){
  int i = indexident(name);
  if( i == -1){
    static int usedi = 0;
    strcpy(imap[usedi].name,name);
    imap[usedi].value = value;
    usedi++;
  }
  else{
    imap[i].value = value;
  }
  return 0;
}

double getvalue(char *name){
  int i = indexident(name);
  if(i != -1){
    return imap[i].value;
  }
  else{
    printf("LOG:%s",name);
  }
  return 0.0;
}
