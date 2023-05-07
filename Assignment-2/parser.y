%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <iostream>
    #include <string>
    #include <cstring>
    #include <vector>

    using namespace std;

    extern FILE *yyin;
    extern int yyparse();
    extern int yylex();
    extern int yyerror(char *s);
    extern int yylineno;
    extern char* yytext;

    char * title;
    string mytitle;
    int key=0;
    int chapter_count,paragraph_count,word_count,section_count,sentence_count,declar_st,interr_sent,exclam_sent,wordss = 0 ;
    vector <string> toc;

%}


%union{
    char* str;
}
%token<str> EOL COLON WORD_SEPERATOR QUESTION PERIOD EXCLAMATION NUM FLOAT WORD TITLE CHAPTER SECTION
%type<str> sentence words titleLine sentences paragraph paragraphs sectionLine chapterLine section sections start chapters
%token End_of_file
%%

start: titleLine EOLs chapters

;
chapters: chapter
| chapter chapters
;

chapter: chapterLine EOLs chapterBody 
;

chapterBody: sections
| paragraphs
| paragraphs sections
| sections paragraphs
;

sections: section
| sections section
;

section: sectionLine EOLs paragraphs
;

paragraphs: paragraph {paragraph_count++;}
| paragraph paragraphs{paragraph_count++;}
;

paragraph: sentences EOLEOL
| sentences EOLEOL paragraph {paragraph_count++;} 
| sentences EOL End_of_file
| sentences End_of_file
;

sentences: sentence { sentence_count++;}
| sentences sentence {sentence_count++;}
;
sentence: words PERIOD {word_count+=wordss;wordss=0;declar_st++;}
| words EXCLAMATION {word_count+=wordss;wordss=0;exclam_sent++;}
| words QUESTION {word_count+=wordss;wordss=0;interr_sent++;}
;

words: WORD {wordss++;} 
| words WORD {wordss++;}
| words WORD_SEPERATOR 
| words NUM
| words FLOAT
;

titleLine: TITLE COLON words {mytitle= $3;wordss=0;}
;

chapterLine: CHAPTER NUM COLON words {chapter_count++;toc.push_back(string($1));wordss=0;}
;

sectionLine: SECTION FLOAT COLON words{section_count++;toc.push_back("    "+ string($1));wordss=0;}
;

EOLs : EOL 
| EOL EOLs
;

EOLEOL : EOL EOL
| EOLEOL EOLs
;



%%

int yyerror(char* msg)
{
	cout <<"Error: Found \"" <<yytext<<"\" on line no: " << yylineno <<  endl;
    return 0;

}
