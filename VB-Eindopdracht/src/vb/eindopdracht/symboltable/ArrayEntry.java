package vb.eindopdracht.symboltable;

public class ArrayEntry extends IdEntry {
	private String type;

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	@Override
	public void setValue(Object o) {
		// TODO Auto-generated method stub
	}
	
	public ArrayEntry(String str) {
		this.setType(str);
	}

}
