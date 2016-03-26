extern "C" {
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "flex/fileParser.h"

int recordCpy(char ***G_records, char **record, int attr_num) {
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

    cudaMemcpy(G_records, &tmp_attrs, sizeof(char**), cudaMemcpyHostToDevice);

    return attr_num;
}
}

int main(int argc, char *argv[]) {
    char *filename = argv[1];
    MatchBase match_base;

    readFile(filename, &match_base);

    int i;
    char ***G_records;
    cudaMalloc(&G_records, sizeof(char**) * match_base.record_num);
    for (i = 0; i < match_base.record_num; i ++) {
        recordCpy(G_records + i, match_base.sample_records[i], COLUMN_NUM);
    }


    MatchBase *G_match_base, tmp_G_match_base;
    cudaMalloc(&G_match_base, sizeof(MatchBase));
    tmp_G_match_base.sample_records = G_records;
    tmp_G_match_base.record_num = match_base.record_num;

    cudaMemcpy(G_match_base, &tmp_G_match_base, sizeof(MatchBase), cudaMemcpyHostToDevice);
    return 0;
}
