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
  :   ^(NEG ex=expression)                    { retval.val = ch.checkType("Pill", $ex.text); }
  |   ^(UPLUS ex=expression)                  { retval.val = ch.checkType("Int", $ex.text); }
  |   ^(UMINUS ex=expression)                 { retval.val = ch.checkType("Int", $ex.text); }
  |   ^(PLUS e1=expression e2=expression)     { retval.val = ch.checkType("Int", $e1.text); retval.val = ch.checkType(retval.val, $e2.text); }
  |   ^(MINUS e1=expression e2=expression)    { retval.val = ch.checkType("Int", $e1.text); retval.val = ch.checkType(retval.val, $e2.text); }
  |   ^(BECOMES id=IDENTIFIER expression)     { retval.val = ch.checkDeclaredType($ex.text, $id.text);}
  |   ^(VARASSIGN expression)
  |   ^(OR e1=expression e2=expression)       { retval.val = ch.checkType("Pill", $e1.text); retval.val = ch.checkType(retval.val, $e2.text); }
  |   ^(AND e1=expression e2=expression)      { retval.val = ch.checkType("Pill", $e1.text); retval.val = ch.checkType(retval.val, $e2.text); }
  |   ^(LT e1=expression e2=expression)       { retval.val = ch.checkType("Int", $e1.text); retval.val = ch.checkType(retval.val, $e2.text); }
  |   ^(LE e1=expression e2=expression)       { retval.val = ch.checkType("Int", $e1.text); retval.val = ch.checkType(retval.val, $e2.text); }
  |   ^(GT e1=expression e2=expression)       { retval.val = ch.checkType("Int", $e1.text); retval.val = ch.checkType(retval.val, $e2.text); }
  |   ^(GE e1=expression e2=expression)       { retval.val = ch.checkType("Int", $e1.text); retval.val = ch.checkType(retval.val, $e2.text); }
  |   ^(EQ e1=expression e2=expression)       { retval.val = ch.checkType($e1.text, $e2.text); }
  |   ^(NEQ e1=expression e2=expression)      { retval.val = ch.checkType($e1.text, $e2.text); }
  |   ^(TIMES e1=expression e2=expression)    { retval.val = ch.checkType("Int", $e1.text); retval.val = ch.checkType(retval.val, $e2.text); }
  |   ^(DIVIDE e1=expression e2=expression)   { retval.val = ch.checkType("Int", $e1.text); retval.val = ch.checkType(retval.val, $e2.text); }
  |   ^(MOD e1=expression e2=expression)      { retval.val = ch.checkType("Int", $e1.text); retval.val = ch.checkType(retval.val, $e2.text); }
  |   ^(IF e1=expression e2=expression e3=expression) {
                                                        ch.checkType("Pill", $e1.text);
                                                        try {
                                                          retval.val = ch.checkType($e2.text, $e3.text);
                                                        }
                                                        catch(Exception e) {
                                                          retval.val = "void";
                                                        }
                                                      }
  |   ^(WHILE expression expression)          { ch.checkType("Pill", $e1.text); retval.val = "void"; }
  |   ^(READ varlist)
  |   ^(PRINT exprlist)
  |   ^(CCOMPEXPR { ch.symbolTable.openScope(); } compExpr+ { ch.symbolTable.closeScope(); })
  |   ^(ARRAY expression+)
  |   ^(TYPE id=IDENTIFIER NUMBER NUMBER)                { ch.processDynamicType($id.text); }
  |   op=operand                                 { retval.val = $op.text; }
  ;
  
exprlist
  :   expression+
  ;
  
varlist
  :   id=IDENTIFIER+    { ch.checkDeclared($id.text); }
  ;
  
operand returns [String val = null;]
  :   ^(id=IDENTIFIER   { retval.val = ch.getType($id.text); } expression* paramuse*)
  |   TRUE
  |   FALSE
  |   NUMBER
  ;
