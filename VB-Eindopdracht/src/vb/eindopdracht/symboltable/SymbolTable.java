package vb.eindopdracht.symboltable;

import java.util.*;

public class SymbolTable<Entry extends IdEntry> {

	protected ArrayList<SymbolTableMap<Entry>> symbolMapList;

	/**
	 * Constructor.
	 * 
	 * @ensures this.currentLevel() == -1
	 */
	public SymbolTable() {
		symbolMapList = new ArrayList<SymbolTableMap<Entry>>();
	}

	/**
	 * Opens a new scope.
	 * 
	 * @ensures this.currentLevel() == old.currentLevel()+1;
	 */
	public void openScope() {
		symbolMapList.add(new SymbolTableMap<Entry>());
	}
	
	/**
	 * Return the size of the LB stack
	 * @return
	 */
	public int getCurrentLocalBaseSize() {
		return symbolMapList.get(this.currentLevel()).getLbSize();
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
				&& !symbolMapList.get(this.currentLevel()).getMap().containsKey(id)) {
			entry.setLevel(this.currentLevel());
			symbolMapList.get(this.currentLevel()).add(id, entry);
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
			HashMap<String, Entry> tempHM = symbolMapList.get(i).getMap();
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
		for(SymbolTableMap<Entry> hm : symbolMapList) {
			for(String str : hm.getMap().keySet()) {
				sb.append("   " + hm.getMap().get(str).getLevel() + "  |" + str + "\n");
			}
		}
		sb.append("\n*Keep in mind that the closed levels are removed.");
		return sb.toString();
	}
	
	/**
	 * Een SymbolTableMap is een item in de SymbolTable. 
	 * Dit item is een scope (een level binnen een programma).
	 *
	 * @param <Entry>
	 */
	public class SymbolTableMap<Entry extends IdEntry> {
		private HashMap<String, Entry> map;
		private int lbSize;
		
		/**
		 * Verkrijg de map met de waardes in de symtab
		 * @return
		 */
		public HashMap<String, Entry> getMap() {
			return map;
		}
		
		/**
		 * Voeg een waarde toe aan de symtab
		 * @param id
		 * @param entry
		 */
		public void add(String id, Entry entry) {
			lbSize++;
			map.put(id, entry);
		}
		
		/**
		 * Verkrijg de grootte van de local base (StackBase in geval currentlevel =0) TODO: klopt dat?
		 * @return
		 */
		public int getLbSize() {
			return lbSize;
		}
		
		/**
		 * Maak een nieuwe SymbolTableMap (variabelen op een eigen level in de code).
		 */
		public SymbolTableMap() {
			lbSize = 0;
			map = new HashMap<String, Entry>();
		}
	}
}
