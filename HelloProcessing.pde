
// This function is required, this is called once, and used to setup your 
// visualization environment
int mode = 0;
int modeCount = 0;
float dataMin;
float dataMax;

int columnCount = 0;
int[] years;
int yearMin;
int yearMax;
FloatTable data;
float plotX1, plotY1;
float plotX2, plotY2;

float labelX, labelY;


// Small tick line
int volumeIntervalMinor = 5;

// Big tick line
int volumeInterval = 10;


int currentColumn;
int yearInterval = 1;

int rowCount;


void setup() {
    // This is your screen resolution, width, height
    //  upper left starts at 0, bottom right is max width,height
   size(720,405);
  
    // This calls the class FloatTable - java class 
  data = new FloatTable("males-females-children.tsv");
  rowCount = data.getRowCount();

  // Retrieve number of columns in the dataset
  columnCount = data.getColumnCount();
  dataMin = 0;
  dataMax = data.getTableMax();
  years = int(data.getRowNames());  
  yearMin = years[0];
  yearMax = years[years.length - 1];
  
  
    // Corners of the plotted time series
  plotX1 = 120;
  plotX2 = width - 80;
  labelX = 50;
  plotY1 = 60;
  plotY2 = height - 70;
  labelY = height - 25;
  
 
  
  // Print out the columns in this dataset 
  int numColumns = data.getColumnCount();
  int numRows = data.getRowCount();
  
  
  
  
  for ( int i = 0; i < numColumns; i++ ) {
     // print out the first column
     if ( i == 1 ) {
        for (int j = 0; j < numRows; j++ ) {
           float cellValue = data.getFloat( j,i);
//           print("Column " + i + " Row " + j + " " + cellValue + " ");
        }
//        println();
       
       
       
     }
   
    
  }
  
  
}


//Require function that outputs the visualization specified in this function
// for every frame. 
void draw() {
  
  
  // Filling the screen white (FFFF) -- all ones, black (0000)
  background(255);
  drawVisualizationWindow();
  drawGraphLabels();
 
   // These functions contain the labels along with the tick marks
  drawYTickMarks();
  drawXTickMarks();
  drawDataBars(currentColumn);
  
  
  
}


void mousePressed() {
  
  // This is modulating from 1 to 3
  currentColumn = columnCount % 3;
  columnCount += 1;
}






void drawLineData(int col) {
   // Draw the line data based on the current column that is active 
  beginShape( );
  rowCount = data.getRowCount();
  // bottom left corner
  vertex(plotX1,plotY1); 
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2); 
      float y = map(value, dataMin, dataMax, plotY2, plotY1); 
      vertex(x, y);
      print(x,y);
  }
  vertex(plotX2,plotY2);
  vertex(plotX1,plotY1); // Close the polygon
    
    
  }
  endShape( );
  
}
float barWidth = 2; // Add to the end of setup()
void drawDataBars(int col) {
  noStroke( );
  rectMode(CORNERS);
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = data.getFloat(row, col);
     // float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2); 
      float y = map(value, dataMin, dataMax, plotY2, plotY1); 
      rect(x-barWidth/2, y, x+barWidth/2, plotY2);
    }
  }
  
}

void drawYTickMarks() {
  fill(0);
  textSize(10);

  stroke(128);
  strokeWeight(1);
  for (float v = dataMin; v <= dataMax; v += volumeIntervalMinor) { 
    if (v % volumeIntervalMinor == 0) { // If a tick mark
      float y = map(v, dataMin, dataMax, plotY2, plotY1);
      if (v % volumeInterval == 0) { // If a major tick mark
        if (v == dataMin) {
          textAlign(RIGHT); // Align by the bottom
        } else if (v == dataMax) {
          textAlign(RIGHT, TOP); // Align by the top
        } else {
          textAlign(RIGHT, CENTER); // Center vertically
        }
        text(floor(v), plotX1 - 10, y);
        line(plotX1 - 4, y, plotX1, y); // Draw major tick
      } else {
        line(plotX1 - 2, y, plotX1, y); // Draw minor tick
      }
    }
  }  
  
}

void drawXTickMarks() {
  
  fill(0);
  textSize(10);
  textAlign(CENTER, TOP);

  // Use thin, gray lines to draw the grid.
  stroke(224);
  strokeWeight(5);


  for (int row = 0; row < rowCount; row++) {
    if (years[row] % yearInterval == 0) {
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      text(years[row], x, plotY2 + 10);
      
      // Long verticle line over each year interval
      line(x, plotY1, x, plotY2);
    }
  } 
  
}

void drawVisualizationWindow() {
    fill(255);
  rectMode(CORNERS);
  // noStroke( );
  rect(plotX1, plotY1, plotX2, plotY2);
  
}

void drawGraphLabels() {
  fill(0);
  textSize(15);
  textAlign(CENTER, CENTER);
  text("Year", (plotX1+plotX2)/2, labelY);  
  text("Amount\nof\npeople", labelX, (plotY1+plotY2)/2);
  
}