package vb.eindopdracht.test;

import java.io.FileInputStream;

import org.antlr.runtime.*;
import org.antlr.runtime.tree.*;

import vb.eindopdracht.CrimsonCodeChecker;
import vb.eindopdracht.CrimsonCodeGrammarLexer;
import vb.eindopdracht.CrimsonCodeGrammarParser;

public class ASTtest {
	
	public static void main(String[] args) {
		
		CommonTokenStream tokens = new CommonTokenStream();
		RuleReturnScope result = new RuleReturnScope();
		
		try {
			tokens.setTokenSource(new CrimsonCodeGrammarLexer(new ANTLRInputStream(new FileInputStream("src/vb/eindopdracht/test/test.txt"))));
			CrimsonCodeGrammarParser jp = new CrimsonCodeGrammarParser(tokens);
			result = jp.program();
			
			CommonTree t = (CommonTree) result.getTree();
			
			CommonTreeNodeStream nodes = new CommonTreeNodeStream(t);
			
			nodes.setTokenStream(tokens);
			
			CrimsonCodeChecker walker = new CrimsonCodeChecker(nodes);
			walker.program();
			
			System.out.println("\nWalk tree:\n");
			
			printTree(t,0);
			
			
			System.out.println(tokens.toString());
			System.out.println(CrimsonCodeChecker.symbolTable);
			
		} catch (RecognitionException e) {
            System.err.print("ERROR: Recognition exception thrown by compiler: ");
            System.err.println(e.getMessage());
            e.printStackTrace();
        } catch (Exception e) { 
            System.err.print("ERROR: uncaught exception thrown by compiler: ");
            System.err.println(e.getMessage());
            e.printStackTrace();
        }
	
	}
	
	public static void printTree(CommonTree t, int indent) {
		if ( t != null ) {
			StringBuffer sb = new StringBuffer(indent);
			for ( int i = 1; i <= indent; i++ )
				if(i == indent)
					sb = sb.append("|--");
				else
					sb = sb.append("|  ");
			for ( int i = 0; i < t.getChildCount(); i++ ) {
				System.out.println(sb.toString() + t.getChild(i).toString());
				printTree((CommonTree)t.getChild(i), indent+1);
			}
		}
	}
}
