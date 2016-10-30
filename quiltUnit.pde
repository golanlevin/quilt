//==========================================================================

final int nPiecesPerQuiltUnit = 13;
final int QUILT_UNIT_WIDTH = 12; 
final int QUILT_UNIT_HEIGHT = 12; 

class QuiltUnit implements Comparable<QuiltUnit> {

  Piece pieceArray[]; 
  float averageLuminance;
  float diagonality;
  float loopiness;
  float redness; 
  int nColors; 
  HashSet<String> myHashSet;

  QuiltUnit() {
    pieceArray = new Piece[nPiecesPerQuiltUnit];
    myHashSet = new HashSet<String>();
    averageLuminance = 0;
    diagonality = 0;
    loopiness = 0; 
    redness = 0; 
    nColors = 0;
  }

  public int compareTo(QuiltUnit qu) {
    float propA = averageLuminance;
    float propB = qu.averageLuminance;

    int out = 0; 
    float delta = propA - propB;
    if (delta < 0) {
      out = -1;
    }
    if (delta > 0) {
      out = 1;
    }
    return out;
  }

  void setPiece(int index, Piece P) {
    if ((index >=0) && (index < nPiecesPerQuiltUnit) && (P != null)) {
      pieceArray[index] = P;
    }
  }

  //-------------------------
  int countColors() {
    myHashSet.clear();
    int out = 0; 
    for (int i=0; i<nPiecesPerQuiltUnit; i++) {
      Piece ithPiece = pieceArray[i];
      if (ithPiece != null) {
        String pcolName = ithPiece.pcol.name;
        myHashSet.add(pcolName);
      }
    }
    out = myHashSet.size();
    nColors = out;
    return out;
  }

  //-------------------------
  float computeLuminance() {
    float lumaCuma = 0; 
    for (int i=0; i<nPiecesPerQuiltUnit; i++) {
      Piece ithPiece = pieceArray[i];
      if (ithPiece != null) {
        lumaCuma += ithPiece.pcol.luma * ithPiece.w * ithPiece.h;
      }
    }
    lumaCuma /= (QUILT_UNIT_WIDTH * QUILT_UNIT_HEIGHT); 
    averageLuminance = lumaCuma;
    return averageLuminance;
  }

  //-------------------------
  float computeRedness() {
    float out = 0; 
    for (int i=0; i<nPiecesPerQuiltUnit; i++) {
      Piece ithPiece = pieceArray[i];
      if (ithPiece != null) {
        color col = ithPiece.pcol.col;
        //float R = red(col) / (red(col) + green(col) + blue(col));
        float R = red(col) - (green(col) + blue(col))/2.0;
        float scaledR = R * sqrt(ithPiece.w * ithPiece.h);
        out += scaledR;
      }
    }
    out /= (QUILT_UNIT_WIDTH * QUILT_UNIT_HEIGHT); 
    redness = out;
    return redness;
  }

  //-------------------------
  boolean getHasNullPiece() {
    boolean bBad = false;
    for (int i=0; i<nPiecesPerQuiltUnit; i++) {
      Piece ithPiece = pieceArray[i];
      if (ithPiece == null) {
        bBad = true;
      }
    }
    return bBad;
  }

  //-------------------------
  float computeDiagonality() {
    float tr = 0; // top right
    float bl = 0; // bottom left
    float diag = 0; 

    boolean bBad = getHasNullPiece();
    if (!bBad) {
      tr += pieceArray[0].pcol.luma * pieceArray[0].w * pieceArray[0].h;
      tr += pieceArray[3].pcol.luma * pieceArray[3].w * pieceArray[3].h;
      tr += pieceArray[4].pcol.luma * pieceArray[4].w * pieceArray[4].h;
      tr += pieceArray[7].pcol.luma * pieceArray[7].w * pieceArray[7].h;
      tr += pieceArray[8].pcol.luma * pieceArray[8].w * pieceArray[8].h;
      tr += pieceArray[11].pcol.luma * pieceArray[11].w * pieceArray[11].h;

      bl += pieceArray[1].pcol.luma * pieceArray[1].w * pieceArray[1].h;
      bl += pieceArray[2].pcol.luma * pieceArray[2].w * pieceArray[2].h;
      bl += pieceArray[5].pcol.luma * pieceArray[5].w * pieceArray[5].h;
      bl += pieceArray[6].pcol.luma * pieceArray[6].w * pieceArray[6].h;
      bl += pieceArray[9].pcol.luma * pieceArray[9].w * pieceArray[9].h;
      bl += pieceArray[10].pcol.luma * pieceArray[10].w * pieceArray[10].h;

      diag = (tr - bl)/(QUILT_UNIT_WIDTH * QUILT_UNIT_HEIGHT);
    }
    diagonality = diag;
    return diag;
  }

  //-------------------------
  float computeLoopiness() {
    float out = 0;

    // 5,6,7,8 loop
    boolean bBad = getHasNullPiece();
    if (!bBad) {
      float l1 = pieceArray[1].pcol.luma;
      float l2 = pieceArray[2].pcol.luma;
      float l3 = pieceArray[3].pcol.luma;
      float l4 = pieceArray[4].pcol.luma;
      float l5 = pieceArray[5].pcol.luma;
      float l6 = pieceArray[6].pcol.luma;
      float l7 = pieceArray[7].pcol.luma;
      float l8 = pieceArray[8].pcol.luma;
      float l9 = pieceArray[9].pcol.luma;
      float l10 = pieceArray[10].pcol.luma;
      float l11 = pieceArray[11].pcol.luma;
      float l12 = pieceArray[12].pcol.luma;


      float min5678 = min(min(l5, l6, l7), l8); 
      float max5678 = max(max(l5, l6, l7), l8); 
      float avg5678 = (l5+l6+l7+l8)/4.0; 
      float range5678 = max5678 - min5678;

      float min1234 = min(min(l1, l2, l3), l4); 
      float max1234 = max(max(l1, l2, l3), l4); 
      float avg1234 = (l1+l2+l3+l4)/4.0; 
      float range1234 = max1234 - min1234;

      out = range5678+range1234;
    }
    loopiness = out;
    return out;
  }



  //-------------------------
  void draw(int row, int col) {
    stroke(0); 
    pushMatrix(); 
    translate(col*QUILT_UNIT_WIDTH*pieceScale, row*QUILT_UNIT_HEIGHT*pieceScale); 
    for (int i=0; i<nPiecesPerQuiltUnit; i++) {
      Piece ithPiece = pieceArray[i];
      if (ithPiece != null) {
        ithPiece.draw();

        if (bDrawText) {
          fill(0, 0, 0); 
          textAlign(CENTER, CENTER); 
          float drawW = (ithPiece.orientation == ORIENTATION_WIDE) ? ithPiece.w : ithPiece.h; 
          float drawH = (ithPiece.orientation == ORIENTATION_WIDE) ? ithPiece.h : ithPiece.w; 
          text(i, pieceScale*(ithPiece.x+drawW/2), pieceScale*(ithPiece.y+drawH/2)-1.5);
        }
      }
    }
    popMatrix();
  }
}