%{
	
#include <stdio.h>
int ch= 0, wd= 0, nl= 0, nDigit = 0, nNumber = 0, nOp = 0;

%}

/* ========== Regular definitions ========== */
/* Delimiters */
delim		[ \t\n]+

/* White Spaces */
ws 			{delim}+

/* Digits */
digit		[0-9]

/* Number */
number		[+\-]?{digit}+(\.{digit}+)?

/* Operations */
add			":A:"
sub			":S:"
mul 		":M:"
div			":D:"

/* ========== Translation Rules ========== */
%%

\n 			{ch++; wd++; nl++;}
^{delim} 	{ch += yyleng;}
{delim} 	{ch += yyleng; wd++;}

{digit}		{ch += yyleng; nDigit++;}

{number}	{ch += yyleng; nDigit += yyleng; wd++; nNumber++;}

{add}		{ch += yyleng; wd++; nOp++;}
{sub}		{ch += yyleng; wd++; nOp++;}
{mul}		{ch += yyleng; wd++; nOp++;}
{div}		{ch += yyleng; wd++; nOp++;}

. 			{ch++;}

%%

int yywrap(){}
int main() {
	yylex();
	printf("\tNumber Of Characters:%8d \
			\n\tNumber Of Words:%8d \
			\n\tNumber Of Newlines:%8d \
			\n\tNumber Of Digits:%8d \
			\n\tNumber Of Numbers:%8d \
			\n\tNumber Of Operations:%8d\n"
				, ch, wd, nl, nDigit, nNumber, nOp);
}