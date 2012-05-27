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
  private HashMap<String, String> vars = new HashMap<String, String>();
  private void printTAM(String lbl, String cmd, String arg) {
    if(!lbl.equals("") && lbl != null) lbl = lbl + ":";
    if(cmd.equals("HALT")) System.out.format("\t\%-8s \%-8s \%8s \n", lbl, cmd, arg);
    else System.out.format("\t\%-8s \%-8s \%8s ;\n", lbl, cmd, arg);
  }
  private void printTAM(String cmd, String arg) {
    printTAM("", cmd, arg);
  }
}

program
    :   ^(PROGRAM (declaration | statement)+) { printTAM("POP(0)", String.valueOf(size));
                                                printTAM("HALT", ""); }
    ;
    
declaration
    :   ^(VAR id=IDENTIFIER type)
            { vars.put($id.text, size + "[SB]");
              printTAM("PUSH", "1");
              printTAM("LOAD(1)", vars.get($id.text));
              size++; } 
    ;
    
statement
@init { int ix = input.index(); }
    :   ^(BECOMES id=IDENTIFIER v=expr)
            { printTAM("STORE(1)", vars.get($id.text)); }
    |   ^(PRINT v=expr)
            { printTAM("CALL", "putint"); }            
    |   ^(SWAP id1=IDENTIFIER id2=IDENTIFIER)
            { }
    |   ^(DO ex=expr statement+)
            { }
    ;
    
expr
    :    z=operand               {  }
    |    ^(PLUS x=expr y=expr)   { printTAM("CALL", "add");  }
    |    ^(MINUS x=expr y=expr)  { printTAM("CALL", "sub");  }
    |    ^(TIMES x=expr y=expr)  { printTAM("CALL", "mult");  }
    ;

operand returns [int val = 0]
    :   id=IDENTIFIER                       { printTAM("LOAD(1)", vars.get($id.text));      } 
    |   n=NUMBER                            { printTAM("LOADL", String.valueOf(n)); }
    ;

type
    :    INTEGER
    ;