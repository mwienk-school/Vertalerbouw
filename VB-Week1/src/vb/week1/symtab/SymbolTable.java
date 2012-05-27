package vb.week1.symtab;

import java.util.*;

public class SymbolTable<Entry extends IdEntry> {

	protected Stack<HashMap<String, Entry>> symbolMapStack;

	/**
	 * Constructor.
	 * 
	 * @ensures this.currentLevel() == -1
	 */
	public SymbolTable() {
		symbolMapStack = new Stack<HashMap<String, Entry>>();
	}

	/**
	 * Opens a new scope.
	 * 
	 * @ensures this.currentLevel() == old.currentLevel()+1;
	 */
	public void openScope() {
		symbolMapStack.push(new HashMap<String, Entry>());
	}

	/**
	 * Closes the current scope. All identifiers in the current scope will be
	 * removed from the SymbolTable.
	 * 
	 * @requires old.currentLevel() > -1;
	 * @ensures this.currentLevel() == old.currentLevel()-1;
	 */
	public void closeScope() {
		symbolMapStack.pop();
	}

	/** Returns the current scope level. */
	public int currentLevel() {
		return symbolMapStack.size() - 1;
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
	public void enter(String id, Entry entry) throws SymbolTableException {
		if (this.currentLevel() > -1
				&& !symbolMapStack.peek().containsKey(id)) {
			entry.setLevel(this.currentLevel());
			symbolMapStack.peek().put(id, entry);
		} else {
			throw new SymbolTableException("");
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
		Stack<HashMap<String, Entry>> tempStack = new Stack<HashMap<String, Entry>>();
		for (int i = this.currentLevel(); i > -1; i--) {
			HashMap<String, Entry> tempHM = symbolMapStack.pop();
			tempStack.push(tempHM);
			if (tempHM.containsKey(id)) {
				stackBack(tempStack);
				return tempHM.get(id);
			}	
		}
		stackBack(tempStack);
		return null;
	}
	
	private void stackBack(Stack<HashMap<String, Entry>> s) {
		while(!s.empty()) {
			symbolMapStack.push(s.pop());
		}
	}
}

/** Exception class to signal problems with the SymbolTable */
class SymbolTableException extends Exception {
	/** {@link serialVersionUID} is required for Serializable */
	public static final long serialVersionUID = 24362462L;

	public SymbolTableException(String msg) {
		super(msg);
	}
}
