package vb.eindopdracht.symboltable;

public class IntEntry extends IdEntry {
	private int i;
	
	public void setValue(Object i) {
		this.i = (Integer) i;
	}
	
	public int getValue() {
		return i;
	}
	
	public IntEntry(String str) {}

}
