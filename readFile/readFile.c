#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ROUNDMEM 1024
#define COLUMN_NUM 9

char *ungets(char *str, FILE *fptr) {
    char *end_of_str = strchr(str, '\0');

    while (str <= --end_of_str) {
        ungetc(*end_of_str, fptr);
    }

    return str;
}

char *getAttribute(FILE *fptr, char *end_str) {
    int now_len = 1024000;
    char *attribute = (char *) malloc(sizeof(char) * now_len);
    char *end_of_attribute = attribute;

    while (fgets(end_of_attribute, 1023, fptr) != NULL) {
        if ((end_of_attribute = strstr(end_of_attribute, end_str)) != NULL) {
            *( ungets(end_of_attribute, fptr) ) = '\0';
            break;
        } else {
            end_of_attribute = strchr(attribute, '\0');
        }
    }

    if ( !sscanf(attribute, "%*[^:]:%[^\n]\n", attribute) ) attribute[0] = '\0';
    attribute = (char*) realloc(attribute, sizeof(char) * (end_of_attribute - attribute) + 3);

    printf("%s\n\n", attribute);

    return attribute;
}

char **getRecord(FILE *fptr) {
    char **record = (char**) malloc(sizeof(char*) * 12);

    {
        getAttribute(fptr, "@id");
        record[0] = getAttribute(fptr, "@title");
        record[1] = getAttribute(fptr, "@published");
        record[2] = getAttribute(fptr, "@content");
        record[3] = getAttribute(fptr, "@duration");
        record[4] = getAttribute(fptr, "@favoriteCount");
        record[5] = getAttribute(fptr, "@$viewCount");
        record[6] = getAttribute(fptr, "@author");
        record[7] = getAttribute(fptr, "@_uid");
    }

    record[8] = getAttribute(fptr, "@\n");

    return record;
}

void readHightFile(char *filename, char ****result, int *record_num, int *column_num) {
    FILE *fptr = fopen(filename, "r");

    char tmp[1024];
    char ***records = (char***) malloc(sizeof(char**) * (*record_num));
    int i = 0, j;

    *record_num = 1024;
    while ( (fgets(tmp, 1024, fptr)) != NULL ) {
        if (*record_num == i) {
            *record_num *= 1024;
            records = (char***) realloc(records, sizeof(char**) * (*record_num));
        }

        printf("----------count %d----------\n", i);
        records[i] = getRecord(fptr);

        i ++;
    }

    *column_num = 9;
    *record_num = i;
    *result = (char***) realloc(records, sizeof(char**) * (*record_num));
}

int main(int argc, char *argv[]) {
    char ***records;
    int record_num;
    int column_num;

    readHightFile(argv[1], &records, &record_num, &column_num);

    return 0;
}
