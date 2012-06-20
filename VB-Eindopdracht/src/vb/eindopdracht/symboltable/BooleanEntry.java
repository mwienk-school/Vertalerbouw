package vb.eindopdracht.symboltable;

public class BooleanEntry extends IdEntry {
	private boolean value = false;
	
	public void setValue(Object value) {
		this.value = (Boolean) value;
	}
	
	public boolean isTrue() {
		return value;
	}
	
	public BooleanEntry(String str) {}

}
