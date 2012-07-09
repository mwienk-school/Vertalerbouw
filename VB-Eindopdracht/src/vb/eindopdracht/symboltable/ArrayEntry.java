package vb.eindopdracht.symboltable;

public class ArrayEntry extends IdEntry {
	private String type;
	private int dimensions;

	public String getArrayType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public int getDimensions() {
		return dimensions;
	}

	public void setDimensions(int dimensions) {
		this.dimensions = dimensions;
	}

	public ArrayEntry(String str) {
		this.setType(str);
		this.numeric = false;
	}

	@Override
	public void setValue(Object o) {
		// TODO Auto-generated method stub
	}
	
	@Override
	public Object getValue() {
		return null;
	}
	
	public String toString() {
		return null;
	}

}
