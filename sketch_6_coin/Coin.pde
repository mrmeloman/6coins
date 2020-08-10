public class Coin
{
  float x;
  float y;
  float diameter;
  float xdif;
  float ydif;
  float colorR = 250;
  float colorG = 250;
  float colorB = 250;
  PImage img = loadImage("coin.png");


  Coin(float d)
  {
    diameter = d;
  }

  void place(float x, float y)
  {
    this.x = x;
    this.y = y;
    imageMode(CENTER);
    tint(colorR, colorG, colorB);
    image(img, x, y, d, d);
  }

  void setColor(float colorR, float colorG, float colorB)
  {
    this.colorR = colorR;
    this.colorG = colorG;
    this.colorB = colorB;
  }
  
  float getX()
  {
    return x;
  }

  float getY()
  {
    return y;
  }

  boolean isClicked()
  {
    xdif = x - mouseX;
    ydif = y - mouseY;
    float tdif = sqrt(xdif*xdif + ydif*ydif);
    if (tdif <= diameter/2)
    {
      return true;
    } else
    {
      return false;
    }
  }

  float getXDif()
  {
    return xdif;
  }

  float getYDif()
  {
    return ydif;
  }
  boolean hasCollisionWith(Coin coin)
  {
    if (dist(this.x, this.y, coin.getX(), coin.getY()) <= d + 5)
    {
      return true;
    } else
    {
      return false;
    }
  }
}