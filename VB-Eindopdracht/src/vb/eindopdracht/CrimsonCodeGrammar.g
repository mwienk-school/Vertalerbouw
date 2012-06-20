grammar CrimsonCodeGrammar;

options {
  language = Java;
  output = AST;
  k = 1;
}

tokens {
  //Global
  PROGRAM   = 'program';
  SEMICOLON = ';';
  COLON     = ':';
  COMMA     = ',';
  APOS      = '\'';
  LCURLY    = '{';
  RCURLY    = '}';
  LPAREN    = '(';
  RPAREN    = ')';
  LSQUARE   = '[';
  RSQUARE   = ']';
  VAR       = 'spawn';
  CONST     = 'const';
  PARAM     = 'param';
  
  //Types
  INTEGER   = 'Int';
  BOOLEAN   = 'Pill';
  CHAR      = 'Char';
  STRING    = 'String';
  
  TRUE      = 'red';
  FALSE     = 'blue';
  
  PROC      = 'Proc';
  FUNC      = 'Func';
  
  TYPE      = 'Type';
  
  ARRAY     = 'Array';
  
  //Commands
  READ      = 'read';
  PRINT     = 'print';
  IF        = 'if';
  IFEND     = 'fi';
  THEN      = 'then';
  ELSE      = 'else';
  WHILE     = 'while';
  DO        = 'do';
  DOEND     = 'od';
  BECOMES   = '=';
  VARASSIGN = 'varassign';
  CCOMPEXPR = 'ccompexpr';
  
  //Logic operators
  LT        = '<';
  LE        = '<=';
  GT        = '>';
  GE        = '>=';
  EQ        = '==';
  NEQ       = '!=';
  OR        = '||';
  AND       = '&&';
  
  //Math operators
  PLUS      = '+';
  MINUS     = '-';
  TIMES     = '*';
  DIVIDE    = '/';
  UPLUS     = 'uplus';
  UMINUS    = 'uminus';
  DOTDOT    = '..';
}

@header {
  package vb.eindopdracht;
}
  
@lexer::header {
  package vb.eindopdracht;
}

//Parser regels

program
  :   compExpr EOF
      ->^(PROGRAM compExpr)
  ;

compExpr
  :   ( ( declaration SEMICOLON!)* expression SEMICOLON!)+
  ;

//Declaration  
declaration
  :   constDecl
  |   varDecl
  |   procDecl
  |   funcDecl
  |   typeDecl
  ;
  
constDecl
  :   CONST^ IDENTIFIER BECOMES! expression
  ;
  
varDecl
  :   VAR^ IDENTIFIER
  ;
  
procDecl
  :   PROC^ IDENTIFIER LPAREN! params RPAREN! ccompExpr
  ;
  
funcDecl
  :   FUNC^ IDENTIFIER LPAREN! params RPAREN! ccompExpr
  ;

params
  :   param (COMMA! param)*
  ;

param
  :   IDENTIFIER
        -> ^(PARAM IDENTIFIER)
  |   VAR^ IDENTIFIER
  ;

typeDecl
  :   TYPE^ IDENTIFIER LSQUARE! NUMBER DOTDOT! NUMBER (COMMA! NUMBER DOTDOT! NUMBER)? RSQUARE!
  ;
  
//Expression
expression
  :   assignExpr
  |   readExpr
  |   printExpr
  |   ccompExpr
  |   ifExpr
  |   whileExpr
  |   arrExpr
  ;

//Arithmatic expressions  
assignExpr
  :   arithExpr (BECOMES^ assignExpr)?
  ;

arithExpr
  :   andExpr (OR^ andExpr)*
  ;

andExpr
  :   compareExpr (AND^ compareExpr)*
  ;

compareExpr
  :   plusExpr ((LT^ | LE^ | GT^ | GE^ | EQ^ | NEQ^) plusExpr)*
  ;

plusExpr
  :   timesExpr ((PLUS^ | MINUS^) timesExpr)*
  ;
  
timesExpr
  :   unaryExpr ((TIMES^ | DIVIDE^) unaryExpr)*
  ;

unaryExpr
  :   operand
  |   PLUS operand
      -> ^(UPLUS operand)
  |   MINUS operand
      -> ^(UMINUS operand)
  ;
  
arrExpr
  :   LSQUARE expression (COMMA expression) RSQUARE
      -> ^(ARRAY expression+)
  ;

operand
  :   IDENTIFIER^ (LSQUARE! expression (COMMA! expression)? RSQUARE!)?
  |   TRUE
  |   FALSE
  |   NUMBER
  |   character
  |   LPAREN expression RPAREN
  ;

character
  :   APOS! LETTER APOS!
  ;

//Functional expressions  
readExpr
  :   READ^ LPAREN! varlist RPAREN!
  ;
  
varlist
  :   IDENTIFIER (COMMA! IDENTIFIER)*
  ;
    
printExpr
  :   PRINT^ LPAREN! exprlist RPAREN!
  ;
   
exprlist
  :   expression (COMMA! expression)*
  ;

ccompExpr
  :   LCURLY compExpr RCURLY
      -> ^(CCOMPEXPR compExpr)
  ;

whileExpr
  :   WHILE^ expression DO! expression DOEND!
  ;

ifExpr
  :   IF^ expression THEN! expression ELSE! expression IFEND!
  ;
  
//Lexer rules

COMMENT
  :   '//' .* '\n' 
        { $channel=HIDDEN; }
  ;

WS
  :   (' ' | '\t' | '\f' | '\r' | '\n')+
        { $channel=HIDDEN; }
  ;

IDENTIFIER
  :   LETTER+
  ;
  
NUMBER
  :   DIGIT+
  ;
  
fragment DIGIT  :   ('0'..'9') ;
fragment LOWER  :   ('a'..'z') ;
fragment UPPER  :   ('A'..'Z') ;
fragment LETTER :   LOWER | UPPER ;
