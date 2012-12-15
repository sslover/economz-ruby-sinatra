// economz - your carbon foodprint
// by Sam Slover in the fall of 2012
// for NYU's Interactive Telecommunications Program
// icons designed using open source images from The Noun Project and ITP colleague Maria Paul Saba
// code ideas and suggestions contributed by Processing wizard Dan Shiffman (all mistakes are my own)

/* @pjs preload="clear-plate-deactive.png,go-button-deactive.png, clear-plate-active.png, go-button-active.png, message.png,  bottom-panel.jpg,
 20-a.png, 20-d.png, 20.png, 18.png, 14.png, 15.png, 13.png, 4.png, 21.png, 11.png, 7.png, plate-reset.jpg, 1-g.png, 1-b.png, 22-a.png, 22-d.png,
 18-a.png, 18-d.png, 17-a.png, 17-d.png, 15-a.png, 15-d.png,11-a.png,11-d.png,10-a.png,10-d.png, 9-a.png, 9-d.png, 8-a.png, 8-d.png, 7-a.png, 7-d.png, 
 6-a.png, 6-d.png, 4-a.png, 4-d.png, bg-reset.jpg, 3-b.png, 3-g.png, 4-g.png, 4-b.png, 2-b.png, 2-g.png, 0-g.png, 0-b.png, show.png, create-a-meal.png, 3.png,
 go-button.png, 19.png, 2.png, car.png, 0-a.png, 1-a.png, 2-a.png, 21-a.png, 13-a.png, 3-a.png, 14-a.png, 16-a.png, 5-a.png, 19-a.png, 12-a.png, 12-d.png,
 5-d.png, 19-d.png, 14-d.png, 16-d.png, 13-d.png, 3-d.png, 0-d.png, 1-d.png, 2-d.png, 21-d.png, 12.png, 9.png, 10.png, 5.png, 17.png, 16.png, 22.png, 8.png, 1.png,
 0.png, 6.png, economz-bg.jpg";*/

int numItems = 23;
Food food[] = new Food[numItems];

// menu objects
Menu menu[] = new Menu[5];

// button objects
Button goButtonA;
Button goButtonD;
Button clearButtonD;
Button clearButtonA;
Button clearButtonDone;
boolean animate = false;

// car object
Car car;
int carTracker = 0; //tracks how many times a car has cycled through each animation

// fumes
//ParticleSystem ps;
//Random generator;

// main images
PImage bg;
PImage createMeal;
PImage show;
PImage bgReset;
PImage plateReset;
PImage bottom;
PImage message;

// fonts
PFont tradeGothic;
boolean textDisplay = false;

// to keep track of the plate items
int plateItemCounter = 0;

// to keep track of the total "carbon miles" travelled for all food on plate
float totalMilesTracker = 0;
int yearlyMilesRounded = 0;

// arrays for data
// the entire spreadsheet
String [] cells;
// split it in this array
String [] splits;
// just the carmiles
Float [] carMiles;

int foodCategory = 1;

// icon variables
int menuX = 797;
int menuY = 70;
int counterX0 = 0;
int counterY0 = 0;
int counterX1 = 0;
int counterY1 = 0;
int counterX2 = 0;
int counterY2 = 0;
int counterX3 = 0;
int counterY3 = 0;
int counterX4 = 0;
int counterY4 = 0;
int iconXset = 755;
int iconYset = 113;
int iconX = iconXset;
int iconY = iconYset;
int iconX0 = iconXset;
int iconY0 = iconYset;
int iconX1 = iconXset;
int iconY1 = iconYset;
int iconX2 = iconXset;
int iconY2 = iconYset;
int iconX3 = iconXset;
int iconY3 = iconYset;
int iconX4 = iconXset;
int iconY4 = iconYset;

