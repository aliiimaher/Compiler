# Compiler
Design a tiny compiler with `Lex` and `Yacc`.

## About
The project has been divided into three phases.
```mermaid
flowchart TD;
    A[Compiler]--Phase 1-->B[Lexical Analysis];
    A[Compiler]--Phase 2-->C[Syntax Analysis];
    A[Compiler]--Phase 3-->D[Intermediate Code Generation];
```

## Running
```
  flex  lex.l
  gcc   lex.yy.c
        a.exe
```        
