package vb.eindopdracht.helpers;

import java.util.HashMap;

import vb.eindopdracht.symboltable.Variable;

public class GeneratorHelper {
	// Keep track of the Stack size
	private int size;
	// Keep track of the level
	private int indent;
	// Label for the next output
	private String nextLabel;
	// Identifier for labels (in case of two e.g. 2 if statements)
	private int labelNumber;
	// Keep track of variables and constants
	private HashMap<String, Variable> vars;
	// If in constant scope, operands should not output
	private boolean constantScope;
	
	/**
	 * Stel constantScope in, dit heeft gevolgen voor het printen van TAM statements mbt constante waardes
	 * @param b - De constantScope waarde
	 */
	public void setConstantScope(boolean b) {
		constantScope = b;
	}
	
	/**
	 * Bekijk of de Generator zich in een constantScop bevindt
	 */
	public boolean isConstantScope() {
		return constantScope;
	}

	/**
	 * printTAM print een mooi opgemaakte TAM instructie
	 * 
	 * @param lbl
	 *            - Label voor de instructie
	 * @param cmd
	 *            - De instructie zelf
	 * @param arg
	 *            - Het argument van de instructie
	 * @param cmt
	 *            - Eventueel commentaar op bij de instructie
	 */
	private void printTAM(String lbl, String cmd, String arg, String cmt) {
		if (!lbl.equals("") && lbl != null)
			lbl = lbl + ":";
		System.out.format("%-9s %-9s %9s ; %s%n", lbl, cmd, arg, cmt);
	}

	/**
	 * printTAM print een mooi opgemaakte TAM instructie de aanroep zonder label
	 * veld gebruikt het nextLabel veld voor de aanroep.
	 * 
	 * @param cmd
	 *            - De instructie
	 * @param arg
	 *            - Het argument van de instructie
	 * @param cmt
	 *            - Eventueel commentaar bij de instructie
	 */
	private void printTAM(String cmd, String arg, String cmt) {
		printTAM(nextLabel, cmd, arg, cmt);
		nextLabel = "";
	}

	/**
	 * printTAM print een mooi opgemaakte TAM instructie Het nextLabel veld en
	 * het commenteer zijn leeg.
	 * 
	 * @param cmd
	 *            - De instructie
	 * @param arg
	 *            - Het argument van de instructie
	 */
	private void printTAM(String cmd, String arg) {
		printTAM(nextLabel, cmd, arg, "");
		nextLabel = "";
	}
	
	/**
	 * Clears the stack and sends a Halt signal to the virtual machine.
	 */
	public void endProgram() {
		printTAM("POP(0)", String.valueOf(size), "Pop " + size + " variables");
		printTAM("HALT", "", "End of program");
	}
	
	/**
	 * Definieer een constante waarde (variabele die niet in het geheugen is opgeslagen).
	 * @param id
	 * @param value
	 */
	public void defineConstant(String id, String value) {
        Variable constant = new Variable(null,true);
        constant.setValue(value);
        vars.put(id, constant);
        constantScope = false;
	}
	
	/**
	 * Definieer een variabele met de naam id
	 * TODO: Vervangen door SymbolTable implementatie?
	 * @param id
	 */
	public void defineVariable(String id) {
        vars.put(id, new Variable(size + "[SB]"));
        printTAM("PUSH", "1", "Push variable " + id);
        size++;
	}
	
	/**
	 * Print een primitive routine (een aanroep naar de VM met CALL)
	 * @param cmd
	 * @param comment
	 */
	public void printPrimitiveRoutine(String cmd, String comment) {
		printTAM("CALL", cmd, comment);
	}
	
	/**
	 * Laadt een literal waarde op de stack
	 * @param literal
	 */
	public void loadLiteral(String literal) {
		printTAM("LOADL", literal, "Load literal value '" + literal + "'");
	}
	
	/**
	 * Sla een waarde op in een variabele 'id'
	 * @param id
	 * @param value
	 */
	public void storeValue(String id, String value) {
        printTAM("STORE(1)", vars.get(id).getAddress(), "Store in variable " + id);
        vars.get(id).setValue(value);
	}
	
	/**
	 * Geef de waarde van een variabele terug
	 * @param id
	 * @return
	 */
	public String getValue(String id) {
		return vars.get(id).getValue();
	}
	
	////////////////////////////////////////////////////////////
	/// IF Statement
	////////////////////////////////////////////////////////////
	
	/**
	 * Start voor een if statement (test de stack en jumpt naar label)
	 */
	public int printStatementIf_Start() {
        int thisLabelNo = labelNumber++;
        printTAM("JUMPIF(0)", "Else" + thisLabelNo + "[CB]", "Jump to ELSE");
        indent++;
        return thisLabelNo;
	}
	
	/**
	 * Print de instructies voor de else clause
	 * @param thisLabelNo
	 */
	public void printStatementIf_Else(int thisLabelNo) {
		printTAM("JUMP", "End" + thisLabelNo + "[CB]", "Jump over ELSE");
        nextLabel ="Else" + thisLabelNo;
	}
	
	/** 
	 * Print de instructies voor het einde van het if statement
	 * @param thisLabelNo
	 */
	public void printStatementIf_End(int thisLabelNo) {
        indent--;
        nextLabel = "End" + thisLabelNo;
	}

	////////////////////////////////////////////////////////////
	/// WHILE Statement
	////////////////////////////////////////////////////////////
	public WhileInfo printStatementWhile_Start() {
        int thisLabelNo = labelNumber++;
        if(nextLabel.equals(""))
          nextLabel = "While" + thisLabelNo; //Wanneer while label al ingevuld is, geef deze door
        printTAM("JUMPIF(0)", "End" + thisLabelNo + "[CB]", "Jump past body");
        indent++;
        return new WhileInfo(thisLabelNo, nextLabel);
	}
	
	/**
	 * Print het einde van een while statement
	 * @param info - De teruggegeven info van de start
	 */
	public void printStatementWhile_End(WhileInfo info) {
        printTAM("JUMP", info.nextLabel + "[CB]", "Jump to WHILE-expression");
        nextLabel = "End" + info.thisLabelNo;
        indent--;
	}
	
	/**
	 * Instantiate a GeneratorHelper
	 */
	public GeneratorHelper() {
		this.size = 0;
		this.indent = 0;
		this.nextLabel = "";
		this.labelNumber = 0;
		this.vars = new HashMap<String, Variable>();
		this.constantScope = false;
	}
}
