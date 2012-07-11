tree grammar CrimsonCodeGenerator;

options {
    tokenVocab=CrimsonCodeGrammar;
    ASTLabelType=CommonTree;
}

@rulecatch { 
    catch (Exception e) { 
        System.err.println("ERROR:");
        e.printStackTrace(); 
    } 
}

@header {
  package vb.eindopdracht;
  import java.util.HashMap;
  import vb.eindopdracht.symboltable.*;
  import vb.eindopdracht.helpers.*;
}

@members {
  private GeneratorHelper gh = new GeneratorHelper();
}

//Parser regels

program
  : ^(PROGRAM compExpr+) { gh.endProgram(); }
  ;
   
compExpr returns [String val = null;]
  :   ^(CONST { gh.setConstantScope(true); } id=IDENTIFIER ex=expression) { gh.defineConstant($id.text, $ex.val); gh.setConstantScope(false); }
  |   ^(VAR id=IDENTIFIER) { gh.defineVariable($id.text); }
  |   ^(PROC id=IDENTIFIER { int number = gh.defineProcedure_Start($id.text); } 
              par=paramdecls 
              {
                int i;
                for(i = 0; i < $par.paramList.size(); i++) {
                  gh.defineParameter((String)$par.paramList.get(i), i-$par.paramList.size());
                }
              }
             expression) { gh.defineProcedure_End(number, i); }
  |   ^(FUNC id=IDENTIFIER { int number = gh.defineFunction_Start($id.text); }
              par=paramdecls
              {
                int i;
                for(i = 0; i < $par.paramList.size(); i++) {
                  gh.defineParameter((String)$par.paramList.get(i), i-$par.paramList.size());
                }
              }
              expression) { gh.defineFunction_End(number, i); }
  |   expr=expression { $val = $expr.val; }
  ;
  
paramdecls returns [List paramList = new ArrayList();]
  :   ^(PARAM id=IDENTIFIER)  { $paramList.add($id.text); } (par=paramdecls { $paramList.addAll($par.paramList); })?
  |   ^(VAR id=IDENTIFIER)    { $paramList.add($id.text+"Var"); } (par=paramdecls { $paramList.addAll($par.paramList); })?
  ;

paramuse
  :   ^(PARAM id=IDENTIFIER)  { gh.getValue($id.text); }
  |   ^(VAR id=IDENTIFIER)    { gh.getAddress($id.text); }
  ;
    
