#include "incdec.h"

void setincrement(char name,double value,int settype){
  if(value != 0.0){
    identregister(name,value + 1);
    switch(settype) {
      case 0:
        $$ = value + 1;
        break;
      case 1:
        $$ = value;
        break;
    }
  }
  else{
    $$ = getval;
  }
}
