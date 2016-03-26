%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "fileParser.h"

    char *content;

    int record_limit;
    int record_counter;

    int record_attr_num;
    int record_attr_counter;

    char ***records;

    void getAttribute(char *str, int changing);
%}

%%
^@id:.*            { getAttribute(yytext, 1);}
^@title:.*         { getAttribute(yytext, 0);}
^@published:.*     { getAttribute(yytext, 0);}
^@content:.*       { getAttribute(yytext, 0);}
^@category:.*      { getAttribute(yytext, 0);}
^@duration:.*      { getAttribute(yytext, 0);}
^@favoriteCount:.* { getAttribute(yytext, 0);}
^@$viewCount:.*    { getAttribute(yytext, 0);}
^@author:.*        { getAttribute(yytext, 0);}
^@keyword:.*       { getAttribute(yytext, 0);}
^@_uid:.*          { getAttribute(yytext, 0);}

^@\n    {}
.*  {}
\n {}

%%

void getAttribute(char *str, int changing) {
    int i;
    if (changing) {
        record_attr_counter = 0;
        records[++ record_counter] = (char**) malloc(sizeof(char*) * record_attr_num);

        for (i = 0; i < COLUMN_NUM; i ++)
            records[record_counter][i] = strdup("");

        if (record_counter == record_limit - 1) {
            record_limit += 1024;
            records = (char***) realloc(records, sizeof(char**) * record_limit);
        }
    }

    content = strchr(str, ':') + 1;
    free(records[record_counter][record_attr_counter]);
    records[record_counter][record_attr_counter ++] = strdup(content);
}

void readFile(char *filename, MatchBase *match_base) {
    record_limit = 1024;
    record_attr_num = COLUMN_NUM;
    record_counter = -1;
    record_attr_counter = COLUMN_NUM;
    records = (char***) malloc(sizeof(char**) * record_limit);

    yyin = fopen(filename, "r");

    yylex();

    records = (char***) realloc(records, sizeof(char**) * record_counter);
    match_base->sample_records = records;
    match_base->record_num = record_counter;
}