public void setup() {
  size (980, 653);
  // font
  tradeGothic = loadFont("TradeGothicLT-Bold-48.vlw");
  // load panel images
  bg = loadImage("economz-bg.jpg"); 
  bgReset = loadImage("bg-reset.jpg");
  createMeal = loadImage("create-a-meal.png"); 
  show = loadImage("show.png");
  plateReset = loadImage("plate-reset.jpg");
  bottom = loadImage("bottom-panel.jpg");
  message = loadImage("message.png");
  PImage gobuttonDImg = loadImage("go-button-deactive.png");
  PImage gobuttonAImg = loadImage("go-button-active.png");
  goButtonD = new Button (gobuttonDImg, false, iconXset+12, 470);
  goButtonA = new Button (gobuttonAImg, false, iconXset+12, 470);
  PImage clearbuttonImgA = loadImage("clear-plate-active.png");
  PImage clearbuttonImgD = loadImage("clear-plate-deactive.png");
  clearButtonA = new Button (clearbuttonImgA, false, 524, 482);
  clearButtonD = new Button (clearbuttonImgD, false, 524, 482); 
  clearButtonDone = new Button (clearbuttonImgA, false, width-135, height-57);
  // load fume system
  //  generator = new Random();
  //  PImage img = loadImage("texture.png");
  //  ps = new ParticleSystem(0,new PVector(width/2,height-60),img);
  // load and bring in the car object
  PImage carImage = loadImage("car.png");
  car = new Car (carImage, 50, height-85, 0, 0);
  // load images for the menu items
  PImage[] menuA = new PImage [5];
  PImage[] menuD = new PImage [5]; 
  for (int i = 0; i < menuA.length; i++) {
    menuA[i] = loadImage(i + "-g.png");
    menuD[i] = loadImage(i + "-b.png");
  } 
  // load images for the food items
  PImage[] mainImages = new PImage[numItems];
  for (int i = 0; i < mainImages.length; i++) {
    mainImages[i] = loadImage(i + ".png");
  }
  PImage[] iconA = new PImage[numItems];
  for (int i = 0; i < iconA.length; i++) {
    iconA[i] = loadImage(i + "-a.png");
  }
  PImage[] iconD = new PImage[numItems];
  for (int i = 0; i < iconD.length; i++) {
    iconD[i] = loadImage(i + "-d.png");
  }
  //load data
  cells = loadStrings("economz.csv");
  carMiles = new Float[cells.length];
  for (int i = 0; i < cells.length; i++) {
    splits = cells[i].split(",");
    carMiles[i] = float(splits[5]);
  }
  //bring in the menu objects!
  for (int i = 0; i < menu.length; i++) {
    menu[i] = new Menu(menuA[i], menuD[i], false, menuX, menuY);
    // set location attributes
    menuX = menuX + 43;
    if (menuX+80 >width) {
      menuX = 797;
      menuY = 88;
    }
  }
  // bring in the food objects!
  for (int i = 0; i < food.length; i++) {
    food[i] = new Food(mainImages[i], iconD[i], iconA[i], false, carMiles[i], 0, width/2, height/2, iconX, iconY, 0); 
    //set categories and location attributes
    if (i >= 0 && i < 5) {
      food[i].setCategory(1); 
      iconX0 = iconX0 + 105;
      counterX0++;
      counterY0++;
      if (counterY0 == 2) {
        iconX0 = width-225;
        iconY0 = iconY0 + 90;
        counterY0 = 0;
      }
      iconX = iconX0;
      iconY = iconY0; 
      if (i == 4) {
        iconX = iconXset;
        iconY = iconYset;
      }
    }
    if (i >= 5 && i < 13) {
      food[i].setCategory(2);
      iconX1 = iconX1 + 105;
      counterX1++;
      counterY1++;
      if (counterY1 == 2) {
        iconX1 = width-225;
        iconY1 = iconY1 + 90;
        counterY1 = 0;
      }
      iconX = iconX1;
      iconY = iconY1; 
      if (i == 12) {
        iconX = iconXset;
        iconY = iconYset;
      }
    }
    if (i >= 13 && i < 17) {
      food[i].setCategory(3);
      iconX2 = iconX2 + 105;
      counterX2++;
      counterY2++;
      if (counterY2 == 2) {
        iconX2 = width-225;
        iconY2 = iconY2 + 90;
        counterY2 = 0;
      }
      iconX = iconX2;
      iconY = iconY2; 
      if (i == 16) {
        iconX = iconXset;
        iconY = iconYset;
      }
    }
    if (i >= 17 && i < 21) {
      food[i].setCategory(4);
      iconX3 = iconX3 + 105;
      counterX3++;
      counterY3++;
      if (counterY3 == 2) {
        iconX3 = width-225;
        iconY3 = iconY3 + 90;
        counterY3 = 0;
      }
      iconX = iconX3;
      iconY = iconY3; 
      if (i == 20) {
        iconX = iconXset;
        iconY = iconYset;
      }
    }
    if (i >= 21 && i < 23) {
      food[i].setCategory(5);
      iconX4 = iconX4 + 105;
      counterX4++;
      counterY4++;
      if (counterY4 == 2) {
        iconX4 = width-225;
        iconY4 = iconY1 + 90;
        counterY4 = 0;
      }
      iconX = iconX4;
      iconY = iconY4;
    }
  }
}
public void draw() {
  // load and show initial panel images
  background(bg);
  image(createMeal, 755, 20);
  image(show, 756, 70);
  //image(plateReset, 0, 0);
  for (int i = 0; i < food.length; i++) {
    food[i].foodDisplay();
  }
  // highlight the menu item if it is chosen
  for (int i = 0; i < menu.length; i++) {
    menu[i].display();
  }
  // lower part of the program display goes here
  car.display();
  goButtonD.display();
  clearButtonD.display();
  if (plateItemCounter >= 1) {
    image(message, 600, height-110);
    goButtonA.display();
    clearButtonA.display();
  }
  yearlyMilesRounded = round(365*totalMilesTracker);
  if (animate == true) {
    image(bottom, 0, height-110);
    goButtonD.display();
    car.display();
    //    float dx = -0.2;
    //    PVector wind = new PVector(dx, 0);
    //    ps.applyForce(wind);
    //    ps.run();
    //    for (int i = 0; i < 4; i++) {
    //      ps.addParticle();
    //    }
  }
  if (textDisplay == true) {
    fill(29, 91, 46);
    textFont(tradeGothic, 28);
    text("If you ate this every day for a year", width-470, height-65);
    fill(64, 64, 65);
    text("it's like driving", width-470, height-35);
    fill(211, 33, 50);
    text(yearlyMilesRounded + " miles", width-291, height-35);
  }
  // show the associated food icons for each food category when that menu item is selected
  if (foodCategory == 1) {
    menu[0].setSelected();
    menu[0].display();
    //image(bgReset, iconXset, iconYset);
    for (int i = 0; i < 5; i++) {
      food[i].iconDisplay();
    }
  }
  if (foodCategory == 2) {
    //image(bgReset, iconXset, iconYset);    
    for (int i = 5; i < 13; i++) {
      food[i].iconDisplay();
    }
  }
  if (foodCategory == 3) {
    //image(bgReset, iconXset, iconYset);
    for (int i = 13; i < 17; i++) {
      food[i].iconDisplay();
    }
  }
  if (foodCategory == 4) {
    //image(bgReset, iconXset, iconYset);
    for (int i = 17; i < 21; i++) {
      food[i].iconDisplay();
    }
  }
  if (foodCategory == 5) {
    //image(bgReset, iconXset, iconYset);
    for (int i = 21; i < 23; i++) {
      food[i].iconDisplay();
    }
  }
}

