package vb.eindopdracht.symboltable;

public class ArrayEntry extends IdEntry implements Cloneable {
	private String type;
	private int startdim;
	private int enddim;

	public String getArrayType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public int getStartDimension() {
		return startdim;
	}
	
	public int getEndDimension() {
		return enddim;
	}
	
	public int getArraySize() {
		return enddim - startdim +1;
	}

	public void setDimensions(int startdim, int enddim) {
		this.startdim = startdim;
		this.enddim = enddim;
	}

	public ArrayEntry(String str) {
		this.setType(str);
		this.numeric = false;
	}
	
	/**
	 * Return het address van een entry in de array
	 * @param offset
	 * @return
	 */
	public String getOffsetAddress(String offset) {
		int numoffset = Integer.parseInt(offset);
		//Get numeric part of the address
		int numaddress = Integer.parseInt((getAddress().substring(0,getAddress().indexOf("["))));
		//Get registry part of the address
		return "" + (numoffset+numaddress) + (getAddress().substring(getAddress().indexOf("["), getAddress().indexOf("]")+1));
	}
	
	/**
	 * Generate a new Array instance from the Array description
	 * @param id
	 * @return
	 */
	public ArrayEntry generateArray(String id) {
		ArrayEntry result = new ArrayEntry(id);
		result.setDimensions(this.startdim, this.enddim);
		return result;
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
