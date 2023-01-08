%option noinput nounput
%{
	
#include <stdio.h>	
#include <string.h>

typedef char* YYSTYPE;

#define YYSTYPE_IS_DECLARED 1

#include "y.tab.h"

// Variables for counting tokens and characters
int ch = 0, nl = 0, nLetter = 0, nDigit = 0, 
	nId = 0, nNumber = 0, nOp = 0;
	
%}

/* ========== Regular definitions ========== */
/* Delimiters */
delim		[ \t\n]+

/* White Spaces */
ws 			{delim}+

/* Letters */
letter 		[A-Za-z]

/* Digits */
digit		[0-9]

/* Id or Variables */
id 			{letter}({letter}|{digit})*

/* Number */
number		[+\-]?{digit}+(\.{digit}+)?

/* Operations */
add			:A:
sub			:S:
mul 		:M:
div			:D:


/* ========== Translation Rules ========== */
%%

\n 			{ ch++; nl++; }
^{delim} 	{ ch += yyleng; }
{delim} 	{ ch += yyleng; }

{letter}	{ ch++; nLetter++; nId++;
			yylval = malloc(1000); strcpy(yylval, yytext); return ID; }

{digit}		{ ch += yyleng; nDigit++; nNumber++;
			yylval = malloc(1000); strcpy(yylval, yytext); return NUMBER; }

{id}		{ ch += yyleng; nId++; 
			yylval = malloc(1000); strcpy(yylval, yytext); return ID; }

{number}	{ ch += yyleng; nDigit += yyleng; nNumber++;
			yylval = malloc(1000); strcpy(yylval, yytext); return NUMBER; }

{add}		{ ch += yyleng; nOp++; return ADD; }
{sub}		{ ch += yyleng; nOp++; return SUB; }
{mul}		{ ch += yyleng; nOp++; return MUL; }
{div}		{ ch += yyleng; nOp++; return DIV; }

[\(\)\{\}=]	{ ch++; return *yytext; }

. 			{ ch++; }

%%

// Calling yywrap helps us by providing the outputs
// return 1 when you are done with lex file
// return 0 when more processing is required
int yywrap(){}

// We don't need main or calling yylex, because yyparse in yacc.y calls
// the yylex too.
// int main() {
	// yylex();
// }