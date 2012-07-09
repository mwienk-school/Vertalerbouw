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

compExpr
  :   ^(CONST id=IDENTIFIER expression) { ch.processEntry($id.text); }
  |   ^(VAR id=IDENTIFIER)              { ch.processEntry($id.text); }
  |   ^(PROC id=IDENTIFIER {ch.symbolTable.openScope();} paramdecl+ expression {ch.symbolTable.closeScope();})
                                        { ch.processEntry($id.text); }
  |   ^(FUNC id=IDENTIFIER {ch.symbolTable.openScope();} paramdecl+ expression {ch.symbolTable.closeScope();})
                                        { ch.processEntry($id.text); }
  |   ^(TYPE id=IDENTIFIER NUMBER NUMBER)     { ch.processDynamicType($id.text); }
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
  
expression returns [String val = null;]
  :   ^(NEG ex=expression)                    { $val = ch.checkType("Pill", $ex.val); }
  |   ^(UPLUS ex=expression)                  { $val = ch.checkType("Int", $ex.val); }
  |   ^(UMINUS ex=expression)                 { $val = ch.checkType("Int", $ex.val); }
  |   ^(PLUS e1=expression e2=expression)     { $val = ch.checkType("Int", $e1.val); $val = ch.checkType($val, $e2.val); }
  |   ^(MINUS e1=expression e2=expression)    { $val = ch.checkType("Int", $e1.val); $val = ch.checkType($val, $e2.val); }
  |   ^(BECOMES id=IDENTIFIER ex=expression)  { $val = ch.checkType(ch.getType($id.text), $ex.val);}
  |   ^(OR e1=expression e2=expression)       { $val = ch.checkType("Pill", $e1.val); $val = ch.checkType($val, $e2.val); }
  |   ^(AND e1=expression e2=expression)      { $val = ch.checkType("Pill", $e1.val); $val = ch.checkType($val, $e2.val); }
  |   ^(LT e1=expression e2=expression)       { $val = ch.checkType("Int", $e1.val); $val = ch.checkType($val, $e2.val); }
  |   ^(LE e1=expression e2=expression)       { $val = ch.checkType("Int", $e1.val); $val = ch.checkType($val, $e2.val); }
  |   ^(GT e1=expression e2=expression)       { $val = ch.checkType("Int", $e1.val); $val = ch.checkType($val, $e2.val); }
  |   ^(GE e1=expression e2=expression)       { $val = ch.checkType("Int", $e1.val); $val = ch.checkType($val, $e2.val); }
  |   ^(EQ e1=expression e2=expression)       { $val = ch.checkType($e1.val, $e2.val); }
  |   ^(NEQ e1=expression e2=expression)      { $val = ch.checkType($e1.val, $e2.val); }
  |   ^(TIMES e1=expression e2=expression)    { $val = ch.checkType("Int", $e1.val); $val = ch.checkType($val, $e2.val); }
  |   ^(DIVIDE e1=expression e2=expression)   { $val = ch.checkType("Int", $e1.val); $val = ch.checkType($val, $e2.val); }
  |   ^(MOD e1=expression e2=expression)      { $val = ch.checkType("Int", $e1.val); $val = ch.checkType($val, $e2.val); }
  |   ^(IF e1=expression e2=expression e3=expression) {
                                                        ch.checkType("Pill", $e1.val);
                                                        try {
                                                          $val = ch.checkType($e2.val, $e3.val);
                                                        }
                                                        catch(Exception e) {
                                                          $val = "void";
                                                        }
                                                      }
  |   ^(WHILE { ch.symbolTable.openScope(); } expression expression { ch.checkType("Pill", $e1.val); $val = "void"; ch.symbolTable.closeScope(); })
  |   ^(READ id=IDENTIFIER { $val = ch.getType($id.text); } id=IDENTIFIER* { ch.checkDeclared($id.text); $val = "void"; })
  |   ^(PRINT expression+) { $val = "void"; }
  |   ^(CCOMPEXPR { ch.symbolTable.openScope(); } compExpr+ { ch.symbolTable.closeScope(); })
  |   ^(ARRAY expression+)                    { $val = "Array"; }
  |   op=operand                              { $val = $op.val; }
  ;
  
operand returns [String val = null;]
  :   ^(id=IDENTIFIER   { $val = ch.getType($id.text); } expression* paramuse*)
  |   TRUE              { $val = "Pill"; }
  |   FALSE             { $val = "Pill"; }
  |   NUMBER            { $val = "Int"; }
  ;
