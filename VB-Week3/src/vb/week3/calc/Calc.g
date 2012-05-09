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
    :   declarations statements EOF
            ->  ^(PROGRAM declarations statements)
    ;
    
declarations
    :   (declaration SEMICOLON!)*
    ;
    
statements
    :   (statement SEMICOLON!)+
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
    :   lvalue BECOMES^ expr
    ;


print_stat
    :   PRINT^ LPAREN! expr RPAREN!
    ;
    
swap_stat
    :   SWAP^ LPAREN! IDENTIFIER COMMA! IDENTIFIER RPAREN!
    ;

lvalue
    :   IDENTIFIER
    ;
    
expr
    :   exprtimes ((PLUS^ | MINUS^) exprtimes )*
    |   IF^ expr THEN! expr ELSE! expr
    ;
    
exprtimes
    :   operand ((TIMES^ | DIVIDE^) operand )*
    ;
    
operand
    :   IDENTIFIER
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

