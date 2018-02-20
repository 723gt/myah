#include "incdec.h"
#include "y.tab.h"

double setincrement(char *name,double value,int settype){
  if(value != 0.0){
    identregister(name,value + 1);
    switch(settype) {
      case BEFORE:
        return value + 1;
      case AFTER:
        return value;
    }
  }
  else{
    return value;
  }
}

double setdecrement(char *name,double value,int settype){
  if(value != 0.0){
    identregister(name,value - 1);
    switch(settype){
      case BEFORE:
        return value - 1;
      case AFTER:
        return value;
    }
  }
  else{
    return value;
  }
}
