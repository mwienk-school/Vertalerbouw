package vb.eindopdracht.symboltable;

public class BooleanEntry extends IdEntry {
	private boolean value = false;
	
	/**
	 * Set de value van op true als de waarde "1" is, laat anders ongewijzigd (false)
	 */
	public void setValue(Object value) {
		if(((String) value).equals("1"))
			this.value = true;
	}
	
	/**
	 * Returnt de value als boolen waarde
	 * @return
	 */
	public boolean isTrue() {
		return value;
	}

	@Override
	public Object getValue() {
		return value;
	}
	
	public String toString() {
		return value ? "1" : "0";
	}
	
	public BooleanEntry(String str) {}

}
