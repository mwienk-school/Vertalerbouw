package vb.eindopdracht.helpers;

/**
 * WhileInfo is een helper klasse voor de teruggave van informatie die later geïnjecteerd moet worden in de TAM code.
 * Door een WhileInfo object terug te geven kan de jump informatie bewaard blijven voor latere statements.
 */
public class WhileInfo {
	public int thisLabelNo;
	public String nextLabel;
	
	/**
	 * Instantieer een WhileInfo object met een labelnummer en een nextlabel veld 
	 * @param thisLabelNo
	 * @param nextLabel
	 */
	public WhileInfo(int thisLabelNo, String nextLabel) {
		this.thisLabelNo = thisLabelNo;
		this.nextLabel = nextLabel;
	}
}
