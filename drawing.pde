//--------------------------------------------------------
void drawAllPieceColors() {
  for (int i=0; i<nPieceColors; i++) {
    noStroke();
    fill (pieceColorArray[i].col); 
    rect (i*50, 0, 50, 100);
  }
}



//--------------------------------------------------------
void drawAllPiecesAsList() {

  int nPieces = pieceArrayList.size();

  float px = 0; 
  float py = 0; 
  boolean bRowHitSquare = false;
  for (int i=0; i<nPieces; i++) {
    Piece ithPiece = pieceArrayList.get(i);
    float pw = pieceScale * (ithPiece.w + 0.25);
    float ph = pieceScale * 1.75;
    if (ithPiece.h > 1.5){
      bRowHitSquare = true;
    }

    pushMatrix();
    translate(px, py); 
    ithPiece.drawAtOrigin(ORIENTATION_WIDE); 
    popMatrix();

    if (px > (width-200)) {
      px = 0; 
      py += ph;
      if (bRowHitSquare){
        py += pieceScale * 1.5;
        bRowHitSquare = false;
      }
      
    } else {
      px += pw;
    }
  }
}


//--------------------------------------------------------
void drawQuiltPieces() {
  // draw each piece as a member of the quilt arraylist
  int nPiecesInQuilt = quilt.size();
  for (int i=0; i<nPiecesInQuilt; i++) {
    Piece ithPiece = quilt.get(i);
    stroke(0); 
    ithPiece.draw();
  }
}