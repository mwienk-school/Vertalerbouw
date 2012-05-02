package vb.week2.tabular;

public class Parser {
	private void parseLatexTabular() {
		parseBeginTabular();
		parseColsSpec();
		parseRows();
		parseEndTabular();
	}
	
	private void parseColsSpec() {}
	private void parseRows() {}
	private void parseRow() {}
	private void parseEntries() {}
	
	private void parseEntry() {}
	private void parseBeginTabular() {}
	private void parseEndTabular() {}
	private void parseNum() {}
	private void parseIdentifier() {}
}
