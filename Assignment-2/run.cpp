#include <iostream>
#include <string>
#include <vector>
#include <fstream>

using namespace std;

#include "parser.tab.h"

extern int yyparse();

extern void set_input(char* filename);

extern string mytitle;
extern int chapter_count,paragraph_count,word_count,section_count,sentence_count,declar_st,interr_sent,exclam_sent;
extern vector<string> toc;

int main(int argc, char** argv)
{

	if (argc == 2)set_input(argv[1]);
	
	int rlt = yyparse();

	ofstream myfile;
  	myfile.open ("output.txt");

	myfile<<"Title: ";
	for(auto it:mytitle){
		myfile<<it;if(it=='\n')break;
	}
	myfile<<"Chapter = "<<chapter_count<<endl;
	myfile<<"Sections = "<<section_count<<endl;
	myfile<<"Paragraphs = "<<paragraph_count<<endl;
	myfile<<"Sentences = "<<sentence_count<<endl;
	myfile<<"Declarative Sentences = "<<declar_st<<endl;
	myfile<<"Interrogative Sentences = "<<interr_sent<<endl;
	myfile<<"Exclamatory Sentences = "<<exclam_sent<<endl;
	myfile<<"Words = "<<word_count<<endl;
	myfile<<endl;
	myfile<<"Table of Contents"<<endl;
	for(auto i:toc){
		for (auto it:i){
			myfile<<it;if(it=='\n')break;
		}
	}
	return 0;
}