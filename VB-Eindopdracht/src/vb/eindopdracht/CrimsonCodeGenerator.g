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
}

@members {
  private int size = 0; // Keep track of the Stack size
  private int indent = 0; // Keep track of the level
  private String nextLabel = ""; // Label for the next output
  private int labelNumber = 0; // Identifier for labels (in case of two e.g. 2 if statements)
  private HashMap<String, Variable> vars = new HashMap<String, Variable>(); // Keep track of variables and constants
  private boolean constantScope = false; // If in constant scope, operands should not output
  /**
   * printTAM prints a well formatted string for the code generator
   */
  private void printTAM(String lbl, String cmd, String arg, String cmt) { 
    if(!lbl.equals("") && lbl != null) lbl = lbl + ":";
    System.out.format("\%-9s \%-9s \%9s ; \%s\%n", lbl, cmd, arg, cmt);
  }
  private void printTAM(String cmd, String arg, String cmt) {
    printTAM(nextLabel, cmd, arg, cmt);
    nextLabel = "";
  }
  private void printTAM(String cmd, String arg) {
    printTAM(nextLabel, cmd, arg, "");
    nextLabel = "";
  }
}

//Parser regels

program
  : ^(PROGRAM compExpr+) 
    {
      printTAM("POP(0)", String.valueOf(size), "Pop " + size + " variables");
      printTAM("HALT", "", "End of program"); 
    }
  ;
   
compExpr
  :   ^(CONST { constantScope = true; } id=IDENTIFIER ex=expression)
      {
        //TODO De waarde opslaan in het variable object
        Variable con = new Variable(null,true);
        con.setValue(ex);
        vars.put($id.text, con);
        constantScope = false;
      }
  |   ^(VAR id=IDENTIFIER)
      {
        vars.put($id.text, new Variable(size + "[SB]"));
        printTAM("PUSH", "1", "Push variable " + $id.text);
        size++; 
      }
  |   //TODO implementaties van PROC & FUNC en paramdecl en paramuse
      ^(PROC id=IDENTIFIER paramdecl+ expression)
  |   ^(FUNC id=IDENTIFIER paramdecl+ expression)
  |   expression
  ;
  
paramdecl
  :   ^(PARAM id=IDENTIFIER)
      {
        vars.put($id.text, new Variable(size + "[SB]"));
        printTAM("PUSH", "1", "Push variable " + $id.text);
        size++; 
      }
  |   ^(VAR id=IDENTIFIER)
      {
        vars.put($id.text, new Variable(size + "[SB]"));
        printTAM("PUSH", "1", "Push variable " + $id.text);
        size++; 
      }
  ;

paramuse
  :   ^(PARAM id=IDENTIFIER)
      {
        //TODO ??
      } 
  |   ^(VAR id=IDENTIFIER)
      {
        //TODO ??
      }
  ;
    
