package vb.eindopdracht.symboltable;

public class CharEntry extends IdEntry {
	private char ch;
	
	public void setValue(Object ch) {
		this.ch = ((String) ch).toCharArray()[0];
	}
	
	public char getChar() {
		return ch;
	}
	
	public CharEntry(String str) {	}

	@Override
	public Object getValue() {
		return ch;
	}
	
	public String toString() {
		return String.valueOf(ch);
	}

}
