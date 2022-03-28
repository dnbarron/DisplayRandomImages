// Reads random images from a folder and displays in random locations on the screen
// Press <space> to pause, <Esc> to exit

import java.io.File;
import java.io.FilenameFilter;
import java.awt.Rectangle;

int numimages = 12;    // Number of images to display at a time
int xfactor = 10;      // Reduce image sizes by this factor
int yfactor = xfactor;

int alpha = 126;  // level of transparency for overlapping images

float t1;
float interval = 3000;   //Length of time between screen refreshes


String yourPath = "C:\\Users\\dnbar\\Dropbox\\Art\\Ella\\Body of Work\\Ellas course";  // Folder containing the images
File someFolder = new File(yourPath);

FilenameFilter filter = new FilenameFilter() {  // Filter ensures only jpegs are selected
  public boolean accept(File dir, String name)
  {
    if (name.endsWith(".JPEG") || name.endsWith(".jpeg")) {  //Only displays jpegs
      return true;
    } else {
      return false;
    }
  }
};

String[] someFolderList = someFolder.list(filter);
IntList files = new IntList();

boolean pause = false;

void keyPressed() {
  if (key == ' ') {
    pause = !pause;
  }
}


void iteration() {

  background(0, 0, 100);  // black background
  t1 = millis();        // to time the display
  PImage[] img = new PImage[numimages];                          // to hold the images once loaded
  ArrayList<Rectangle> rectangles = new ArrayList<Rectangle>();  // To hold the locations of the images
  StringList imageList = new StringList();                        // To hold file names of images
  boolean[] collision = new boolean[numimages];

  files.shuffle();  // shuffle IntList that runs from 0 to 1-(number of files in folder). Avoids duplicates

  for (int i = 1; i <= numimages; i++) {
    int n = files.get(i - 1);
    int x = int(random(width));
    int y = int(random(height));
    img[i-1] = loadImage(yourPath + "\\" + someFolderList[n]);  // Load the image into the program


    // Check to see if image would be off the screen in x direction
    //  If so, move left to edge of screen

    if (x + img[i-1].width/xfactor > width) {
      int xOverlap = x + img[i-1].width/xfactor - width;
      x = x - xOverlap;
    }

    //  Check to see if image would be off the screen in y direction
    //  If so, move up to the endge of the screen

    if (y + img[i-1].height/yfactor > height) {
      int yOverlap = y + img[i-1].height/yfactor - height;
      y = y - yOverlap;
    }

    // Add the bounding box of each image to the array
    rectangles.add(new Rectangle(x, y, img[i-1].width/xfactor, img[i-1].height/yfactor));

    // Add each image to the array
    imageList.append(yourPath + "\\" + someFolderList[n]);

    // Set overlap indicator to false
    collision[i - 1] = false;
  }


  // Checks to see if images overlap
  for (int i = 0; i < numimages - 2; i++) {

    Rectangle rectangle1 = rectangles.get(i);
    for (int j = i + 1; j < numimages; j++) {
      // could check to see if collision already true here
      Rectangle rectangle2 = rectangles.get(j);
      if (rectangle1.x + rectangle1.width > rectangle2.x &&
        rectangle1.x < rectangle2.x + rectangle2.width &&
        rectangle1.y + rectangle1.height > rectangle2.y &&
        rectangle1.y < rectangle2.y + rectangle2.height) {
        collision[i] = true;
        collision[j] = true;
        break;
      }
    }
  }

  // Increase transparency of images that overlap

  for (int i = 0; i < numimages; i++) {
    if (collision[i]) {
      tint(255, alpha);
    } else {
      noTint();
    }
    Rectangle rectangle = rectangles.get(i);
    image(img[i], rectangle.x, rectangle.y, img[i].width/xfactor, img[i].height/yfactor);
  }
}

void setup() {
  fullScreen();

  // Create IntList from 0 to number of files in directory
  for (int i=0; i < someFolderList.length; i++) {
    files.append(i);
  }
}

void draw() {
  if (!pause) {
    if (millis() - t1 > interval) {
      iteration();
    }
  }
//  saveFrame("output/image####.png");
}
