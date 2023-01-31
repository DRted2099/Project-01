# Simulation of manufactruring lines

This is script was written in MATLAB.

Change the path of the .xslx file to the path saved on your computer when running the code. Make changes to lines that are commented with "Import the data"
The last section of the script consists of custom functions that generates breakdown time, cycle time and set-up time for each of the machines which is REQUIRED to run the model

All the data used in the code is extracted from the excel file.

ASSUMPTIONS:

1. The cycle time and MTTF follows normal distribution.
2. If a machine breakdown midway through a process, the process is started from the beginning
3. In case of a break down the MTTR is 6 hours with a standard deviation of 0.5 for all machines. 
4. No defects are produced

ABOUT THE MODEL:

The model takes the number of components to be manufactured as its input and provides the time taken to manufacture for each of the components as the output.

It does not give an accurate representation of the production lines due to the limited data available. Moreover adding in more factors increases the complexity of the model. 

The code simulates the production lines of 4 parts. It also plots bar graphs of :

1. Average Cycle Times for each product Line
2. Average Time taken by each machine 
3. Number of times a machine fails
4. Reliability of each machine
5. Wait times of each machine
6. Number of breakdowns of each machine
7. Reliability of the whole line (series reliability)
8. Cost comparision of each workstation


THE RESULTS (PICS OF GRAPHS) ARE IN THE PDF FILE