public void mousePressed() {
  // on mouse click, figure out which menu is selected, with only 1 being selected at one time
  if (menu[0].isMenuSelected() == true) {
    foodCategory = 1;
    menu[0].setSelected();
    menu[1].setDeselected();
    menu[2].setDeselected();
    menu[3].setDeselected();
    menu[4].setDeselected();
  }
  else if (menu[1].isMenuSelected() == true) {
    foodCategory = 2;
    menu[0].setDeselected();
    menu[1].setSelected();
    menu[2].setDeselected();
    menu[3].setDeselected();
    menu[4].setDeselected();
  }
  else if (menu[2].isMenuSelected() == true) {
    foodCategory = 3;
    menu[0].setDeselected();
    menu[1].setDeselected();
    menu[2].setSelected();
    menu[3].setDeselected();
    menu[4].setDeselected();
  }
  else if (menu[3].isMenuSelected() == true) {
    foodCategory = 4;    
    menu[0].setDeselected();
    menu[1].setDeselected();
    menu[2].setDeselected();
    menu[3].setSelected();
    menu[4].setDeselected();
  }
  else if (menu[4].isMenuSelected() == true) {
    foodCategory = 5;
    menu[0].setDeselected();
    menu[1].setDeselected();
    menu[2].setDeselected();
    menu[3].setDeselected();
    menu[4].setSelected();
  }
  // on mouse click, determine if a food item has been selected
  if (foodCategory == 1) {
    for (int i = 0; i < 5; i++) {
      food[i].isFoodSelected();
    }
  }
  if (foodCategory == 2) {
    for (int i = 5; i < 13; i++) {
      food[i].isFoodSelected();
    }
  }
  if (foodCategory == 3) {
    for (int i = 13; i < 17; i++) {
      food[i].isFoodSelected();
    }
  }
  if (foodCategory == 4) {
    for (int i = 17; i < 21; i++) {
      food[i].isFoodSelected();
    }
  }
  if (foodCategory == 5) {
    for (int i = 21; i < 23; i++) {
      food[i].isFoodSelected();
    }
  }
  // if they click to clear the plate, reset all the values
  if (goButtonA.goClick() == true && plateItemCounter >=1) {
    animate = true;
  }
  // if the plate is cleared via the clear button OR via removing all items, reset everything
  if (clearButtonA.clearPlate() == true || plateItemCounter == 0 || clearButtonDone.clearPlate()) {
    plateItemCounter = 0;
    totalMilesTracker = 0;
    carTracker = 0;
    goButtonA.isClicked = false;
    textDisplay = false;
    for (int i = 0; i < food.length; i++) {
      food[i].isSelected = false;
      food[i].plateOrder = 0;
    }
    // reset bottom attributes too
    animate = false;
    car.carX =  50; 
    car.carY = height-85;
  }
  saveToApp();
}

