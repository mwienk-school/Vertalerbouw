package vb.eindopdracht.symboltable;

public class CharEntry extends IdEntry {
	private char ch;
	
	public void setValue(Object ch) {
		this.ch = (Character) ch;
	}
	
	public char getChar() {
		return ch;
	}

}
