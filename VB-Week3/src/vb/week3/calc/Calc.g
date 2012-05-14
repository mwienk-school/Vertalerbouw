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

assignment
    :   IDENTIFIER (BECOMES^ expr)?
    ;
    
expr
    :   exprrelop
    |   exprif
    ;
    
exprrelop
    :   exprplus (options {greedy=true;} : (LESS^ | LESSEQ^ | MORE^ | MOREEQ^ | EQ^ | NEQ^) exprplus)*
    ;
    
exprplus
    :   exprtimes (options {greedy=true;} : (PLUS^ | MINUS^) exprtimes)*
    ;
    
exprtimes
    :   operand (options {greedy=true;} : (TIMES^ | DIVIDE^) operand)*
    ;
    
exprif
    :   IF^ expr THEN! expr ELSE! expr
    ;
    
operand
    :   NUMBER
    |   (options {greedy=true;} : assignment)
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