public void textDisplay() {
  fill(29, 91, 46);
  textFont(tradeGothic, 84);
  text("If you ate this everyday for a year", width-200, height-85);
}

class Button {
  PImage button;
  boolean isClicked = false;
  int buttonX;
  int buttonY;

  Button (PImage _button, boolean _isClicked, int _buttonX, int _buttonY) {
    button = _button;
    isClicked = _isClicked;
    buttonX = _buttonX;
    buttonY = _buttonY;
  }
  public void display() {
    image(button, buttonX, buttonY);
  }
  boolean clearPlate() {
    if (mouseX>(buttonX-2) && mouseX<(buttonX + 103) && mouseY>(buttonY-2) && mouseY<(buttonY+26)) {
      return true;
    }
    else {
      return false;
    }
  }
  boolean goClick() {
    if (mouseX>(buttonX-2) && mouseX<(buttonX + 177) && mouseY>(buttonY-2) && mouseY<(buttonY+49)) {
      return true;
    }
    else {
      return false;
    }
  }
}
class Car {
  PImage car;
  float carX;
  float carY;
  float moveX;
  float moveY;

  Car (PImage _car, float _carX, float _carY, float _moveX, float _moveY) {
    car = _car;
    carX = _carX;
    carY = _carY;
    moveX = _moveX;
    moveY = _moveY;
  }
  public void display() {
    if (animate == false) {
      moveX = 0;
    }
    // how fast should the car go? and where does it stop?
    if (animate == true && yearlyMilesRounded > 0 && yearlyMilesRounded <= 1000) {
      moveX = 1.2;
      moveY = random(-0.15, 0.15); 
      carX = carX + moveX;
      carY = carY + moveY;
      if (carX > 300 && carX < 302) {
        moveX = 0;
        moveY = 0;
        carX = 300;
        carY = height-85;
        textDisplay = true;
        clearButtonDone.display();
      }
    }
    else if (animate == true && yearlyMilesRounded > 1000 && yearlyMilesRounded <= 2000) {
      if (carTracker == 0) {
        moveX = 1.8;
      }
      moveY = random(-0.15, 0.15); 
      carX = carX + moveX;
      carY = carY + moveY;
      if (carX >= width) {
        carX = 0;
        moveX = moveX + 0.2;
        carTracker++;
        carX = 0;
      }
      if (carTracker == 1) {
        if (carX >= 300) {
          moveX = 0;
          moveY = 0;
          carX = 300;
          carY = height-85;
          textDisplay = true;
          clearButtonDone.display();
        }
      }
    }
    else if (animate == true && yearlyMilesRounded > 2000 && yearlyMilesRounded <= 3000) {
      if (carTracker == 0) {
        moveX = 2.2;
      }
      moveY = random(-0.15, 0.15); 
      carX = carX + moveX;
      carY = carY + moveY;
      if (carX >= width) {
        carX = 0;
        moveX = moveX + 0.2;
        carTracker++;
        carX = 0;
      }
      if (carTracker == 2) {
        if (carX >= 300) {
          moveX = 0;
          moveY = 0;
          carX = 300;
          carY = height-85;
          textDisplay = true;
          clearButtonDone.display();
        }
      }
    }
    else if (animate == true && yearlyMilesRounded > 3000 && yearlyMilesRounded <= 4000) {
      if (carTracker == 0) {
        moveX = 2.6;
      }
      moveY = random(-0.15, 0.15); 
      carX = carX + moveX;
      carY = carY + moveY;
      if (carX >= width) {
        carX = 0;
        moveX = moveX + 0.2;
        carTracker++;
        carX = 0;
      }
      if (carTracker == 3) {
        if (carX >= 300) {
          moveX = 0;
          moveY = 0;
          carX = 300;
          carY = height-85;
          textDisplay = true;
          clearButtonDone.display();
        }
      }
    }
    else if (animate == true && yearlyMilesRounded > 4000 && yearlyMilesRounded <= 10000) {
      if (carTracker == 0) {
        moveX = 3.0;
      }
      moveY = random(-0.15, 0.15); 
      carX = carX + moveX;
      carY = carY + moveY;
      if (carX >= width) {
        carX = 0;
        moveX = moveX + 0.2;
        carTracker++;
        carX = 0;
      }
      if (carTracker == 3) {
        if (carX >= 300) {
          moveX = 0;
          moveY = 0;
          carX = 300;
          carY = height-85;
          textDisplay = true;
          clearButtonDone.display();
        }
      }
    }
    else if (animate == true && yearlyMilesRounded > 10000 && yearlyMilesRounded <= 20000) {
      if (carTracker == 0) {
        moveX = 3.4;
      }
      moveY = random(-0.15, 0.15); 
      carX = carX + moveX;
      carY = carY + moveY;
      if (carX >= width) {
        carX = 0;
        moveX = moveX + 0.2;
        carTracker++;
        carX = 0;
      }
      if (carTracker == 4) {
        if (carX >= 300) {
          moveX = 0;
          moveY = 0;
          carX = 300;
          carY = height-85;
          textDisplay = true;
          clearButtonDone.display();
        }
      }
    }
    image(car, carX, carY);
  }
}

