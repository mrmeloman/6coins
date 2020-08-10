ArrayList<Coin> coins = new ArrayList<Coin>(); //<>// //<>//
float [] x = new float[6];
float [] y = new float[6];
float dnddx, dnddy, xbuf, ybuf, tdist, tracer, alex, p, h, d, kolyan, riddler, vectorX, vectorY, startX, startY;
Integer clickedId = null;
boolean intersect;
int gameState = 0;
String startMessage = "Пробел - сброс. Цель: за наименьшее количество устойчивых ходов построить кольцо, в котором каждая монета касается лишь двух других. Устойчивый ход: ход, в результате которого, передвинутая монета касается ровно двух других.";
String winMessage = "Победа!";
Button startButton;
int movesCounterLocal = 0, movesCounterGlobal = 0;
Librarian lib = new Librarian(hour() + "t" + minute() + " " + day() + "_" + month() + "_" + year());

//Table: TIME, COIN_ID, X, Y, STATE, MOVESLOCAL, MOVESGLOBAL

//TODO:
// 1. Fix moves counting bug (do not count moving for less than d as a move) (triangles?)

void setup()
{
  fullScreen();
  background(255);
  frameRate(60);
  textSize(width/30);
  fill(117, 22, 199);
  text(startMessage, width/20, height/5, width-width/20, height/2);
  startButton = new Button(width/2 - width/7.5, height/2, width/5, height/5, "Поехали!");
  startX = 0;
  startY = 0;
}

void draw()
{


  if (gameState == 1)
  {
    background(255);
    for (int i = 0; i < x.length; i++)
    {
      coins.get(i).place(x[i], y[i]);
    }
    fill(117, 22, 199);
    text("Ходов сделано: " + movesCounterLocal, width-width/3.3, height/100, width-width/20, height/2);
    //text("Ходов всего: " + movesCounterGlobal, width/20, height/100, width/3.3, height/2);
  }
  if (gameState == 2)
  {
    background(255);
    for (int i = 0; i < x.length; i++)
    {
      coins.get(i).place(x[i], y[i]);
    }
    fill(117, 22, 199);
    if (winState() == 1)
    {
      text(winMessage + " Правильно! Решение кольцом", width/3, height/5, width-width/20, height/2);
    } else
    {
      text(winMessage + " Правильно! Решение группами", width/3, height/5, width-width/20, height/2);
    }
  }
}

void mousePressed()
{
  if (gameState == 0)
  {
    if (startButton.getX() <= mouseX && startButton.getX() + startButton.getWidth() >= mouseX && startButton.getY() <= mouseY && startButton.getY() + startButton.getHeight() >= mouseY)
    {
      gameState = 1;
      String infoBuffer = millis() + "," + 0 + "," + 0 + "," + 0 + "," + "STARTBUTTON" + "," + movesCounterLocal + "," + movesCounterGlobal;
      lib.write(infoBuffer);
      gameStart();
    }
  } else if (gameState == 1)
  {
    for (int i = 0; i < x.length; i++)
    {
      if (coins.get(i).isClicked())
      {
        clickedId = i;
        dnddx = coins.get(i).getXDif();
        dnddy = coins.get(i).getYDif();
        xbuf = coins.get(clickedId).getX();
        ybuf = coins.get(clickedId).getY();
        if (collisionsIndexList(coins.get(clickedId)).size() >= 2)
        {
          startX = xbuf;
          startY = ybuf;
        }
        String infoBuffer = millis() + "," + i + "," + x[i] + "," + y[i] + "," + "CLICK" + "," + movesCounterLocal + "," + movesCounterGlobal;
        lib.write(infoBuffer);
      }
    }
  }
}

void mouseReleased()
{
  if (gameState == 1)
  {
    if (clickedId != null)
    {
      if (collisionsIndexList(coins.get(clickedId)).size() != 2)
      {
        x[clickedId] = startX;
        y[clickedId] = startY;
      }
      if (x[clickedId] != startX || y[clickedId] != startY)
      {
        movesCounterLocal++;
        movesCounterGlobal++;
      }
      String infoBuffer = millis() + "," + clickedId + "," + x[clickedId] + "," + y[clickedId] + "," + "RELEASE" + "," + movesCounterLocal + "," + movesCounterGlobal;
      lib.write(infoBuffer);
    }
    clickedId = null;
    dnddx = 0;
    dnddy = 0;
    if (winCondition())
    {
      gameWon();
    }
  }
}

void mouseDragged()
{  
  if (gameState == 1)
  {
    if (clickedId != null)
    { 
      intersect = false;
      xbuf = x[clickedId];
      ybuf = y[clickedId];

      toshik();

      if (intersect == true)
      {
        x[clickedId] = xbuf + riddler*vectorX; //YEAH
        y[clickedId] = ybuf + riddler*vectorY; //FIRST-CLASS TOSHIK MAGIC
      } else
      {
        x[clickedId] = mouseX + dnddx;
        y[clickedId] = mouseY + dnddy;
      }
      borderCollision();
      xbuf = x[clickedId];
      ybuf = y[clickedId];

      String infoBuffer = millis() + "," + clickedId + "," + x[clickedId] + "," + y[clickedId] + "," + "DRAG" + "," + movesCounterLocal + "," + movesCounterGlobal;
      lib.write(infoBuffer);
    }
  }
}

