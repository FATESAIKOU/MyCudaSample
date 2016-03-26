#ifndef FILEPARSER_INCLUDED
#define FILEPARSER_INCLUDED

#define COLUMN_NUM 12

typedef struct Matching_Base {
    char ***sample_records;
    int record_num;
} MatchBase;


void getAttribute(char *str, int changing);
void readFile(char *filename, MatchBase *match_base);

#endif
