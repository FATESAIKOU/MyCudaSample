#include <stdio.h>
#include <stdlib.h>

#include "contral.h"

// ./ga seed q_num CCE generation
int main(int argc, char *argv[]){
  // check args
  if(argc != 5){
    fprintf(stderr, "Fuck!!\n");
    return 2;
  }

  // get args
  int seed        = atoi(argv[1]);
  int queen_num   = atoi(argv[2]);
  int CCE         = atoi(argv[3]);
  int generation  = atoi(argv[4]);

  // execution
  // ga_simulation(seed, queen_num, CCE, generation);

  // caculate output
  //

  // out put
  //

  return 0;
}
