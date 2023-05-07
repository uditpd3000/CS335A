%{
    #include <stdio.h>
	#include <string>
	#include <iostream>

	using namespace std;

    #include "parser.tab.h"

    FILE* input_file = NULL;

	extern void close_input_file();
	int eof=0;

	void report_error(int lineno, string illegal){
       cout<<"Error on line no "<<lineno<<", Unexpected character found: "<<illegal<<endl;
    }

	void close_file(){
		if(input_file){
			fclose(input_file);
		}
	}
	void set_input(char* filename){
		if(filename){
			yyin = fopen(filename,"r");
		}
	}


%}

%option yylineno

%%
[\n] {yylval.str=strdup("\n");return EOL;}
Title {yylval.str=yytext; return TITLE;}
Chapter {yylval.str=yytext; return CHAPTER;}
Section {yylval.str=yytext; return SECTION;}
[a-zA-Z]+ {yylval.str=yytext;return WORD;}
[0-9]+ {yylval.str=yytext; return NUM;}
[0-9]+.[0-9]+ {yylval.str=yytext; return FLOAT;}
[,;] {yylval.str=yytext;return WORD_SEPERATOR;}
[!] {yylval.str=yytext;return EXCLAMATION;}
"?" {yylval.str=yytext;return QUESTION;}
[:] {yylval.str =yytext;return COLON;}
[.] {yylval.str=yytext;return PERIOD;}
[ \t+-]+ {}

<<EOF>>	{eof++;if(eof==1)return End_of_file;else {close_file();yyterminate();} }
. {report_error(yylineno,yytext);}

%%


int yywrap(){}
