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
  :   ^(CONST id=IDENTIFIER expression)
      {
        //TODO De waarde opslaan in het variable object
        vars.put($id.text, new Variable("TODO",true));
      }
  |   ^(VAR id=IDENTIFIER)
      {
        vars.put($id.text, new Variable(size + "[SB]"));
        printTAM("PUSH", "1", "Push variable " + $id.text);
        size++; 
      }
  |   ^(PROC id=IDENTIFIER paramdecl+ expression)
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
  :   ^(NEG expression)
      {
        //TODO
      }
  |   ^(UPLUS expression)  
      { 
        //TODO 
      }
  |   ^(UMINUS expression) 
      { 
        printTAM("LOADL", "-1", "Load numeric literal");
        printTAM("CALL", "mult",  "Multiply by -1");
      }
  |   ^(PLUS expression expression)  
      { 
        printTAM("CALL", "add", "Addition"); 
      }  
  |   ^(MINUS expression expression) 
      { 
        printTAM("CALL", "sub", "Subtraction");
      }
  |   ^(BECOMES id=IDENTIFIER expression)  
      { 
        printTAM("STORE(1)", vars.get($id.text).getValue(), "Store in variable " + $id.text);
        printTAM("LOAD(1)", vars.get($id.text).getValue(), "Load variable " + $id.text);
      }
  |   ^(VARASSIGN expression) 
      {
        //TODO ?? (niet in Grammar)
      }
  |   ^(OR expression expression)
      {
        //TODO
      }
  |   ^(AND expression expression)
      {
        //TODO
      }
  |   ^(LT expression expression)
      {
        printTAM("CALL", "lt", "Lesser than");
      }
  |   ^(LE expression expression)
      {
        printTAM("CALL", "le", "Lesser or equal to");
      }
  |   ^(GT expression expression)
      {
        printTAM("CALL", "gt", "Greater than");
      }
  |   ^(GE expression expression)
      {
        printTAM("CALL", "ge", "Greater or equal to");
      }
  |   ^(EQ expression expression)
      {
        printTAM("CALL", "eq", "Equal to");
      }
  |   ^(NEQ expression expression)
      {
        printTAM("CALL", "ne", "Not equal to");
      }
  |   ^(TIMES expression expression)
      {
        printTAM("CALL", "mult", "Multiplication");
      }
  |   ^(DIVIDE expression expression)
      {
        printTAM("CALL", "div", "Division");
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
  |   ^(PRINT exprlist)
      {
        //TODO
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
  |   operand
  ;
  
exprlist
  :   expression+
  ;
  
varlist
  :   id=IDENTIFIER+
  ;
  
operand
  :   ^(id=IDENTIFIER expression* paramuse*)  
      { 
        if(vars.get($id.text).isConstant()) {
          printTAM("LOADL", vars.get($id.text).getValue(), "Load literal value of constant");
        } else {
          printTAM("LOAD(1)", vars.get($id.text).getValue(), "Load variable " + $id.text);
        } 
      } 
  |   TRUE
      {
        if(!constantScope) printTAM("LOADL", "1", "Load true value (1)");
      }
  |   FALSE
      {
        if(!constantScope) printTAM("LOADL", "0", "Load false value (0)");
      }
  |   n=NUMBER
      {
        if(!constantScope) printTAM("LOADL", String.valueOf(n), "Load numeric literal " + $n);
      }
  ;