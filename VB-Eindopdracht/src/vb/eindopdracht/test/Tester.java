package vb.eindopdracht.test;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import org.antlr.runtime.ANTLRInputStream;
import org.antlr.runtime.CommonTokenStream;
import org.antlr.runtime.RecognitionException;
import org.antlr.runtime.RuleReturnScope;
import org.antlr.runtime.tree.CommonTree;
import org.antlr.runtime.tree.CommonTreeNodeStream;

import vb.eindopdracht.CrimsonCodeChecker;
import vb.eindopdracht.CrimsonCodeGenerator;
import vb.eindopdracht.CrimsonCodeGrammarLexer;
import vb.eindopdracht.CrimsonCodeGrammarParser;

public class Tester {
	public Tester(String inputFile) throws RecognitionException, IOException {
		InputStream in = new FileInputStream(inputFile);
		
		CrimsonCodeGrammarLexer lexer = new CrimsonCodeGrammarLexer(new ANTLRInputStream(in));
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        CrimsonCodeGrammarParser parser = new CrimsonCodeGrammarParser(tokens);
        
        RuleReturnScope result = parser.program();
        CommonTree tree = (CommonTree) result.getTree();
	
		CommonTreeNodeStream nodes = new CommonTreeNodeStream(tree);
		CrimsonCodeChecker checker = new CrimsonCodeChecker(nodes);
		checker.program();
		
		nodes = new CommonTreeNodeStream(tree);
		CrimsonCodeGenerator generator = new CrimsonCodeGenerator(nodes);
		generator.program();	
	}
}
