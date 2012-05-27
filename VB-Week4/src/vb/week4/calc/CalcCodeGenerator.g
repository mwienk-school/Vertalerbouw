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
  private String nextLabel = "";
  private HashMap<String, String> vars = new HashMap<String, String>();
  private void printTAM(String lbl, String cmd, String arg) {
    if(!lbl.equals("") && lbl != null) lbl = lbl + ":";
    if(cmd.equals("HALT")) System.out.format("\t\%-9s \%-9s \%9s \n", lbl, cmd, arg);
    else System.out.format("\t\%-9s \%-9s \%9s ;\n", lbl, cmd, arg);
  }
  private void printTAM(String cmd, String arg) {
    printTAM(nextLabel, cmd, arg);
    nextLabel = "";
  }
}

program
    :   ^(PROGRAM (declaration | statement)+) { 
            printTAM("POP(0)", String.valueOf(size));
            printTAM("HALT", ""); 
        }
    ;
    
declaration
    :   ^(VAR id=IDENTIFIER type) {
            vars.put($id.text, size + "[SB]");
            printTAM("PUSH", "1");
            printTAM("LOAD(1)", vars.get($id.text));
            size++; 
        } 
    ;
    
statement
@init { int ix = input.index(); }
    :   ^(BECOMES id=IDENTIFIER v=expr)
            { printTAM("STORE(1)", vars.get($id.text)); }
    |   ^(PRINT v=expr)
            { printTAM("CALL", "putint"); }            
    |   ^(SWAP id1=IDENTIFIER id2=IDENTIFIER)
            { printTAM("PUSH", "1");
              printTAM("LOAD(1)", vars.get($id1.text));
              printTAM("STORE(1)", size + "[SB]");
              printTAM("LOAD(1)", vars.get($id2.text));
              printTAM("STORE(1)", vars.get($id1.text));
              printTAM("LOAD(1)", size + "[SB]");
              printTAM("STORE(1)", vars.get($id2.text));
              printTAM("POP(1)", "1"); 
            }
    |   ^(DO ex=expr statement+)
            { }
    ;
    
expr
    :    z=operand
    |    ^(PLUS x=expr y=expr)    { printTAM("CALL", "add"); }
    |    ^(MINUS x=expr y=expr)   { printTAM("CALL", "sub"); }
    |    ^(TIMES x=expr y=expr)   { printTAM("CALL", "mult");}
    |    ^(DIVIDE x=expr y=expr)  { printTAM("CALL", "div"); }
    |    ^(LESS e1=expr e2=expr)  { printTAM("CALL", "lt"); }
    |    ^(LESSEQ e1=expr e2=expr){ printTAM("CALL", "le"); }
    |    ^(MORE e1=expr e2=expr)  { printTAM("CALL", "gt"); }
    |    ^(MOREEQ e1=expr e2=expr){ printTAM("CALL", "ge"); }
    |    ^(EQ e1=expr e2=expr)    { printTAM("CALL", "eq"); }
    |    ^(NEQ e1=expr e2=expr)   { printTAM("CALL", "ne"); }
    |    ^(BECOMES id=IDENTIFIER e1=expr) { printTAM("STORE(1)", vars.get($id.text)); }
    |    ^(IF c=expr  { printTAM("JUMPIF(0)", "Lelse[CB]"); } 
              e1=expr { printTAM("JUMP", "Lend[CB]"); nextLabel ="Lelse"; }
              e2=expr ) { nextLabel = "Lend"; }
    ;

operand returns [int val = 0]
    :   id=IDENTIFIER                       { printTAM("LOAD(1)", vars.get($id.text));      } 
    |   n=NUMBER                            { printTAM("LOADL", String.valueOf(n)); }
    ;

type
    :    INTEGER
    ;