/*
 * @(#)DrawerFrame.java                        2.0 1999/08/11
 *
 * Copyright (C) 1999 D.A. Watt and D.F. Brown
 * Dept. of Computing Science, University of Glasgow, Glasgow G12 8QQ Scotland
 * and School of Computer and Math Sciences, The Robert Gordon University,
 * St. Andrew Street, Aberdeen AB25 1HG, Scotland.
 * All rights reserved.
 *
 * This software is provided free for educational use only. It may
 * not be used for commercial purposes without the prior written permission
 * of the authors.
 */

package Triangle.TreeDrawer;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

class DrawerFrame extends JFrame {
  public DrawerFrame (JPanel panel) {
    setSize(300, 200);
    Toolkit tk = Toolkit.getDefaultToolkit();
    Dimension d = tk.getScreenSize();
    int screenHeight = d.height;
    int screenWidth = d.width;
    setTitle("Triangle Compiler Abstract Syntax Tree");
    setSize(screenWidth / 2, screenHeight / 2);
    setLocation(screenWidth / 4, screenHeight / 4);
    // Image img = tk.getImage("icon.gif");
    // setIconImage(img);

    addWindowListener(
      new WindowAdapter() {
        public void windowClosing (WindowEvent e) {
      	  System.exit(0);
        }
      }
    );
    Container contentPane = getContentPane();
    contentPane.add(new JScrollPane(panel));
  }
}