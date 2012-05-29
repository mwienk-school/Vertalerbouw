tree grammar CalcCodeGenerator;

options {
  tokenVocab = Calc;
  ASTLabelType = CommonTree;
}

@header {
package vb.week4.calc;
import java.util.HashMap;
}

@members {
  private int size = 0;
  private int indent = 0;
  private String nextLabel = "";
  private int labelNumber = 0;
  private HashMap<String, String> vars = new HashMap<String, String>();
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

program
    :   ^(PROGRAM (declaration | statement)+) { 
            printTAM("POP(0)", String.valueOf(size), "Pop " + size + " variables");
            printTAM("HALT", "", "End of program"); 
        }
    ;
    
declaration
    :   ^(VAR id=IDENTIFIER type) {
            vars.put($id.text, size + "[SB]");
            printTAM("PUSH", "1", "Push variable " + $id.text);
            System.out.println("");
            size++; 
        } 
    ;
    
statement
@init { int ix = input.index(); }
    :   ^(BECOMES id=IDENTIFIER v=expr)
            { printTAM("STORE(1)", vars.get($id.text), "Store in variable " + $id.text);
              System.out.println(""); }
    |   ^(PRINT v=expr)
            { printTAM("CALL", "putint", "Print integer"); 
              printTAM("CALL", "puteol", "Print EOL");
              System.out.println(""); }
    |   ^(SWAP id1=IDENTIFIER id2=IDENTIFIER)
            { printTAM("PUSH", "1", "Push temporary variable");
              printTAM("LOAD(1)", vars.get($id1.text), "Load variable " + $id1.text);
              printTAM("STORE(1)", size + "[SB]", "Store in temporary variable");
              printTAM("LOAD(1)", vars.get($id2.text), "Load variable " + $id2.text);
              printTAM("STORE(1)", vars.get($id1.text), "Store in variable " + $id1.text);
              printTAM("LOAD(1)", size + "[SB]", "Load temporary variable");
              printTAM("STORE(1)", vars.get($id2.text), "Store in variable " + $id2.text);
              printTAM("POP(0)", "1", "Pop temporary variable");
              System.out.println("");
            }
    |   ^(DO
            {
              int thisLabelNo = labelNumber++;
              String doLabel = "Do" + thisLabelNo;
              printTAM("JUMP", doLabel + "[CB]", "Jump to DO-body"); 
              if(nextLabel.equals(""))
                  nextLabel = "While" + thisLabelNo;
              String startLabel = nextLabel;
            } 
          ex=expr
            {
              printTAM("JUMPIF(0)", "End" + thisLabelNo + "[CB]", "Jump past DO-body");
              indent++;
              nextLabel = doLabel;
            }
          statement+
            {
              printTAM("JUMP", startLabel + "[CB]", "Jump to WHILE-expression");
              nextLabel = "End" + thisLabelNo;
              indent--;
              System.out.println("");
            }
          ) 
    ;
    
expr
    :    z=operand
    |    ^(PLUS x=expr y=expr)    { printTAM("CALL", "add", "Addition"); System.out.println(""); }
    |    ^(MINUS x=expr y=expr)   { printTAM("CALL", "sub", "Subtraction"); System.out.println(""); }
    |    ^(TIMES x=expr y=expr)   { printTAM("CALL", "mult", "Multiplication"); System.out.println(""); }
    |    ^(DIVIDE x=expr y=expr)  { printTAM("CALL", "div", "Division"); System.out.println(""); }
    |    ^(LESS e1=expr e2=expr)  { printTAM("CALL", "lt", "Lesser than"); System.out.println(""); }
    |    ^(LESSEQ e1=expr e2=expr){ printTAM("CALL", "le", "Lesser or equal to"); System.out.println(""); }
    |    ^(MORE e1=expr e2=expr)  { printTAM("CALL", "gt", "Greater than"); System.out.println(""); }
    |    ^(MOREEQ e1=expr e2=expr){ printTAM("CALL", "ge", "Greater or equal to"); System.out.println(""); }
    |    ^(EQ e1=expr e2=expr)    { printTAM("LOADL", "1", "Integers are 1 word");
                                    printTAM("CALL", "eq", "Equal to"); System.out.println(""); }
    |    ^(NEQ e1=expr e2=expr)   { printTAM("LOADL", "1", "Integers are 1 word");
                                    printTAM("CALL", "ne", "Not equal to"); System.out.println(""); }
    |    ^(BECOMES id=IDENTIFIER e1=expr) { printTAM("STORE(1)", vars.get($id.text), "Store in variable " + $id.text);
                                            printTAM("LOAD(1)", vars.get($id.text), "Load variable " + $id.text);
                                            System.out.println(""); }
    |    ^(IF c=expr  {
                        int thisLabelNo = labelNumber++;
                        printTAM("JUMPIF(0)", "Else" + thisLabelNo + "[CB]", "Jump to ELSE");
                        indent++;
                      } 
              e1=expr {
                        printTAM("JUMP", "End" + thisLabelNo + "[CB]", "Jump over ELSE");
                        nextLabel ="Else" + thisLabelNo;
                      }
              e2=expr ) {
                        indent--;
                        nextLabel = "End" + thisLabelNo;
                        System.out.println("");
                      }
    ;

operand returns [int val = 0]
    :   id=IDENTIFIER                       { printTAM("LOAD(1)", vars.get($id.text), "Load variable " + $id.text); System.out.println(""); } 
    |   n=NUMBER                            { printTAM("LOADL", String.valueOf(n), "Load int literal " + $n); System.out.println(""); }
    ;

type
    :    INTEGER
    ;
