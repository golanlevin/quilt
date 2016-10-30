import java.util.Arrays;
import java.util.HashSet;


Table PieceTable;
Table PieceDimensions;

int nPieceColors = 0; 
PieceColor[] pieceColorArray;

int nPieceTypes = 8; // A...H
ArrayList<Piece> pieceArrayList;
ArrayList<Piece> quilt;

float pieceScale = 10;
boolean bRandomizeQuiltUnits = false;

int nQuiltUnitRows = 8; 
int nQuiltUnitCols = 8;
QuiltUnit quiltUnits[]; 
QuiltUnit tempQuiltUnit;


import processing.sound.*;
TriOsc myOscillator;
boolean bUseSound = false;
boolean bDrawText = false;
boolean bDrawStroke = false;

//--------------------------------------------------------
void setup() {
  size(960, 960); 
  frameRate(16);

  PieceTable = loadTable("piece_census.tsv", "header"); 
  PieceDimensions = loadTable("piece_dimensions.tsv", "header"); 

  nPieceColors = PieceTable.getRowCount();
  loadPieceColors();
  loadPieces();

  createQuiltUnits();

  // Create wave oscillator.
  if (bUseSound) {
    myOscillator = new TriOsc(this);
  }
}

//--------------------------------------------------------
void draw() {

  background(0, 255, 128); //55, 46, 41);
  // drawAllPiecesAsList();
  drawQuiltUnits();

  if (bRandomizeQuiltUnits) {
    swapRandomQuiltUnits();

    if (bUseSound) {
      myOscillator.freq( random(200, 800));
    }
  }
  
  //float r = 64;//map(mouseX,0,width, 0,255); //60; //map(mouseX,0,width, 0,255);
  //float g = 40;
  //float b = 47;//map(mouseY,0,height, 0,255); //45;// map(mouseY,0,height, 0,255);
  //pieceColorArray[0].col = color(r,g,b);
  //println(r + " " + g + " " + b);
  
  float h = 9.09;//hue(pieceColorArray[4].col); 
  float s = 189; // map(mouseX,0,width, 0,255); //209; //saturation(pieceColorArray[4].col); 
  float br = 138; //map(mouseY,0,height, 0,255); //194; //brightness(pieceColorArray[4].col); 
  
  //(pieceColorArray[4].col); 
  colorMode(HSB,255); 
  //pieceColorArray[4].col = color(h,s,br);
  colorMode(RGB,255); 
  //println(h + " " + s + " " + br);
  float r = red(pieceColorArray[4].col);
  float g = green(pieceColorArray[4].col);
  float b = blue(pieceColorArray[4].col);
  //println(r + " " + g + " " + b);
}

//--------------------------------------------------------
void swapRandomQuiltUnits() {
  int raR = (int) random(nQuiltUnitRows); 
  int raC = (int) random(nQuiltUnitCols); 
  int rbR = (int) random(nQuiltUnitRows); 
  int rbC = (int) random(nQuiltUnitCols); 

  if (!((raR == rbR) && (raC == rbC))) {
    tempQuiltUnit = quiltUnits[raR*nQuiltUnitCols + raC]; 
    quiltUnits[raR*nQuiltUnitCols + raC] = quiltUnits[rbR*nQuiltUnitCols + rbC];
    quiltUnits[rbR*nQuiltUnitCols + rbC] = tempQuiltUnit;
  }
  float pan = map(raC, 0, nQuiltUnitCols-1, -1.0, 1.0);
}

//--------------------------------------------------------
void keyPressed() {
  bRandomizeQuiltUnits = !bRandomizeQuiltUnits;
  if (bUseSound) {
    if (bRandomizeQuiltUnits) {
      myOscillator.play();
    } else {
      myOscillator.stop();
    }
  }
}

//--------------------------------------------------------
void drawQuiltUnits() {
  for (int r=0; r<nQuiltUnitRows; r++) {
    for (int c=0; c<nQuiltUnitCols; c++) {
      QuiltUnit qurc = quiltUnits[r*nQuiltUnitCols + c]; //quiltUnits[r][c]; 
      qurc.draw(r, c);
    }
  }
}



