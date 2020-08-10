# 6coins
This is an app for presenting a 6-coins problem. It saves coin movement at ~50 FPS in *.csv file. 

Made with [Processing](https://processing.org/) 3.5.3 using Java. 

The project was created during my Master's course in National Research University "Higher School of Economics".

The project has lots of weak points (especially in the coin collision part), so, please: **if you use it - improve it** at least a bit.

## If you want to just start using it:
1. Download the latest version of [Processing IDE](https://processing.org/download/)
2. Download the last version of [Java](https://www.java.com/)
3. Download this project, it has all the source code
4. All of the project files must be inside of the folder named "sketch_6_coins"
5. Open sketch_6_coins.pde in Processing IDE
6. Export the project as an application

Processing will generate a folder(s) with executibles and everything you need to run this project.
After that, proceed using it just as any other app. 

### How do I close it?
Press "Q" on the keyboard. If it doesn't respond, click within the app space and try again. 

## How to access the solution data?
The app saves all recordings in the \*.csv file in the root folder of the app. Column separator is ",", line separator is LF. 

There is a header with columns' names in the file. Columns are: TIME, COIN_ID, X, Y, STATE, MOVESLOCAL, MOVESGLOBAL

The name of the file consists of data and time when the app was launched. The date/time format in the file name is d.m.YYYY_h.m.s

Example: 7.6.2018_22.17.19