class Food {
  PImage main;
  PImage iconD;
  PImage iconA;
  boolean isSelected;
  float carbonFootprint;
  int category;
  int mainX;
  int mainY;
  int iconX;
  int iconY;
  int plateOrder;

  Food (PImage tempMain, PImage tempIconD, PImage tempIconA, boolean tempIsSelected, float tempCarbonFootprint, int tempCategory, int tempMainX, int tempMainY, int tempIconX, int tempIconY, int tempPlateOrder) {
    main = tempMain; 
    iconD = tempIconD; 
    iconA = tempIconA; 
    isSelected = tempIsSelected;
    carbonFootprint = tempCarbonFootprint; 
    category = tempCategory;
    mainX = tempMainX;
    mainY = tempMainY;
    iconX = tempIconX;
    iconY = tempIconY;
    plateOrder = tempPlateOrder;
  }
  // what category is the food item in
  int setCategory(int options) {
    if (options == 1) {
      category = 1; //veggie
    }
    else if (options == 2) {
      category = 2; //meat
    }
    else if (options == 3) {
      category = 3; //dairy
    } 
    else if (options == 4) {
      category = 4; //starch
    }
    else if (options == 5) {
      category = 5; //other
    }   
    return category;
  }
  public void iconDisplay() {
    // if an icon is selected, show active version; otherwise show deactive
    if (isSelected == true) {
      image(iconA, iconX, iconY);
    }
    if (isSelected == false) {
      image(iconD, iconX, iconY);
    }
  }
  public void foodDisplay() {    
    // if an item has been selected, then show it on the plate
    // if the item is deselected, then hide it 
    if (isSelected == true) {
      image(main, mainX, mainY);
    }
  }
  public void plateOrderFunction() {
    // immediately give it the food a plate location
    if (plateOrder == 1) {
      mainX = 190;
      mainY = 70;
    } 
    else if (plateOrder == 2) {
      mainX = 385;
      mainY = 260;
    } 
    else if (plateOrder == 3) {
      mainX = 165;
      mainY = 215;
    } 
    else if (plateOrder == 4) {
      mainX = 400;
      mainY = 70;
    }
    else if (plateOrder == 5) {
      mainX = 187;
      mainY = 340;
    }
    else if (plateOrder == 6) {
      mainX = 380;
      mainY = 170;
    }
    else if (plateOrder == 7) {
      mainX = 345;
      mainY = 345;
    }
    else if (plateOrder == 8) {
      mainX = 275;
      mainY = 15;
    }
    else if (plateOrder == 9) {
      mainX = 197 + int(random(-15, 15));
      mainY = 70 + int(random(-15, 15));
    } 
    else if (plateOrder == 10) {
      mainX = 385 + int(random(-15, 15));
      mainY = 260 + int(random(-15, 15));
    } 
    else if (plateOrder == 11) {
      mainX = 185 + int(random(-15, 15));
      mainY = 215 + int(random(-15, 15));
    } 
    else if (plateOrder == 12) {
      mainX = 400 + int(random(-15, 15));
      mainY = 70 + int(random(-15, 15));
    }
    else if (plateOrder == 13) {
      mainX = 197 + int(random(-15, 15));
      mainY = 340 + int(random(-15, 15));
    }
    else if (plateOrder == 14) {
      mainX = 380 + int(random(-15, 15));
      mainY = 170 + int(random(-15, 15));
    }
    else if (plateOrder == 15) {
      mainX = 345 + int(random(-15, 15));
      mainY = 345 + int(random(-15, 15));
    }
    else if (plateOrder == 16) {
      mainX = 275 + int(random(-15, 15));
      mainY = 15 + int(random(-15, 15));
    }
    else if (plateOrder == 17) {
      mainX = 197 + int(random(-15, 15));
      mainY = 70 + int(random(-15, 15));
    } 
    else if (plateOrder == 18) {
      mainX = 385 + int(random(-15, 15));
      mainY = 260 + int(random(-15, 15));
    } 
    else if (plateOrder == 19) {
      mainX = 185 + int(random(-15, 15));
      mainY = 215 + int(random(-15, 15));
    } 
    else if (plateOrder == 20) {
      mainX = 400 + int(random(-15, 15));
      mainY = 70 + int(random(-15, 15));
    }
    else if (plateOrder == 21) {
      mainX = 197 + int(random(-15, 15));
      mainY = 340 + int(random(-15, 15));
    }
    else if (plateOrder == 22) {
      mainX = 380 + int(random(-15, 15));
      mainY = 170 + int(random(-15, 15));
    }
    else if (plateOrder == 23) {
      mainX = 345 + int(random(-15, 15));
      mainY = 345 + int(random(-15, 15));
    }
  }

