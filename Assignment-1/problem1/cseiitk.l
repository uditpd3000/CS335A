%{
    #include <iostream>
    #include <map>
    #include <string.h>
    #include <fstream>
    #include <vector>
    #include <algorithm>

    using namespace std;

    map<string, pair<string,pair<int,int>>> mymap;  // To store the lexeme, token, count and its order in appearance

    int num=0;

    void insertMap(string lexeme, string token){ // To insert the currently found lexeme into the map 
        if(mymap.find(lexeme)!=mymap.end()){
            mymap[lexeme].second.first++;
        }
        else {
            mymap.insert({lexeme,{token,{1,num++}}});
        }
    }

    bool helper(pair<string,pair<string,pair<int,int>>> &a, pair<string,pair<string,pair<int,int>>>&b){  /* Helper function to sort the output in the order which they appeared in the file */
        return a.second.second.second < b.second.second.second;
    }

    void mysort( map<string, pair<string,pair<int,int>>> &m, vector<pair<string,pair<string,pair<int,int>>>> &vec){    /* I am sorting the vector on basis of the apperance of that lexeme */
        
        for(auto it: m){
            vec.push_back(it);
        }
        sort(vec.begin(),vec.end(),helper);
    }

    void report_error(int lineno, string illegal){                                        /* Functiojn to display error message */
       cout<<"Error on line no "<<lineno<<", Unexpected character found: "<<illegal<<endl;
    }

    void helper1(string s, int caseno){     /* Handle the .. delimiter */
        int siz = s.length();
        int count=0;
        string z="";
        for(int i=0;i<siz;i++){
            if(count==0&&s[i]=='.'){count++;insertMap(z,"Literal");z="";}
            else if(s[i]!='.' && s[i]!=' ')z.push_back(s[i]);
            else if(count==1 && s[i]=='.')insertMap("..","Delimiter");       
        }
        if(caseno==0)insertMap(z,"Literal");
        else insertMap(z,"Identifier");
    }

    void helper2(string s, int caseno){    /* Handle the . operator */
        int siz= s.length();
        int count=0;
        string z="";
        for(int i=0;i<siz;i++){
            if(count==0&&s[i]=='.'){count++;if(caseno==0)insertMap(z,"Identifier");else insertMap(z,"Literal") ;z="";insertMap(".","Operator");}
            else if(s[i]!='.' && s[i]!=' ')z.push_back(s[i]);          
        }
        if(caseno==0)insertMap(z,"Literal");
        else insertMap(z,"Identifier");
    }
%}
%option yylineno

string ["]([^"\n]|\\\")*["]
float ([0-9][0-9]*)("."?[0-9]*)
delimiter ","|";"|":"|"("|")"|"["|"]"|".."
exp {float}[eE][+-]?{float}
operator "+"|"-"|"*"|"/"|"."|":="|"="|"<>"|"<"|"<="|">="|">"|"^"|or|div|mod|in|not|and
identifier [a-zA-Z][a-zA-Z0-9]*

%%
"{"([^}])*"}" {}
[ \t\n\f\r]+ {}
{string} { insertMap(yytext,"String");}
{delimiter} {insertMap(yytext,"Delimiter");}
array|case|const|do|downto|else|file|for|function|goto|if|label|nil|of|packed|procedure|program|record|repeat|set|then|to|type|until|var|while|with|begin|end  {insertMap(yytext,"Keyword");}
{float}|{exp} {insertMap(yytext,"Literal");} 
{operator} {insertMap(yytext,"Operator");}
{identifier} {insertMap(yytext,"Identifier");}
[0-9]+".."[ \t]?[0-9]+ {helper1(yytext,0);}
[0-9]+".."[ \t]?[a-zA-Z][a-zA-Z0-9]* {helper1(yytext,1);}
"."[0-9]+ {report_error(yylineno,yytext);return 0;}
[a-zA-Z][a-zA-Z0-9]*"."[0-9]+ {helper2(yytext,0);}
[0-9]+"."[a-zA-Z][a-zA-Z0-9]* {helper2(yytext,1);}

. {report_error(yylineno,yytext);return 0;}
%%

int yywrap(){}

int main(int argc, char* argv[] )
{
    if(argc != 2) {
        printf("Input file expected\n");
    }
    else yyin = fopen(argv[1], "r" );
    yylex();
    ofstream outputFile;
    ofstream fs;
    fs.open("output.csv");
    fs << "Lexeme" << "," << "Token" << "," << "Count" << endl;
    vector<pair<string,pair<string,pair<int,int>>>> vec;
    mysort(mymap,vec);
    for(auto it:vec){
        fs<<it.first <<","<<it.second.first<<","<<it.second.second.first<<endl;
    }
    return 0;
}
