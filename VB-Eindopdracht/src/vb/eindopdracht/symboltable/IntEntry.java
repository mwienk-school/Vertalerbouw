package vb.eindopdracht.symboltable;

public class IntEntry extends IdEntry {
	private int i;
	
	public void setValue(Object i) {
		this.i = (Integer) i;
	}
	
	@Override
	public Object getValue() {
		return i;
	}
	
	public IntEntry(String str) {}
	
	public String toString() {
		return String.valueOf(i);
	}

}
