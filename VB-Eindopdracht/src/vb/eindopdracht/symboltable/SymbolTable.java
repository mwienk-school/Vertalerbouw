package vb.eindopdracht.symboltable;

import java.util.*;

public class SymbolTable<Entry extends IdEntry> {

	protected ArrayList<HashMap<String, Entry>> symbolMapList;

	/**
	 * Constructor.
	 * 
	 * @ensures this.currentLevel() == -1
	 */
	public SymbolTable() {
		symbolMapList = new ArrayList<HashMap<String, Entry>>();
	}

	/**
	 * Opens a new scope.
	 * 
	 * @ensures this.currentLevel() == old.currentLevel()+1;
	 */
	public void openScope() {
		symbolMapList.add(new HashMap<String, Entry>());
	}

	/**
	 * Closes the current scope. All identifiers in the current scope will be
	 * removed from the SymbolTable.
	 * 
	 * @requires old.currentLevel() > -1;
	 * @ensures this.currentLevel() == old.currentLevel()-1;
	 */
	public void closeScope() {
		symbolMapList.remove(this.currentLevel());
	}

	/** Returns the current scope level. */
	public int currentLevel() {
		return symbolMapList.size() - 1;
	}

	/**
	 * Enters an id together with an entry into this SymbolTable using the
	 * current scope level. The entry's level is set to currentLevel().
	 * 
	 * @requires id != null && id.length() > 0 && entry != null;
	 * @ensures this.retrieve(id).getLevel() == currentLevel();
	 * @throws SymbolTableException
	 *             when there is no valid current scope level, or when the id is
	 *             already declared on the current level.
	 */
	public void enter(String id, Entry entry) throws Exception {
		if (this.currentLevel() > -1
				&& !symbolMapList.get(this.currentLevel()).containsKey(id)) {
			entry.setLevel(this.currentLevel());
			symbolMapList.get(this.currentLevel()).put(id, entry);
		} else {
			throw new Exception("On this level (" + this.currentLevel() + "), " + 
								 id + " is already declared.");
		}
	}

	/**
	 * Get the Entry corresponding with id whose level is the highest; in other
	 * words, that is defined last.
	 * 
	 * @return Entry of this id on the highest level null if this SymbolTable
	 *         does not contain id
	 */
	public Entry retrieve(String id) {
		for (int i = this.currentLevel(); i > -1; i--) {
			HashMap<String, Entry> tempHM = symbolMapList.get(i);
			if (tempHM.containsKey(id))
				return tempHM.get(id);
		}
		return null;
	}
	
	/**
	 * Prints the complete SymbolTable at the moment in time;
	 */
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("\n\n====== Current symbolTable ======= \n");
		sb.append("level | entryType                |\n");
		sb.append("----------------------------------\n");
		for(HashMap<String, Entry> hm : symbolMapList) {
			for(String str : hm.keySet()) {
				sb.append("   " + hm.get(str).getLevel() + "  |" + str + "\n");
			}
		}
		sb.append("\n*Keep in mind that the closed levels are removed.");
		return sb.toString();
	}
}
