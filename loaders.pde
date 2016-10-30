
//--------------------------------------------------------
void loadPieces() {
  pieceArrayList = new ArrayList<Piece>(); 

  for (int i=0; i<nPieceColors; i++) {
    TableRow aTableRow = PieceTable.getRow(i); 

    PieceColor pc = pieceColorArray[i];
    // println (pc.name + "\t\t"); 

    for (int j=0; j<nPieceTypes; j++) {
      String pieceTypeString = "" + ((char)('A' + j));
      int nPiecesOfThisTypeWithThisColor = aTableRow.getInt(pieceTypeString);

      for (int k=0; k<nPiecesOfThisTypeWithThisColor; k++) {
        TableRow aPieceDimensionsRow = PieceDimensions.getRow(j);

        float pieceW = aPieceDimensionsRow.getFloat("Width"); 
        float pieceH = aPieceDimensionsRow.getFloat("Height"); 
        Piece aPiece = new Piece (pc, pieceTypeString, pieceW, pieceH);
        pieceArrayList.add(aPiece); 

        // print(pieceTypeString + " " + nPiecesOfThisTypeWithThisColor + "\t"); 
        // println (nf(k,3) + " " + pieceTypeString + " (" + pieceW + "/" + pieceH + ")\t");
      }
    }
  }

  // println("n Pieces = " + pieceArrayList.size());
}




//--------------------------------------------------------
void loadPieceColors() {
  pieceColorArray = new PieceColor[nPieceColors];
  for (int i=0; i<nPieceColors; i++) {
    TableRow aTableRow = PieceTable.getRow(i); 
    String colorName = aTableRow.getString("ColorName"); 
    int r = aTableRow.getInt("Red");
    int g = aTableRow.getInt("Green");
    int b = aTableRow.getInt("Blue");

    PieceColor aPieceColor = new PieceColor();
    aPieceColor.name = colorName;
    aPieceColor.col = color(r, g, b); 
    aPieceColor.computeLuma(); 

    pieceColorArray[i] = aPieceColor;
  }
}