package vb.eindopdracht.helpers;

import vb.eindopdracht.symboltable.IdEntry;

public class GeneratorHelper extends CrimsonCodeHelper {
	// Keep track of the Stack size
	private int size;
	// Label for the next output
	private String nextLabel;
	// Identifier for labels (in case of nested (if) statements)
	private int labelNumber;
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
	 * @throws Exception 
	 */
	public void defineConstant(String id, String value) throws Exception {
		IdEntry entry = processEntry(id);
		entry.setType(IdEntry.Type.CONST);
        entry.setValue(value);
	}
	
	/**
	 * Definieer een variabele met de naam id
	 * @param id
	 * @throws Exception 
	 */
	public void defineVariable(String id) throws Exception {
		IdEntry entry = processEntry(id);
		entry.setAddress(size + "[SB]");
		entry.setType(IdEntry.Type.VAR);
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
        printTAM("STORE(1)", symbolTable.retrieve(id).getAddress(), "Store in variable " + id);
        symbolTable.retrieve(id).setValue(value);
	}
	
	/**
	 * Geef de waarde van een variabele terug
	 * @param id
	 * @return
	 */
	public String getValue(String id) {
		return symbolTable.retrieve(id).getValue().toString();
	}
	
	////////////////////////////////////////////////////////////
	/// IF Statement
	////////////////////////////////////////////////////////////
	
	/**
	 * Start voor een if statement (test de stack en jumpt naar label)
	 */
	public int printStatementIf_Start() {
		symbolTable.openScope();
        int thisLabelNo = labelNumber++;
        printTAM("JUMPIF(0)", "Else" + thisLabelNo + "[CB]", "Jump to ELSE");
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
        nextLabel = "End" + thisLabelNo;
        symbolTable.closeScope();
	}

	////////////////////////////////////////////////////////////
	/// WHILE Statement
	////////////////////////////////////////////////////////////
	/**
	 * Print het begin van een while statement
	 * @return WhileInfo object met informatie voor de End mehode
	 */
	public WhileInfo printStatementWhile_Start() {
		symbolTable.openScope();
        int thisLabelNo = labelNumber++;
        if(nextLabel.equals(""))
          nextLabel = "While" + thisLabelNo; //Wanneer while label al ingevuld is, geef deze door
        printTAM("JUMPIF(0)", "End" + thisLabelNo + "[CB]", "Jump past body");
        return new WhileInfo(thisLabelNo, nextLabel);
	}
	
	/**
	 * Print het einde van een while statement
	 * @param info - De teruggegeven info van de start
	 */
	public void printStatementWhile_End(WhileInfo info) {
        printTAM("JUMP", info.nextLabel + "[CB]", "Jump to WHILE-expression");
        nextLabel = "End" + info.thisLabelNo;
        symbolTable.closeScope();
	}
	
	/**
	 * Instantieer een GeneratorHelper
	 */
	public GeneratorHelper() {
		super();
		this.size = 0;
		this.nextLabel = "";
		this.labelNumber = 0;
		this.constantScope = false;
	}
}
