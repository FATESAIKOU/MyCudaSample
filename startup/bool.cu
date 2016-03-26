#include <stdio.h>
#include <stdlib.h>

bool **global_space;

bool **genGlobalSpace(int row, int column){
  srand((unsigned)time(NULL));

  bool **local_space = (bool **)malloc(sizeof(bool *) * row);
  int i, j;
  for(i=0; i<row; i++){
    local_space[i] = (bool *)malloc(sizeof(bool) * column);
    for(j=0; j<column; j++){
      local_space[i][j] = rand()%2;
    }
  }

  return local_space;
}

int main(){

  int i, j;
  for(i=0; i<100; i++){
    printf("Clild -%d- ", i);
    for(j=0; j<10; j++){
      printf("%d", global_space[i][j]);
    }
    printf("\n");
  }

  return 0;
}
