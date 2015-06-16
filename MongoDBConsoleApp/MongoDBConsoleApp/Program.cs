using System;

namespace MongoDBConsoleApp
{
    class Program
    {
        /// <summary>
        /// Main application entry point
        /// </summary>
        /// <param name="args"></param>
        static void Main(string[] args)
        {
            try
            {
                EmployeeReports reports = new EmployeeReports();
                reports.RunReports();
            }
            catch
            {
                Console.WriteLine("A major problem has occured while running this application, please try again.");
            }
        }
    }
}
