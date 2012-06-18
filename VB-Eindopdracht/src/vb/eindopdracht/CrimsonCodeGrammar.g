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
  VAR       = 'spawn';
  CONST     = 'const';
  
  //Types
  INTEGER   = 'i';
  BOOLEAN   = 'pill';
  CHAR      = 'c';
  STRING    = 's';
  
  TRUE      = 'red';
  FALSE     = 'blue';
  
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
  ;
  
constDecl
  :   CONST^ IDENTIFIER BECOMES! expression
  ;
  
varDecl
  :   VAR^ IDENTIFIER
  ;
  
//Expression
expression
  :   assignExpr
  |   readExpr
  |   printExpr
  |   ccompExpr
  |   ifExpr
  |   whileExpr
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

operand
  :   IDENTIFIER
  |   TRUE
  |   FALSE
  |   NUMBER
  |   character
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
