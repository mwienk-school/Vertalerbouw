package vb.eindopdracht.symboltable;

public class ArrayEntry<E> extends IdEntry {
	private String type;
	private int dimensions;

	public String getType() {
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

	@Override
	public void setValue(Object o) {
		// TODO Auto-generated method stub
	}
	
	public ArrayEntry(String str) {
		this.setType(str);
	}

}
