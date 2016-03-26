extern "C" {
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "flex/fileParser.h"
}

__global__ void showRecord(char ***records, int rec_id, int attr_num) {
    int i;

    for (i = 0; i < attr_num; i ++) {
        printf("true!! : %s\n", records[rec_id][i]);
    }
}


__global__ void showMatchBase(MatchBase *match_base, int base) {
    int t_id = threadIdx.x;
    int b_id = blockIdx.x;
    int b_dim = blockDim.x;
    int index = base + b_id * b_dim + t_id;
    int j = 0;

    if (index < match_base->record_num) {
        printf("---record %d---\n", index);
        for (j = 0; j < 12; j ++) {
            printf("true!! : %s\n", match_base->sample_records[index][j]);
        }
        printf("\n");
    }
}

int recordCpy(char ***G_record, char **record, int attr_num) {
    int i;
    int attr_len;

    char **tmp_attrs;
    char *tmp_attr;
    cudaMalloc(&tmp_attrs, sizeof(char*) * attr_num);
    for (i = 0; i < attr_num; i ++) {
        attr_len = strlen(record[i]);
        cudaMalloc(&tmp_attr, sizeof(char) * attr_len);
        cudaMemcpy(tmp_attr, record[i], sizeof(char) * attr_len, cudaMemcpyHostToDevice);

        cudaMemcpy(tmp_attrs + i, &tmp_attr, sizeof(char*), cudaMemcpyHostToDevice);
    }

    cudaMemcpy(G_record, &tmp_attrs, sizeof(char**), cudaMemcpyHostToDevice);

    return attr_num;
}

int recordsCpy(char ****G_records, char ***records, int record_num) {
    int i;

    char ***tmp_records;
    cudaMalloc(&tmp_records, sizeof(char**) * record_num);

    for (i = 0; i < record_num; i ++) {
        recordCpy(tmp_records + i, records[i], 11);
    }

    *G_records = tmp_records;
    return record_num;
}

int main(int argc, char *argv[]) {
    char *filename = argv[1];
    MatchBase match_base;

    readFile(filename, &match_base);

    // gen cloned G_match_base
    MatchBase *H_match_base = (MatchBase*) malloc(sizeof(MatchBase));
    H_match_base->record_num = match_base.record_num;
    recordsCpy(&(H_match_base->sample_records), match_base.sample_records, match_base.record_num);
    //H_match_base->record_num = 102400;
    //recordsCpy(&(H_match_base->sample_records), match_base.sample_records, 102400);

    // gen G_match_base
    MatchBase *G_match_base;
    cudaMalloc(&G_match_base, sizeof(MatchBase));
    cudaMemcpy(G_match_base, H_match_base, sizeof(MatchBase), cudaMemcpyHostToDevice);

    // show data
    //showMatchBase<<<1, 1024>>>(G_match_base, 0);

    // reset
    //cudaDeviceReset();

    // return & free
    cudaFree(H_match_base);
    return 0;
}
