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
    DO          =   'do'        ;
    WHILE       =   'while'     ;
    OPERAND     =   'operand'   ;
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
    :   print_stat
    |   swap_stat
    |   dowhile_stat
    |   expr
    ;

print_stat
    :   PRINT^ LPAREN! expr RPAREN!
    ;
    
swap_stat
    :   SWAP^ LPAREN! IDENTIFIER COMMA! IDENTIFIER RPAREN!
    ;
    
dowhile_stat
    :   DO dostms WHILE expr
        ->  ^(DO expr dostms)
    ;

dostms
    :   (statement SEMICOLON!)+
    ;
    
expr
    :   IF^ expr THEN! expr ELSE! expr
    |   BECOMES^ expr
    |   operand exprhigh?
    ;
    
exprhigh
    :   (LESS^ | LESSEQ^ | MORE^ | MOREEQ^ | EQ^ | NEQ^)? exprmid
    ;
    
exprmid
    :   (PLUS^ | MINUS^)? exprlow
    ;
    
exprlow
    :   (TIMES^ | DIVIDE^)? expr
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

