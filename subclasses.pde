


//==========================================================================
class PieceColor {
  color col;
  String name;
  float luma; 

  /*
   LightBlue
   DarkOlive
   LightOlive
   Green
   Rust
   Orange
   DarkBlue
   DarkBlack
   LightBlack
   */

  void computeLuma() {
    float CCIR601R = 0.299;
    float CCIR601G = 0.587;
    float CCIR601B = 0.114;

    float BT709R = 0.2126;
    float BT709G = 0.7152;
    float BT709B = 0.0722;

    float r = red(col);
    float g = green(col);
    float b = blue(col); 

    luma = CCIR601R*r + CCIR601G*g + CCIR601B*b;
    // luma = BT709R*r + BT709G*g + BT709B*b;
    // luma = (max(r,g,b) + min(r,g,b))/2.0;
    // luma = 16 + (65.738/256.0)*r + (129.057/256.0)*g + (25.064/256.0)*b;
  }
}

final int ORIENTATION_WIDE = 0; 
final int ORIENTATION_TALL = 1; 

//==========================================================================
class Piece {
  PieceColor pcol;
  String pieceType;
  int orientation; 
  boolean used; 
  float x; 
  float y;
  float w; 
  float h; 

  Piece (PieceColor pc, String pt, float inw, float inh) {
    orientation = ORIENTATION_WIDE;
    pieceType = pt;
    used = false; 
    pcol = pc;
    w = inw;
    h = inh;
    x = 0; 
    y = 0;
  }

  void setIntoQuiltLocation(float top, float left, int orient) {
    x = top; 
    y = left; 
    orientation = orient;
    used = true;
  }

  void draw() {
    float drawW = (orientation == ORIENTATION_WIDE) ? w : h; 
    float drawH = (orientation == ORIENTATION_WIDE) ? h : w; 


    noStroke();
    if (bDrawStroke) {
      stroke(0, 0, 0);
    }
    fill(pcol.col);// pcol.luma
    rect(pieceScale*x, pieceScale*y, pieceScale*drawW, pieceScale*drawH);

    if (bDrawText) {
      fill(0, 0, 0); 
      textAlign(CENTER, CENTER); 
      text(pieceType, pieceScale*(x+drawW/2), pieceScale*(y+drawH/2)-1.5);
    }
  }

  void drawAtOrigin(int orient) {
    float drawW = (orient == ORIENTATION_WIDE) ? w : h; 
    float drawH = (orient == ORIENTATION_WIDE) ? h : w; 

    noStroke();
    fill(pcol.col);
    rect(0, 0, pieceScale*drawW, pieceScale*drawH);

    if (bDrawText) {
      fill(0, 0, 0); 
      textAlign(CENTER, CENTER); 
      text(pieceType, pieceScale*(0+drawW/2), pieceScale*(0+drawH/2)-1.5);
    }
  }
}