  public void isFoodSelected() {
    if (mouseX>(iconX-2) && mouseX<(iconX + 97) && mouseY>(iconY-2) && mouseY<(iconY+77)) {
      isSelected =! isSelected;
      // keep track of how many items are currently on plate with plateItemCounter
      // keep track of global "food miles" for the plate with totalMilesTracker
      if (isSelected == true) {
        plateItemCounter++;
        totalMilesTracker = totalMilesTracker + carbonFootprint;
        plateOrder = plateItemCounter;
        // re-oder plate give new order
        plateOrderFunction();
      }
      if (isSelected == false) {
        plateItemCounter--;
        totalMilesTracker = totalMilesTracker - carbonFootprint;
        // check what item is getting removed so we can reorder properly
        int removedItem = plateOrder;
        // reset this item to 0 
        plateOrder = 0;
        // algorithm to re-order the entire plate. everything slides down by 1, if it's above the value of the removedItem.
        for (int i = 0; i < food.length; i++) {
          if (food[i].isSelected == true) {
            if (food[i].plateOrder > 1 && food[i].plateOrder > removedItem) {
              food[i].plateOrder = food[i].plateOrder - 1;
              food[i].plateOrderFunction();
            }
          }
        }
        // reset the plate!
        //image(plateReset, 0, 0);
        // re-oder plate given new order
        plateOrderFunction();
      }
    }
  }
}   

//
//// A simple Particle class, renders the particle as an image
//
//class Particle {
//  PVector loc;
//  PVector vel;
//  PVector acc;
//  float lifespan;
//  PImage img;
//
//  Particle(PVector l,PImage img_) {
//    acc = new PVector(0,0);
//    float vx = (float) generator.nextGaussian()*0.3;
//    float vy = (float) generator.nextGaussian()*0.3 - 1.0;
//    vel = new PVector(vx,vy);
//    loc = l.get();
//    lifespan = 150.0;
//    img = img_;
//  }
//
//  public void run() {
//    update();
//    render();
//  }
//  
//  // Method to apply a force vector to the Particle object
//  // Note we are ignoring "mass" here
//  public void applyForce(PVector f) {
//    acc.add(f);
//  }  
//
//  // Method to update location
//  public void update() {
//    vel.add(acc);
//    loc.add(vel);
//    acc.mult(0); // clear Acceleration
//    lifespan -= 2.5;
//  }
//
//  // Method to display
//  public void render() {
//    imageMode(CENTER);
//    tint(255,lifespan);
//    image(img,loc.x,loc.y);
//  }
//
//  // Is the particle still useful?
//  boolean dead() {
//    if (lifespan <= 0.0) {
//      return true;
//    } else {
//      return false;
//    }
//  }
//}
//


