# OnTheBeach

The console application code can be found in their respective consoleapp folders and the application executables can be found in their own executable folders.

MSSQL Setup and Installation

An instance of Microsoft SQL Server 2008 needs to be accessible
Open and run the Database Setup script provided in the MSSQL folder
Update the connection string in the OnTheBeachConsoleApp.exe.config file to reflect your database servers connection info, the data connection uses windows integrated credentials this may need to be updated if you are using specific usernames and passwords for the local database.

MongoDB Setup and Installation

Download and install at least mongo version 3.0
Make sure mongodb is running on the local server/machine by opening a cmd window, navigating to the Mongo installation folder and running mongod.
Import JSON dataset file provided in the MongoDB folder using the following command line where <path to file> is the location of the Dataset.json file
"mongoimport --db OnTheBeach -- collection emplyees --drop --file <path to file>\DataSet.json"
Additionally as done with the MSSQl example adding an index on the employee's name would improve performance when searching larger datasets, use the following command inside the mongo shell to add the relevant index.
db.employees.createIndex( { name : 1 } ) 
To use the mongo shell open a cmd window, navigate to the Mongo installation folder and run mongo.exe.

Task 1

An SQL file can be found in the MSSQL folder which contains a script which can be run to find all the employee salaries.

To achieve the same result using the MongoDB run the following commands. 
use OnTheBeach
db.employees.find()
This command needs to be run inside the Mongo Shell.
NOTE: This command will return the entire dataset which is not formatted in any way and would be unusable for end users.

Task 2 and 3

Run the applications in the executable folders make sure both the application.config files have been updated with the relevant connection string and that the databases have been installed and are running.

Application Summary and Critical Analysis

The applications accept case insensitive input, this was done to make the application more user friendly.

The applications also allow any role to be used to run the ordered salaries report.

Because it was suggested that the application could grow considerably a simple index was added to the employee table in MSSQL and on the employee collection in mongo, which uses the employees name and should maintain the applications responsiveness as the employee dataset grows.

No logging was implemented in this application, because of its size and my time constraints, however if the application was expected to grow then a suitable logging strategy should be used. I would recommend log4net as it provides simple flexibility to pipe logging information to various places and is extensible by providing a customisable level of logging. 

The Exception logging that I implemented was basic, some considerations should be taken here if the application was to be used in a larger production environment, such as the use of logging at the point of failure to record more information about the specific problem and to help debug issues.

