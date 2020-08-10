class Button
{
  float x, y, w, h;
  String text;

  Button(float x, float y, float w, float h, String text)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    fill(117, 22, 199);
    this.text = text;
    rect(x, y, w, h);
    fill(255, 255, 0);
    textSize(width/30);
    text(this.text, x+x/15, y+h/2+(width/30)/3);
  }

  float getX()
  {
    return this.x;
  }

  float getY()
  {
    return this.y;
  }

  float getHeight()
  {
    return this.h;
  }

  float getWidth()
  {
    return this.w;
  }
}