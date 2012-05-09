// [file: CalcInterpreter.g, started: 22-Apr-2008]
//
// Calc - Simple calculator with memory variables.
// CalcInterpreter.g: interpreter
//
// @author   Theo Ruys
// @version  2008.04.22

tree grammar CalcInterpreter;

options {
    tokenVocab=Calc;                    // import tokens from Calc.tokens
    ASTLabelType=CommonTree;            // AST nodes are of type CommonTree
}

@header {
package vb.week3.calc;
import java.util.Map;
import java.util.HashMap;
}

@members { 
    private Map<String,Integer> store = new HashMap<String,Integer>();   
}

program
    :   ^(PROGRAM (declaration | statement)+)
    ;
    
declaration
    :   ^(VAR id=IDENTIFIER type)
            { store.put($id.text, 0); } 
    ;

statement 
    :   ^(BECOMES id=IDENTIFIER v=expr)
            { store.put($id.text, v);       }
    |   ^(PRINT v=expr)
            { System.out.println("" + v);   }
    ;
    
expr returns [int val = 0;] 
    :   z=operand               { val = z;      }
    |   ^(PLUS x=expr y=expr)   { val = x + y;  }
    |   ^(MINUS x=expr y=expr)  { val = x - y;  }
    |   ^(TIMES x=expr y=expr)  { val = x * y;  }
    |   ^(DIVIDE x=expr y=expr) { val = x / y;  }
    ;
    
operand returns [int val = 0]
    :   id=IDENTIFIER   { val = store.get($id.text);       } 
    |   n=NUMBER        { val = Integer.parseInt($n.text); }
    ;
    
type
    :   INTEGER
    ;