//--------------------------------------------------------
Piece getAndReserveUnusedPiece(String pieceType, String colorName) {
  int index = findIndexOfUnusedPiece(pieceType, colorName);
  if (index >= 0) {
    Piece resultPiece = pieceArrayList.get(index);
    resultPiece.used = true;
    return resultPiece;
  }

  // println("Failed to find any piece " + pieceType + " with color " + colorName); 
  return null;
}

//--------------------------------------------------------
int findIndexOfUnusedPiece1(String pieceType, String colorName) {
  int result = -1; //
  if (colorName.equals("*")) {
    int nPieces = pieceArrayList.size();
    for (int i=0; i<nPieces; i++) {
      Piece ithPiece = pieceArrayList.get(i);
      if (
        (ithPiece.used == false) &&
        (ithPiece.pieceType.equals(pieceType))) {
        result = i;
      }
    }
  } else {
    int nPieces = pieceArrayList.size();
    for (int i=0; i<nPieces; i++) {
      Piece ithPiece = pieceArrayList.get(i);
      if (
        (ithPiece.used == false) &&
        (ithPiece.pieceType.equals(pieceType)) && 
        (ithPiece.pcol.name.equals(colorName))) {
        result = i;
      }
    }
  }
   
  return result;
}


//--------------------------------------------------------
int findIndexOfUnusedPiece(String pieceType, String colorName) {
  int result = -1; //
  int nTries = 0; 
  while ((result < 0) && (nTries < 1000000)) {
    int nPieces = pieceArrayList.size();
    int randomPieceID = (int)random(nPieces); 
    Piece randomPiece = pieceArrayList.get(randomPieceID);
    nTries++;
    if ((randomPiece.used == false) && 
        (randomPiece.pieceType.equals(pieceType))) {
      result = randomPieceID;
    }
  }
  println(nTries);
  return result;
}



//--------------------------------------------------------
void createQuiltUnits() {
  quilt = new ArrayList<Piece>();
  // quiltUnits = new QuiltUnit[nQuiltUnitRows][nQuiltUnitCols];
  quiltUnits = new QuiltUnit[nQuiltUnitRows * nQuiltUnitCols];
  for (int r=0; r<nQuiltUnitRows; r++) {
    for (int c=0; c<nQuiltUnitCols; c++) {
      int quindex = r*nQuiltUnitCols + c;
      quiltUnits[quindex] = new QuiltUnit(); 
      populateQuiltUnit (quiltUnits[quindex]);
      float luma      = quiltUnits[quindex].computeLuminance(); 
      float diag      = quiltUnits[quindex].computeDiagonality();
      float redness   = quiltUnits[quindex].computeRedness();
      int nColors     = quiltUnits[quindex].countColors();
      float loopiness = quiltUnits[quindex].computeLoopiness();
    }
  }
  Arrays.sort(quiltUnits);


  for (int r=0; r<nQuiltUnitRows; r++) {
    for (int c=0; c<nQuiltUnitCols; c++) {
      int quindex = r*nQuiltUnitCols + c;
      float loopiness = quiltUnits[quindex].loopiness;
      //print(nf(loopiness, 1, 3) + "\t");
    }
    //println();
  }
}

