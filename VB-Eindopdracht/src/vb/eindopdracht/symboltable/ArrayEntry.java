package vb.eindopdracht.symboltable;

import java.util.ArrayList;

public class ArrayEntry extends IdEntry implements Cloneable {
	private String type;
	private int startdim;
	private int enddim;
	private ArrayList<String> entries;

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
		return enddim - startdim + 1;
	}

	public void setDimensions(int startdim, int enddim) {
		this.startdim = startdim;
		this.enddim = enddim;
	}

	public ArrayEntry(String str) {
		this.setType(str);
		this.entries = new ArrayList<String>();
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
		String str = (String) o;
		while (str.contains(",")) {
			int index = str.indexOf(",");
			enter(str.substring(0,index));
			str = str.substring(index + 1);
		}
		enter(str); // No separator (,) after the last entry
	}
	
	@Override
	public Object getValue() {
		String result = "";
		for(int i = 0; i < entries.size(); i++) {
			result += entries.get(i) + ",";
		}
		result = result.substring(0, result.length()-1);
		return result;
	}
	
	/**
	 * Enter a value into the 'array'
	 * @param str
	 * @return the index of the value
	 */
	public int enter(String str) {
		entries.add(str);
		return entries.indexOf(str);
	}
	
	/**
	 * Return the value in the array
	 * @param index
	 * @return
	 */
	public String get(String index) {
		return entries.get(Integer.parseInt(index));
	}
	
	public String toString() {
		return null;
	}

}