class Menu {
  PImage active;
  PImage deactive;
  boolean menuSelected;
  int menuX;
  int menuY;

  Menu(PImage _active, PImage _deactive, boolean _menuSelected, int _menuX, int _menuY) {
    active = _active;
    deactive = _deactive;
    menuSelected = _menuSelected;
    menuX = _menuX;
    menuY = _menuY;
  }
  // if the menu has been selected, show active icon; otherwise, show deactive icon
  public void display() {
    if (menuSelected == true) {
      image(active, menuX, menuY);
    }
    if (menuSelected == false) {
      image(deactive, menuX, menuY);
    }
  }
  // if the mouse is over a menu item, and the mouse is clicked, set that menu into active mode
  boolean isMenuSelected() {
    if (mouseX>(menuX-2) && mouseX<(menuX + 40) && mouseY>(menuY-2) && mouseY<(menuY+18)) {
      return true;
    }
    else {
      return false;
    }
  }
  public void setSelected() {
    menuSelected = true;
  }
  public void setDeselected() {
    menuSelected = false;
  }
}

public void saveToApp() {
  //saveFrame("mymeal.jpg");
  var canvas = document.getElementById("economz");
  var img = canvas.toDataURL("image/png");
  
  document.write('<form action="http://itp.nyu.edu/~sjs663/sinatra/economz/save_image" method="POST" enctype="multipart/form-data"><input type="file" name="file" value="'+img+'"/> <input type="submit" value="Upload image"></form>');

  /*
  var img = canvas.toDataURL("image/png").split(',')[1];
  var data = new FormData();
  data.append('filename', "test.png");
  data.append('file', img);
 // var xhr = new XMLHttpRequest();
  //xhr.open('POST', 'http://itp.nyu.edu/~sjs663/sinatra/economz/save_image');
  //xhr.send(data);
   $.ajax({
        type: 'POST',
        url: 'http://itp.nyu.edu/~sjs663/sinatra/economz/save_image',
        data: data,
        success: function (msg) {
            
        }
    });
  
  /*
  var data = new FormData();
  data.append('file', img);
 
    $.ajax({
        type: 'POST',
        url: 'http://itp.nyu.edu/~sjs663/sinatra/economz/save_image',
        data: data,
        success: function (msg) {
            
        }
    });
  
  */
  
  //document.write('<img src="'+img+'"/>');
}

//// A class to describe a group of Particles
//// An ArrayList is used to manage the list of Particles 
//
//class ParticleSystem {
//
//  ArrayList<Particle> particles;    // An arraylist for all the particles
//  PVector origin;        // An origin point for where particles are birthed
//  PImage img;
//  
//  ParticleSystem(int num, PVector v, PImage img_) {
//    particles = new ArrayList<Particle>();              // Initialize the arraylist
//    origin = v.get();                        // Store the origin point
//    img = img_;
//    for (int i = 0; i < num; i++) {
//      particles.add(new Particle(origin, img));    // Add "num" amount of particles to the arraylist
//    }
//  }
//
//  public void run() {
//    Iterator<Particle> it = particles.iterator();
//    while (it.hasNext()) {
//      Particle p = it.next();
//      p.run();
//      if (p.dead()) {
//        it.remove();
//      }
//    }
//  }
//  
//  // Method to add a force vector to all particles currently in the system
//  public void applyForce(PVector dir) {
//    // Enhanced loop!!!
//    for (Particle p: particles) {
//      p.applyForce(dir);
//    }
//  
//  }  
//
//  public void addParticle() {
//    particles.add(new Particle(origin,img));
//  }
//
//  public void addParticle(Particle p) {
//    particles.add(p);
//  }
//
//  // A method to test if the particle system still has particles
//  boolean dead() {
//    if (particles.isEmpty()) {
//      return true;
//    } else {
//      return false;
//    }
//  }
//
//}

