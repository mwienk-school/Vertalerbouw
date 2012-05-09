grammar Calc;

options {
    k=1;                                // LL(1) - do not use LL(*)
    language=Java;                      // target language is Java (= default)
    output=AST;                         // build an AST
}

tokens {
    COLON       =   ':'     ;
    SEMICOLON   =   ';'     ;
    LPAREN      =   '('     ;
    RPAREN      =   ')'     ;
    COMMA       =   ','     ;

    // operators
    BECOMES     =   ':='    ;
    PLUS        =   '+'     ;
    MINUS       =   '-'     ;
    TIMES       =   '*'     ;
    DIVIDE      =   '/'     ;
    
    LESS        =   '<'     ;
    LESSEQ      =   '<='    ;
    MORE        =   '>'     ;
    MOREEQ      =   '>='    ;
    EQ          =   '=='    ;
    NEQ         =   '!='    ;

    // keywords
    PROGRAM     =   'program'   ;
    VAR         =   'var'       ;
    PRINT       =   'print'     ;
    SWAP        =   'swap'      ;
    INTEGER     =   'integer'   ;
    IF          =   'if'        ;
    THEN        =   'then'      ;
    ELSE        =   'else'      ;
}

@lexer::header {
package vb.week3.calc;
}

@header {
package vb.week3.calc;
}

// Parser rules

program
    : statements EOF
       ->  ^(PROGRAM statements)
    ;

statements
    :   ((declaration SEMICOLON!)* statement SEMICOLON!)+
    ;

declaration
    :   VAR^ IDENTIFIER COLON! type
    ;
    
statement
    :   assignment
    |   print_stat
    |   swap_stat
    ;

assignment
    :   expr
    ;

//lvalue
//    :   IDENTIFIER
//    ;
//    
//rvalue
//    :   expr
//    |   assignment
//    ;

print_stat
    :   PRINT^ LPAREN! expr RPAREN!
    ;
    
swap_stat
    :   SWAP^ LPAREN! IDENTIFIER COMMA! IDENTIFIER RPAREN!
    ;

expr
    :   exprrelop
    |   exprifelse
    ;
    
exprrelop
    :   exprplus ((LESS^ | LESSEQ^ | MORE^ | MOREEQ^ | EQ^ | NEQ^) exprplus)*
    ;
    
exprplus
    :   exprtimes ((PLUS^ | MINUS^) exprtimes )*
    ;
    
exprtimes
    :   operand ((TIMES^ | DIVIDE^) operand )*
    ;
    
exprifelse
    :   IF^ expr THEN! expr ELSE! expr
    ;
    
operand
    :   IDENTIFIER (BECOMES^ IDENTIFIER)* 
    |   NUMBER
    |   LPAREN! expr RPAREN!
    ;

type
    :   INTEGER
    ;


// Lexer rules

IDENTIFIER
    :   LETTER (LETTER | DIGIT)*
    ;

NUMBER
    :   DIGIT+
    ;


COMMENT
    :   '//' .* '\n' 
            { $channel=HIDDEN; }
    ;

WS
    :   (' ' | '\t' | '\f' | '\r' | '\n')+
            { $channel=HIDDEN; }
    ;

fragment DIGIT  :   ('0'..'9') ;
fragment LOWER  :   ('a'..'z') ;
fragment UPPER  :   ('A'..'Z') ;
fragment LETTER :   LOWER | UPPER ;

// EOF