//--------------------------------------------------------
void populateQuiltUnit (QuiltUnit QU) { //, float x, float y) {

  Piece hPiece0 = getAndReserveUnusedPiece("H", "*");
  Piece gPiece0 = getAndReserveUnusedPiece("G", "*"); 
  Piece gPiece1 = getAndReserveUnusedPiece("G", "*"); 
  Piece fPiece0 = getAndReserveUnusedPiece("F", "*"); 
  Piece fPiece1 = getAndReserveUnusedPiece("F", "*"); 
  Piece ePiece0 = getAndReserveUnusedPiece("E", "*"); 
  Piece ePiece1 = getAndReserveUnusedPiece("E", "*"); 
  Piece dPiece0 = getAndReserveUnusedPiece("D", "*"); 
  Piece dPiece1 = getAndReserveUnusedPiece("D", "*");  
  Piece cPiece0 = getAndReserveUnusedPiece("C", "*"); 
  Piece cPiece1 = getAndReserveUnusedPiece("C", "*"); 
  Piece bPiece0 = getAndReserveUnusedPiece("B", "*"); 
  Piece aPiece0 = getAndReserveUnusedPiece("A", "*"); 

  TableRow HRow = PieceDimensions.findRow("H", "Name");
  TableRow GRow = PieceDimensions.findRow("G", "Name");
  TableRow FRow = PieceDimensions.findRow("F", "Name");
  TableRow ERow = PieceDimensions.findRow("E", "Name");
  TableRow DRow = PieceDimensions.findRow("D", "Name");
  TableRow CRow = PieceDimensions.findRow("C", "Name");
  TableRow BRow = PieceDimensions.findRow("B", "Name");
  TableRow ARow = PieceDimensions.findRow("A", "Name");

  float th = HRow.getFloat("Height"); // thickness
  float Hw = HRow.getFloat("Width"); 
  float Gw = GRow.getFloat("Width"); 
  float Fw = FRow.getFloat("Width"); 
  float Ew = ERow.getFloat("Width"); 
  float Dw = DRow.getFloat("Width"); 
  float Cw = CRow.getFloat("Width"); 
  float Bw = BRow.getFloat("Width"); 
  float Aw = ARow.getFloat("Width"); 
  float Ah = ARow.getFloat("Height"); 

  int quPCount = 0; 

  if (hPiece0 != null) {
    hPiece0.setIntoQuiltLocation (0, 0, ORIENTATION_WIDE);
    quilt.add(hPiece0);
    QU.setPiece(quPCount++, hPiece0);
  }
  if (gPiece0 != null) {
    gPiece0.setIntoQuiltLocation (0, 0+th, ORIENTATION_TALL);
    quilt.add(gPiece0);
    QU.setPiece(quPCount++, gPiece0);
  }
  if (gPiece1 != null) {
    gPiece1.setIntoQuiltLocation (0+th, 0+Gw, ORIENTATION_WIDE);
    quilt.add(gPiece1);
    QU.setPiece(quPCount++, gPiece1);
  }
  if (fPiece0 != null) {
    fPiece0.setIntoQuiltLocation (0+Gw, 0+th, ORIENTATION_TALL);
    quilt.add(fPiece0);
    QU.setPiece(quPCount++, fPiece0);
  }
  if (fPiece1 != null) {
    fPiece1.setIntoQuiltLocation (0+th, 0+th, ORIENTATION_WIDE);
    quilt.add(fPiece1);
    QU.setPiece(quPCount++, fPiece1);
  }
  if (ePiece0 != null) {
    ePiece0.setIntoQuiltLocation (0+th, 0+2*th, ORIENTATION_TALL); 
    quilt.add(ePiece0);
    QU.setPiece(quPCount++, ePiece0);
  }
  if (ePiece1 != null) {
    ePiece1.setIntoQuiltLocation (0+2*th, 0+Fw, ORIENTATION_WIDE);
    quilt.add(ePiece1);
    QU.setPiece(quPCount++, ePiece1);
  }
  if (dPiece0 != null) {
    dPiece0.setIntoQuiltLocation (0+Fw, 0+2*th, ORIENTATION_TALL);
    quilt.add(dPiece0);
    QU.setPiece(quPCount++, dPiece0);
  }
  if (dPiece1 != null) { 
    dPiece1.setIntoQuiltLocation (0+2*th, 0+2*th, ORIENTATION_WIDE);
    quilt.add(dPiece1);
    QU.setPiece(quPCount++, dPiece1);
  }
  if (cPiece0 != null) { 
    cPiece0.setIntoQuiltLocation (0+2*th, 0+3*th, ORIENTATION_TALL);
    quilt.add(cPiece0);
    QU.setPiece(quPCount++, cPiece0);
  }
  if (cPiece1 != null) {
    cPiece1.setIntoQuiltLocation (0+3*th, 0+3*th+Ah, ORIENTATION_WIDE);
    quilt.add(cPiece1);
    QU.setPiece(quPCount++, cPiece1);
  }
  if (bPiece0 != null) {
    bPiece0.setIntoQuiltLocation (0+3*th+Aw, 0+3*th, ORIENTATION_TALL);
    quilt.add(bPiece0);
    QU.setPiece(quPCount++, bPiece0);
  }
  if (aPiece0 != null) {
    aPiece0.setIntoQuiltLocation (0+3*th, 0+3*th, ORIENTATION_WIDE);
    quilt.add(aPiece0);
    QU.setPiece(quPCount++, aPiece0);
  }
}