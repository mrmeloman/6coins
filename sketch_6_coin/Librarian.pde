class Librarian
{
  File table;
  PrintWriter out;

  Librarian(String fileName)
  {
    table = new File(fileName + ".csv");
    try {
      //проверяем, что если файл не существует то создаем его
      if (!table.exists()) {
        table.createNewFile();
      }
      //PrintWriter обеспечит возможности записи в файл
      out = new PrintWriter(table.getAbsoluteFile());
      try {
        //Записываем текст в файл
        out.print("time, coin_id, x, y, state, moves_local, moves_global\n");
      } 
      finally {
        //После чего мы должны закрыть файл
        //Иначе файл не запишется
        out.flush();
      }
    } 
    catch(IOException e) {
      throw new RuntimeException(e);
    }
  }

  void write(String text)
  {
    out.print(text + "\n");
    out.flush();
  }
  
  void close()
  {
    out.close();
  }
}