expression returns [String val = null;] 
  :   ^(NEG ex=expression)
      {
        printTAM("CALL", "not", "Negation");
        //TODO: Proper negation?
        if(ex.equals("0")) {
          val = "1";
        } else {
          val = "0";
        }
      }
  |   ^(UPLUS ex=expression)  
      { 
        val = ex;
      }
  |   ^(UMINUS ex=expression) 
      { 
        printTAM("LOADL", "-1", "Load numeric literal");
        printTAM("CALL", "mult",  "Multiply by -1");
        val = ex;
      }
  |   ^(PLUS ex=expression ey=expression)  
      { 
        printTAM("CALL", "add", "Addition");
        val = String.valueOf(Integer.parseInt(ex) + Integer.parseInt(ey)); 
      }  
  |   ^(MINUS ex=expression ey=expression) 
      { 
        printTAM("CALL", "sub", "Subtraction");
        val = String.valueOf(Integer.parseInt(ex) - Integer.parseInt(ey));
      }
  |   ^(BECOMES id=IDENTIFIER ex=expression)  
      { 
        printTAM("STORE(1)", vars.get($id.text).getAddress(), "Store in variable " + $id.text);
        vars.get($id.text).setValue(ex);
        val = ex;
      }
  |   ^(VARASSIGN ex=expression) 
      {
        //TODO ?? (niet in Grammar)
      }
  |   ^(OR ex=expression ey=expression)
      {
        //TODO (andere OR mogelijkheden?)
        printTAM("CALL", "or", "OR statement");
        if(!ex.equals("0") && !ex.equals("") || !ey.equals("0") && !ey.equals("")) {
          val = "1";
        } else {
          val = "0";
        }
      }
  |   ^(AND ex=expression ey=expression)
      {
        //TODO (andere AND mogelijkheden?)
        printTAM("CALL", "and", "AND statement");
        if(!ex.equals("0") && !ex.equals("") && !ey.equals("0") && !ey.equals("")) {
          val = "1";
        } else {
          val = "0";
        }
      }
  |   ^(LT ex=expression ey=expression)
      {
        printTAM("CALL", "lt", "Lesser than");
        if(Integer.parseInt(ex) < Integer.parseInt(ey)) {
          val = "1";
        } else {
          val = "0";
        }
      }
  |   ^(LE ex=expression ey=expression)
      {
        printTAM("CALL", "le", "Lesser or equal to");
        if(Integer.parseInt(ex) <= Integer.parseInt(ey)) {
          val = "1";
        } else {
          val = "0";
        }
      }
  |   ^(GT ex=expression ey=expression)
      {
        printTAM("CALL", "gt", "Greater than");
        if(Integer.parseInt(ex) > Integer.parseInt(ey)) {
          val = "1";
        } else {
          val = "0";
        }
      }
  |   ^(GE ex=expression ey=expression)
      {
        printTAM("CALL", "ge", "Greater or equal to");
        if(Integer.parseInt(ex) >= Integer.parseInt(ey)) {
          val = "1";
        } else {
          val = "0";
        }
      }
  |   ^(EQ ex=expression ey=expression)
      {
        printTAM("CALL", "eq", "Equal to");
        if(Integer.parseInt(ex) == Integer.parseInt(ey)) {
          val = "1";
        } else {
          val = "0";
        }
      }
  |   ^(NEQ ex=expression ey=expression)
      {
        printTAM("CALL", "ne", "Not equal to");
        if(Integer.parseInt(ex) != Integer.parseInt(ey)) {
          val = "1";
        } else {
          val = "0";
        }
      }
  |   ^(TIMES ex=expression ey=expression)
      {
        printTAM("CALL", "mult", "Multiplication");
        val = String.valueOf(Integer.parseInt(ex) * Integer.parseInt(ey));
      }
  |   ^(DIVIDE expression expression)
      {
        printTAM("CALL", "div", "Division");
        val = String.valueOf(Integer.parseInt(ex) / Integer.parseInt(ey));
      }
  |   ^(IF expression 
      {
        int thisLabelNo = labelNumber++;
        printTAM("JUMPIF(0)", "Else" + thisLabelNo + "[CB]", "Jump to ELSE");
        indent++;
      } 
      expression
      {
        printTAM("JUMP", "End" + thisLabelNo + "[CB]", "Jump over ELSE");
        nextLabel ="Else" + thisLabelNo;
      } 
      expression) 
      {
        indent--;
        nextLabel = "End" + thisLabelNo;
      }
  |   ^(WHILE expression 
      {
        int thisLabelNo = labelNumber++;
        String whileLabel = "While" + thisLabelNo;
        if(nextLabel.equals(""))
          nextLabel = "While" + thisLabelNo;
        printTAM("JUMPIF(0)", "End" + thisLabelNo + "[CB]", "Jump past body");
        String startLabel = nextLabel;
        indent++;
      }
      expression )
      {
        printTAM("JUMP", startLabel + "[CB]", "Jump to WHILE-expression");
        nextLabel = "End" + thisLabelNo;
        indent--;
      }
  |   ^(READ varlist)
      {
        //TODO
      }
  |   ^(PRINT ex=expression+)
      {
        printTAM("CALL", "put", "Print the first value on the stack");
      }
  |   ^(CCOMPEXPR compExpr+)
      {
        //TODO
      }
  |   ^(ARRAY expression+)
      {
        //TODO
      }
  |   ^(TYPE id=IDENTIFIER NUMBER NUMBER)
      {
        //TODO
      }
  |   ex=operand 
      {
        val = ex;
      }
  ;
  
varlist
  :   id=IDENTIFIER+
  ;
  
operand returns [String val = null;]
  :   ^(id=IDENTIFIER expression* paramuse*)  
      { 
//        if(!vars.get($id.text).isConstant()) {
//          printTAM("LOAD(1)", vars.get($id.text).getAddress(), "Load variable " + $id.text);
//        } TODO moet dit erin?
        val = vars.get($id.text).getValue();
      } 
  |   TRUE
      {
        if(!constantScope) printTAM("LOADL", "1", "Load true value (1)");
        val = "1";
      }
  |   FALSE
      {
        if(!constantScope) printTAM("LOADL", "0", "Load false value (0)");
        val = "0";
      }
  |   n=NUMBER
      {
        if(!constantScope) printTAM("LOADL", String.valueOf(n), "Load numeric literal " + $n);
        val = String.valueOf(n);
      }
  ;