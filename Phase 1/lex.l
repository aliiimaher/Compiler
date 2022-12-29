%{
	
#include <stdio.h>
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
add			":A:"
sub			":S:"
mul 		":M:"
div			":D:"

/* ========== Translation Rules ========== */
%%

\n 			{ch++; nl++;}
^{delim} 	{ch += yyleng;}
{delim} 	{ch += yyleng;}

{letter}	{ch++; nLetter++; nId++;}

{digit}		{ch += yyleng; nDigit++; nNumber++;}

{id}		{ch += yyleng; nId++;}

{number}	{ch += yyleng; nDigit += yyleng; nNumber++;}

{add}		{ch += yyleng; nOp++;}
{sub}		{ch += yyleng; nOp++;}
{mul}		{ch += yyleng; nOp++;}
{div}		{ch += yyleng; nOp++;}

. 			{ch++;}

%%

int yywrap(){}
int main() {
	yylex();
	printf("\n\tNumber Of Characters:%8d \
			\n\tNumber Of Newlines:%8d \
			\n\tNumber Of Ids:%8d \
			\n\tNumber Of Numbers:%8d \
			\n\tNumber Of Operations:%8d\n"
				, ch, nl, nId, nNumber, nOp);
}