expression returns [String val = null;] 
  :   ^(NEG ex=expression)
      {
        gh.printPrimitiveRoutine("not", "Negate");
        if($ex.val.equals("0")) {
          $val = "1";
        } else {
          $val = "0";
        }
      }
  |   ^(UPLUS ex=expression)   { $val = $ex.val; }
  |   ^(UMINUS ex=expression)  
      { 
        gh.loadLiteral("-1");
        gh.printPrimitiveRoutine("mult", "Multiply the top of the stack");
        $val = $ex.val;
      }
  |   ^(PLUS ex=expression ey=expression)  
      { 
        gh.printPrimitiveRoutine("add", "Add the top of the stack");
        $val = String.valueOf(Integer.parseInt($ex.val) + Integer.parseInt($ey.val)); 
      }  
  |   ^(MINUS ex=expression ey=expression) 
      { 
        gh.printPrimitiveRoutine("sub", "Subtract the top of the stack");
        $val = String.valueOf(Integer.parseInt($ex.val) - Integer.parseInt($ey.val));
      }
  |   ^(BECOMES id=IDENTIFIER ex=expression)  
      {
        gh.storeValue($id.text, $ex.val);
        $val = $ex.val;
      }
  |   ^(OR ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("or", "OR statement");
        $val = (!$ex.val.equals("0") && !$ex.val.equals("") || !$ey.val.equals("0") && !$ey.val.equals("")) ? "1" : "0";
      }
  |   ^(AND ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("and", "AND statement");
        $val = (!$ex.val.equals("0") && !$ex.val.equals("") && !$ey.val.equals("0") && !$ey.val.equals("")) ? "1" : "0";
      }
  |   ^(LT ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("lt", "Lesser than");
        $val = Integer.parseInt($ex.val) < Integer.parseInt($ey.val) ? "1" : "0";
      }
  |   ^(LE ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("le", "Lesser or equal to");
        $val = Integer.parseInt($ex.val) <= Integer.parseInt($ey.val) ? "1" : "0";
      }
  |   ^(GT ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("gt", "Greater than");
        $val = Integer.parseInt($ex.val) > Integer.parseInt($ey.val) ? "1" : "0";
      }
  |   ^(GE ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("ge", "Greater or equal to");
        $val = Integer.parseInt($ex.val) >= Integer.parseInt($ey.val) ? "1" : "0";
      }
  |   ^(EQ ex=expression ey=expression)
      {
        gh.loadLiteral("1");
        gh.printPrimitiveRoutine("eq", "Equal to");
        $val = Integer.parseInt($ex.val) == Integer.parseInt($ey.val) ? "1" : "0";
      }
  |   ^(NEQ ex=expression ey=expression)
      {
        gh.loadLiteral("1");
        gh.printPrimitiveRoutine("ne", "Not equal to");
        $val = Integer.parseInt($ex.val) != Integer.parseInt($ey.val) ? "1" : "0";
      }
  |   ^(TIMES ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("mult", "Multiplication");
        $val = String.valueOf(Integer.parseInt($ex.val) * Integer.parseInt($ey.val));
      }
  |   ^(DIVIDE ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("div", "Division");
        $val = String.valueOf(Integer.parseInt($ex.val) / Integer.parseInt($ey.val));
      }
  |   ^(IF ex=expression  { int ifVal = gh.printStatementIf_Start(); boolean condition = $ex.val.equals("Red"); } 
           ex=expression  { gh.printStatementIf_Else(ifVal); if(condition) $val = $ex.val; } 
           ex=expression?) { gh.printStatementIf_End(ifVal); if(!condition) $val = $ex.val; }
  |   ^(WHILE { WhileInfo info = gh.printStatementWhile_Start(); }
            expression  { gh.printStatementWhile_Do(info); }
            expression) { gh.printStatementWhile_End(info); }
  |   ^(READ r=readvar { $val = $r.val; } (readvar { $val = null; })*)
  |   ^(PRINT p=printexpr { $val = $p.val; } (printexpr { $val = null; })*)
  |   ^(PRINTLN p=printexpr { $val = $p.val; } (printexpr { $val = null; })*) { gh.printStatementPrint("\n"); }
  |   ^(CCOMPEXPR { gh.symbolTable.openScope(); } (cex=compExpr { $val = $cex.val; })+)
      { 
        gh.symbolTable.closeScope();
      }
  |   ^(ARRAY expression+)
  |   ^(TYPE id=IDENTIFIER n1=NUMBER n2=NUMBER)
      {
        gh.defineArray_Type($id.text, $n1.text, $n2.text);
      }
  |   op=operand 
      {
        $val = $op.val;
      }
  ;
  
readvar returns [String val = null;]
  :   id=IDENTIFIER { gh.printStatementRead($id.text); $val = "1"; /*dummy value*/ }
  ;
  
printexpr returns [String val = null;]
  :   ex=expression { gh.printStatementPrint($ex.val); $val = $ex.val; }
  ;
  
operand returns [String val = null;]
  :   ^(id=IDENTIFIER { gh.initOperand($id.text); }ex=expression* paramuse*)  
      {
        $val = gh.getValue($id.text);
      } 
  |   TRUE
      {
        $val = "1";
        if(!gh.isConstantScope()) gh.loadLiteral(val);
      }
  |   FALSE
      {
        $val = "0";
        if(!gh.isConstantScope()) gh.loadLiteral(val);
      }
  |   n=NUMBER
      {
        $val = String.valueOf(n);
        if(!gh.isConstantScope()) gh.loadLiteral(val);
      }
  |   ch=CHARACTER
      {
        $val = $ch.text;
        if(!gh.isConstantScope()) gh.loadLiteral(val);
      }
  ;
