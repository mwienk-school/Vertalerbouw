grammar Calc;

options {
    k=2;                                // LL(1) - do not use LL(*)
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
    |   dowhile_stat
    ;

assignment
    :   lvalue ^BECOMES rvalue 
    ;

lvalue
    :   IDENTIFIER
    ;
    
rvalue
    :   expr
    |   assignment
    ;

print_stat
    :   PRINT^ LPAREN! expr RPAREN!
    ;
    
swap_stat
    :   SWAP^ LPAREN! IDENTIFIER COMMA! IDENTIFIER RPAREN!
    ;
    
dowhile_stat
    :   DO^ dostmts WHILE! expr
    ;
    
dostmts
    :   (statement SEMICOLON!)+
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

