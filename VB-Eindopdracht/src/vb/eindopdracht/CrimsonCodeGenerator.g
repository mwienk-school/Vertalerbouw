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
  int label;  //helpvariable to pass label to different rules
  boolean condition;  //helpvariable to pass condition to different rules 
}

//Parser regels

program
  :   ^(PROGRAM (cex=compExpr
              {
                if($cex.val != null)
                  gh.printStatementCleanup("non-returning expression");
              })+
              ) { gh.endProgram(); }
  ;
   
compExpr returns [String val = null;]
  :   ^(CONST { gh.setConstantScope(true); } id=IDENTIFIER ex=expression) { gh.defineConstant($id.text, $ex.val); gh.setConstantScope(false); }
  |   ^(VAR id=IDENTIFIER) { gh.defineVariable($id.text); }
  |   ^(PROC id=IDENTIFIER { int number = gh.defineProcedure_Start($id.text); int i = 0; }
              (par=paramdecls 
              {
                for(i = 0; i < $par.paramList.size(); i++) {
                  gh.defineParameters((String)$par.paramList.get(i), i-$par.paramList.size());
                }
              })?
             expression) { gh.defineProcedure_End(number, i); }
  |   ^(FUNC id=IDENTIFIER { int number = gh.defineFunction_Start($id.text); int i = 0; }
              (par=paramdecls
              {
                for(i = 0; i < $par.paramList.size(); i++) {
                  gh.defineParameters((String)$par.paramList.get(i), i-$par.paramList.size());
                }
              })?
              expression) { gh.defineFunction_End(number, i); }
  |   expr=expression { $val = $expr.val; }
  ;
  
paramdecls returns [List paramList = new ArrayList();]
  :   ^(PARAM id=IDENTIFIER)  { $paramList.add($id.text); }        (par=paramdecls { $paramList.addAll($par.paramList); })?
  |   ^(VAR id=IDENTIFIER)    { $paramList.add($id.text+"Var"); }  (par=paramdecls { $paramList.addAll($par.paramList); })?
  ;

paramuses returns [List paramList = new ArrayList();]
  :   ^(PARAM ex=expression)  { $paramList.add($ex.val); } (par=paramuses { $paramList.addAll($par.paramList); })?
  |   ^(VAR id=IDENTIFIER)    { $paramList.add($id.text+"Var"); gh.getAddress($id.text); } (par=paramuses { $paramList.addAll($par.paramList); })?
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
        $val = $ex.val.equals($ey.val) ? "1" : "0";
      }
  |   ^(NEQ ex=expression ey=expression)
      {
        gh.loadLiteral("1");
        gh.printPrimitiveRoutine("ne", "Not equal to");
        $val = $ex.val.equals($ey.val) ? "0" : "1";
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
  |   ^(MOD ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("mod", "Modulus");
        $val = String.valueOf(Integer.parseInt($ex.val) \% Integer.parseInt($ey.val));
      }
  |   ^(IF                      { gh.openScope(); }
            ex=compExpr
            (
              {
                if($ex.val != null)
                  gh.printStatementCleanup("non-returning expression");
              }
              ex=compExpr
            )*                  { label = gh.printStatementIf_Start();
            condition = $ex.val.equals("1"); }
            ey=thenExpr         {
                                  gh.printStatementIf_End(label);
                                  $val = $ey.val;
                                  if($ey.val == null)
                                    gh.closeScope(0);
                                  else
                                    gh.closeScope(1);
                                })
  |   ^(WHILE { WhileInfo info = gh.printStatementWhile_Start(); gh.openScope(); }
            ex=compExpr
            (
              {
                if($ex.val != null)
                  gh.printStatementCleanup("non-returning expression");
              }
              ex=compExpr
            )*                  { gh.printStatementWhile_Do(info); }
            doExpr) { gh.printStatementWhile_End(info); gh.closeScope(0); }
  |   ^(READ r=readvar { $val = $r.val; }
            (
              readvar { gh.printStatementCleanup("read"); gh.printStatementCleanup("read"); $val = null; }
              (readvar { gh.printStatementCleanup("read"); })*
            )?)
  |   ^(PRINT p=printexpr { $val = $p.val; }
            (
              printexpr { gh.printStatementCleanup("print"); gh.printStatementCleanup("print"); $val = null;}
              (printexpr { gh.printStatementCleanup("print"); })*
            )?)
  |   ^(PRINTLN p=printexpr { $val = $p.val; }
            (
              printexpr { gh.printStatementCleanup("print"); gh.printStatementCleanup("print"); $val = null;}
              (printexpr { gh.printStatementCleanup("print"); })*
            )?) { gh.printStatementPrint("\n"); }
  |   ^(CCOMPEXPR { gh.openScope(); }
              cex=compExpr { $val = $cex.val; }
              (
                {
                  if($val != null)
                    gh.printStatementCleanup("non-returning expression");
                }
                cex=compExpr { $val = $cex.val; }
              )*
            )
			      { 
			        if($val == null)
			          gh.closeScope(0);
		          else
		            gh.closeScope(1);
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

thenExpr returns [String val = null;]
  :   ^(THEN { gh.openScope(); } ex=compExpr
            (
              {
                if($ex.val != null)
                  gh.printStatementCleanup("non-returning expression");
              }
              ex=compExpr
            )*                                  {
				                                          if($ex.val == null)
				                                            gh.closeScope(0);
				                                          else
				                                            gh.closeScope(1);
                                                  gh.printStatementIf_Else(label);
				                                        }
				    (ey=elseExpr)?)                     {
			                                            if(condition)
				                                            $val = $ex.val;
				                                          else
				                                            $val = $ey.val;
				                                        }
  ;
  
elseExpr returns [String val = null;]
  :   ^(ELSE { gh.openScope(); } ex=compExpr
            (
              {
                if($ex.val != null)
                  gh.printStatementCleanup("non-returning expression");
              }
              ex=compExpr
            )*                                {
										                            $val = $ex.val;
                                                if($ex.val == null)
                                                  gh.closeScope(0);
                                                else
                                                  gh.closeScope(1);
										                          })
  ;

doExpr returns [String val = null;]
  :   ^(DO                                  { gh.openScope(); }
            (ex=compExpr                    {
						                                  if($ex.val != null)
						                                    gh.printStatementCleanup("non-returning expression");
						                                })*)
						                                {
						                                  gh.closeScope(0);
						                                  gh.printStatementWhile_Cleanup();
						                                }
  ;

readvar returns [String val = null;]
  :   id=IDENTIFIER { gh.printStatementRead($id.text); $val = "1"; /*TODO: dummy value*/ }
  ;
  
printexpr returns [String val = null;]
  :   ex=expression { gh.printStatementPrint($ex.val); $val = $ex.val; }
  ;
  
operand returns [String val = null;]
  :   ^(id=IDENTIFIER { gh.initOperand($id.text); } (par=paramuses)?)  
      {
        $val = gh.getValue($id.text);
      } 
  |   TRUE
      {
        $val = "1";
        if(!gh.isConstantScope()) gh.loadLiteral($val);
      }
  |   FALSE
      {
        $val = "0";
        if(!gh.isConstantScope()) gh.loadLiteral($val);
      }
  |   n=NUMBER
      {
        $val = String.valueOf(n);
        if(!gh.isConstantScope()) gh.loadLiteral($val);
      }
  |   ch=CHARACTER
      {
        $val = $ch.text;
        if(!gh.isConstantScope()) gh.loadLiteral($val);
      }
  ;
