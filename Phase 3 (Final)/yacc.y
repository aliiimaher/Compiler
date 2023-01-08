%{

#include <stdio.h>
#include<stdlib.h>
#include <ctype.h> 
#include <string.h>

#define YYSTYPE_IS_DECLARED 1

typedef char* YYSTYPE;

/* ========== Functions Declaration ========== */
char* calculate(char* op1, char operation, char* op2);
int yylex(void);
int yyerror(char* s);

// Variables which is used in the lex files
extern int ch, nl, nLetter, nDigit, nId, nNumber, nOp;

// "tCounter" for numbering the temporary variables
// "nOpForLastOutput" for counting number of the operations
int tCounter = 1;
int nOpForLastOutput = 0;

%}

/* ========== Declaration of Named Tokens ========== */
%token DELIM
%token WS
%token LETTER
%token DIGIT
%token ID
%token NUMBER

%token ADD
%token SUB
%token MUL
%token DIV

/* ========== Associativity and Precedence ========== */
%right ADD SUB
%right MUL DIV


/* ========== Translation Rules ========== */
%%

SS:			S					{ printf("\nThree-address-code generated!\n"); }
		;

S: 			ID '=' expr 		{ printf("%s = %s;", $1, $3); }
		;

expr: 		expr ADD expr		{ if (nOpForLastOutput > 1) $$ = calculate($3, '+', $1); 
									else {$$ = malloc(100); sprintf($$, "%s + ", $3); 
									strcat($$, $1);} }
									
		|	expr SUB expr		{ if (nOpForLastOutput > 1) $$ = calculate($3, '-', $1); 
									else {$$ = malloc(100); sprintf($$, "%s - ", $3); 
									strcat($$, $1);} }
									
		|	expr MUL expr		{ if (nOpForLastOutput > 1) $$ = calculate($3, '*', $1); 
									else {$$ = malloc(100); sprintf($$, "%s * ", $3); 
									strcat($$, $1);} }
									
		|	expr DIV expr		{ if (nOpForLastOutput > 1) $$ = calculate($3, '/', $1); 
									else {$$ = malloc(100); sprintf($$, "%s / ", $3); 
									strcat($$, $1);} }
									
		|	'(' expr ')'		{ $$ = $2; }
		| 	ID
		| 	NUMBER
		;
		
%%

int main() {
	// Get input from user
	printf("\n= = = = = = = = = = = = = = = = = = = = \n");	
	printf("\nEnter input: ");
	char input[50];
	fgets(input, sizeof(input), stdin);
	
	// Check for number of operations used in input string
	const char* addFinder = ":A:";
	const char* subFinder = ":S:";
	const char* mulFinder = ":M:";
	const char* divFinder = ":D:";
	char *mystring = input;
	char *c = mystring;
	while (*c)
	{
		if (strchr(addFinder, *c))
			{
				nOpForLastOutput++;
			}
		else if (strchr(subFinder, *c))
			{
				nOpForLastOutput++;
			}
		else if (strchr(mulFinder, *c))
			{
				nOpForLastOutput++;
			}
		else if (strchr(divFinder, *c))
			{
				nOpForLastOutput++;
			}
		c++;
	}
	
	// in the above code the counter increases for each
	// single character, so we need to divide it by 3
	nOpForLastOutput = nOpForLastOutput / 3;
	// printf("%d\n", nOpForLastOutput);
	
	
	// In the yyparse we have a function which get input
	// from user, so we should enter the same input again.
	// But with "ungetc" function we can handle it as belowe:
	// It automaticly put the entered input before, in the
	// yyparse input buffer.
	int len = strlen(input);
	for (int i = len - 1; i >= 0; i--) {
		ungetc(input[i], stdin);
	}
	
	
	// Calling yyparse which call the lex, parse three and
	// at the same time it translate. And finally generate
	// the three-address-code.
	yyparse();
	
	
	// Information of lex file
	printf("\n= = = = = = = = = = = = = = = = = = = = \n");
	printf("\nHere are some information from lex file:");
	printf("\n\tNumber Of Characters:%8d \
			\n\tNumber Of Newlines:%8d \
			\n\tNumber Of Ids:%8d \
			\n\tNumber Of Numbers:%8d \
			\n\tNumber Of Operations:%8d\n"
				, ch, nl, nId, nNumber, nOp);
	printf("\n= = = = = = = = = = = = = = = = = = = = \n");
	
	
	return 0;
}


// This function create the temporary variable, then fill it
// with operand1, operand2 and operation which called in the
// translation rules.
char* calculate(char* op1, char operation, char* op2) {
	printf("\nt%d = %s %c %s;",tCounter, op1, operation, op2);
	tCounter++;
	nOpForLastOutput--;
	char* temp = malloc(100);
	sprintf(temp, "t%d", tCounter -  1);
	return temp;
}

// Error Detection
int yyerror (char* s) {
   fprintf (stderr, "%s\n", s);
}