void keyPressed()
{
  if (key == 'q' || key == 'й')
  {
    exit();
  }
  if (keyCode == 32)
  {
    String infoBuffer = millis() + "," + 0 + "," + 0 + "," + 0 + "," + "RESET" + "," + movesCounterLocal + "," + movesCounterGlobal;
    lib.write(infoBuffer);
    gameState = 1;
    movesCounterLocal = 0;
    gameStart();
  }
}

void borderCollision()
{
  //-----------------Borders collision:---------------------
  if (x[clickedId] < 0 + d/2)
  {
    x[clickedId] = 0 + d/2;
  }
  //Right:
  if (x[clickedId] > width - d/2)
  {
    x[clickedId] = width - d/2;
  }
  //Upper
  if (y[clickedId] < 0 + d/2)
  {
    y[clickedId] = 0 + d/2;
  }

  //Lower:
  if (y[clickedId] > height - d/2)
  {
    y[clickedId] = height - d/2;
  }
}

boolean winCondition()
{
  boolean win = true;
  int[] colCount = new int[x.length];
  for (int i = 0; i < colCount.length; i++)
  {
    colCount[i] = 0;
  }
  for (int i = 0; i < x.length; i++)
  {
    for (int j = 0; j < x.length; j++)
    {
      if (i != j)
      {
        if (coins.get(i).hasCollisionWith(coins.get(j)))
        {
          colCount[i]++;
        }
      }
    }
  }

  for (int i = 0; i < x.length; i++)
  {
    if (movesCounterLocal < 4)
    {
      if (colCount[i] != 2)
      {
        win = false;
      }
    } else
    {
      win = false;
    }
  }
  return win;
}

void gameStart()
{
  String infoBuffer = millis() + "," + 0 + "," + 0 + "," + 0 + "," + "GAMESTART" + "," + movesCounterLocal + "," + movesCounterGlobal;
  lib.write(infoBuffer);
  d = width/13;
  for (int i = 0; i < x.length; i++)
  {
    coins.add(new Coin(d));
  }
  for (int i = 0; i < x.length; i++)
  {
    coins.get(i).setColor(255, 255, 255);
  }
  for (int i = 0; i < x.length/2; i++)
  {
    x[i] = width/2.5 + i*d + 1;
    y[i] = height/2.2;
  }
  for (int i = x.length/2; i < x.length; i++)
  {
    x[i] = x[i-3] - d/2 + 1;
    y[i] = y[i-3] + sqrt((d*d - (x[i-3] - x[i])*(x[i-3] - x[i]))) + 1;
  }
}

void gameWon()
{
  String infoBuffer = millis() + "," + 0 + "," + 0 + "," + 0 + "," + "WIN " + winState() + "," + movesCounterLocal + "," + movesCounterGlobal;
  lib.write(infoBuffer);
  for (int i = 0; i < x.length; i++)
  {
    coins.get(i).setColor(72, 240, 139);
  }
  gameState = 2;
}

ArrayList<Integer> collisionsIndexList (Coin coin)
{
  ArrayList<Integer> collisions = new ArrayList<Integer>();
  for (int i = 0; i < x.length; i++)
  {
    if (i != clickedId)
    {
      if (coin.hasCollisionWith(coins.get(i)))
      {
        collisions.add(i);
      }
    }
  }
  return collisions;
}

int winState()
{
  final int RING = 1;
  final int OTHER = 2;
  Integer left;
  Integer right;
  boolean ringSolution = true;
  for (int i = 0; i < x.length; i++)
  {
    clickedId = i;
    if (collisionsIndexList(coins.get(i)).size() == 2)
    {
      left = collisionsIndexList(coins.get(i)).get(0);
      right = collisionsIndexList(coins.get(i)).get(1);
      if (coins.get(left).hasCollisionWith(coins.get(right)))
      {
        ringSolution = false;
        clickedId = null;
        break;
      }
    } else
    {
      println("Error: winState has collisionsIndexList other than 2");
    }
  }
  if (ringSolution)
  {
    return RING;
  } else
  {
    return OTHER;
  }
}

void toshik()
{
  if (clickedId != null)
  {
    for (int i = 0; i < x.length; i++)
    {
      if (i != clickedId)
      {
        if (dist(mouseX + dnddx, mouseY + dnddy, x[i], y[i]) < d)
        {
          intersect = true;
          //stoi, Torvald
          //pomogi mne sdvinut's etot vector
          //mi nashli znachenie ugla pervih pravitelei Enii
          tdist = dist(xbuf, ybuf, x[i], y[i]); 
          tracer = dist(xbuf, ybuf, mouseX + dnddx, mouseY + dnddy); //TVOE PRIZVANIE SKALYAAAAAAR
          alex = dist(x[i], y[i], mouseX + dnddx, mouseY + dnddy); //have you heard about govnokod, you, shenok?
          p = (tdist + tracer + alex)/2;
          h = 2*sqrt(p*(p-tracer)*(p-tdist)*(p-alex))/tracer; //I will tell you about govnokod, son
          kolyan = (tracer*tracer + alex*alex - tdist*tdist)/(2*tracer*alex); //cos of angle between alex and tracer

          if (kolyan >= 0)
          {
            riddler = tracer - sqrt(d*d - h*h) - sqrt(alex*alex - h*h); //THAT'S A GODDAMN RIDDLE, SON
          } else
          {
            riddler = tracer - sqrt(d*d - h*h) + sqrt(alex*alex - h*h);
          }
          vectorX = (mouseX + dnddx - xbuf)/tracer; 
          vectorY = (mouseY + dnddy - ybuf)/tracer;
        }
      }
    }
  }
}
