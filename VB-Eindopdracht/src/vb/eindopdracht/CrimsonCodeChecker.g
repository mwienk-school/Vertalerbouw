tree grammar CrimsonCodeChecker;

options {
    tokenVocab=CrimsonCodeGrammar;
    ASTLabelType=CommonTree;
}

@header {
  package vb.eindopdracht;
  import vb.eindopdracht.helpers.CheckerHelper;
}

@rulecatch { 
    catch (Exception e) { 
        System.err.println("ERROR:");
        e.printStackTrace(); 
    } 
}

@members {
  private CheckerHelper ch = new CheckerHelper();
}

program
  :   ^(PROGRAM compExpr+)
  ;

compExpr returns [String type = null;]
  :   ^(CONST id=IDENTIFIER expression) { ch.processEntry($id.text); $type = "no_type"; }
  |   ^(VAR id=IDENTIFIER)              { ch.processEntry($id.text); $type = "no_type"; }
  |   ^(PROC id=IDENTIFIER {ch.symbolTable.openScope();} paramdecl+ expression {ch.symbolTable.closeScope();})
                                        { ch.processEntry($id.text); $type = "no_type"; }
  |   ^(FUNC id=IDENTIFIER {ch.symbolTable.openScope();} paramdecl+ expression {ch.symbolTable.closeScope();})
                                        { ch.processEntry($id.text); $type = "no_type"; }
  |   ^(TYPE id=IDENTIFIER n1=NUMBER n2=NUMBER)     { ch.processDynamicType($id.text, $n1.text, $n2.text); $type = "no_type"; }
  |   expression
  ;

paramdecl
  :   ^(PARAM id=IDENTIFIER)            { ch.processEntry($id.text); }
  |   ^(VAR id=IDENTIFIER)              { ch.processEntry($id.text); }
  ;

paramuse
  :   ^(PARAM id=IDENTIFIER)
        {
	        if(ch.symbolTable.retrieve($id.text) == null) throw new Exception($id.text + " is not declared.");
	      }
  |   ^(VAR id=IDENTIFIER)
        {
	        if(ch.symbolTable.retrieve($id.text) == null) throw new Exception($id.text + " is not declared.");
	      }
  ;
  
expression returns [String type = null;]
  :   ^(NEG ex=expression)                    { $type = ch.checkType("Pill", $ex.type); }
  |   ^(UPLUS ex=expression)                  { $type = ch.checkType("Int", $ex.type); }
  |   ^(UMINUS ex=expression)                 { $type = ch.checkType("Int", $ex.type); }
  |   ^(PLUS e1=expression e2=expression)     { $type = ch.checkType("Int", $e1.type); $type = ch.checkType($type, $e2.type); }
  |   ^(MINUS e1=expression e2=expression)    { $type = ch.checkType("Int", $e1.type); $type = ch.checkType($type, $e2.type); }
  |   ^(BECOMES id=IDENTIFIER ex=expression)  { $type = ch.processAssignment($id.text, $ex.type); }
  |   ^(OR e1=expression e2=expression)       { $type = ch.checkType("Pill", $e1.type); $type = ch.checkType($type, $e2.type); }
  |   ^(AND e1=expression e2=expression)      { $type = ch.checkType("Pill", $e1.type); $type = ch.checkType($type, $e2.type); }
  |   ^(LT e1=expression e2=expression)       { ch.checkType("Int", $e1.type); ch.checkType("Int", $e2.type); $type = "Pill"; }
  |   ^(LE e1=expression e2=expression)       { ch.checkType("Int", $e1.type); ch.checkType("Int", $e2.type); $type = "Pill"; }
  |   ^(GT e1=expression e2=expression)       { ch.checkType("Int", $e1.type); ch.checkType("Int", $e2.type); $type = "Pill"; }
  |   ^(GE e1=expression e2=expression)       { ch.checkType("Int", $e1.type); ch.checkType("Int", $e2.type); $type = "Pill"; }
  |   ^(EQ e1=expression e2=expression)       { ch.checkType($e1.type, $e2.type); $type = "Pill"; }
  |   ^(NEQ e1=expression e2=expression)      { ch.checkType($e1.type, $e2.type); $type = "Pill"; }
  |   ^(TIMES e1=expression e2=expression)    { $type = ch.checkType("Int", $e1.type); $type = ch.checkType($type, $e2.type); }
  |   ^(DIVIDE e1=expression e2=expression)   { $type = ch.checkType("Int", $e1.type); $type = ch.checkType($type, $e2.type); }
  |   ^(MOD e1=expression e2=expression)      { $type = ch.checkType("Int", $e1.type); $type = ch.checkType($type, $e2.type); }
  |   ^(IF e1=expression e2=expression (e3=expression)?) {
                                                        ch.checkType("Pill", $e1.type);
                                                        try {
                                                          $type = ch.checkType($e2.type, $e3.type);
                                                        }
                                                        catch(Exception e) {
                                                          $type = "void";
                                                        }
                                                      }
  |   ^(WHILE { ch.symbolTable.openScope(); } e1=expression e2=expression { ch.checkType("Pill", $e1.type); $type = "void"; ch.symbolTable.closeScope(); })
  |   ^(READ id=IDENTIFIER { $type = ch.getType($id.text); } (id=IDENTIFIER { ch.checkDeclared($id.text); $type = "void"; })*)
  |   ^(PRINT ex=expression { $type = $ex.type; } (expression { $type = "void"; })*) 
  |   ^(PRINTLN expression+) {$type = "void"; }
  |   ^(CCOMPEXPR { ch.symbolTable.openScope(); } (ce=compExpr { $type = $ce.type; })+ { ch.symbolTable.closeScope(); })
  |   ^(ARRAY ex=expression 
               { 
                 int n = 1; $type = $ex.type; 
               } 
             (ex=expression { 
                 ch.checkType($type, $ex.type); 
                 n++; 
               })*
       ) 
       { 
        $type = $type + "Array[" + n + "]"; 
       }
  |   op=operand                              { $type = $op.type; }
  ;
  
operand returns [String type = null;]
  :   ^(id=IDENTIFIER   { $type = ch.getType($id.text); } expression* paramuse*)
  |   TRUE              { $type = "Pill"; }
  |   FALSE             { $type = "Pill"; }
  |   NUMBER            { $type = "Int"; }
  |   CHARACTER         { $type = "Char"; }
  ;
