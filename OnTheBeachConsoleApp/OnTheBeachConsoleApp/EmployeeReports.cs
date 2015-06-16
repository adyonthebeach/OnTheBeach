using System;
using System.Collections.Generic;
using DataAccess;
using DataModels;

namespace OnTheBeachConsoleApp
{
    /// <summary>
    /// Employee report Class Provides a single Public method to run the applications reports
    /// 
    /// Reports
    /// 1. Employees Salary report.
    /// 2. Ordered List of Salaries by role.
    /// </summary>
    public class EmployeeReports
    {
        /// <summary>
        /// Public method providing entry point into application
        /// </summary>
        public void RunReports()
        {
            ConsoleKeyInfo reportSelection = GetReportType();

            // run application while user does not press escape key
            while (reportSelection.Key != ConsoleKey.Escape)
            {
                try
                {
                    // Select report to run
                    switch (reportSelection.KeyChar)
                    {
                        case 'e':
                        case 'E':
                            RunEmployeeSalary();
                            reportSelection = GetReportType();
                            break;
                        case 'r':
                        case 'R':
                            RunOrderedSalaryByRole();
                            reportSelection = GetReportType();
                            break;
                        default:
                            Console.WriteLine("Selection not recognised, please try again or press the escape key to exit.");
                            reportSelection = Console.ReadKey(true);
                            break;
                    }
                }
                catch(Exception ex)
                {
                    Console.WriteLine("Something has gone wrong - " + ex.Message);
                    Console.WriteLine("Please try again or press the escape key to exit." + Environment.NewLine);
                    reportSelection = GetReportType();
                }
            }
        }

        /// <summary>
        /// Show options to user and return selection
        /// </summary>
        /// <returns></returns>
        private ConsoleKeyInfo GetReportType()
        {
            Console.WriteLine("Which report would you like to run?.");
            Console.WriteLine("1, Press E to view an employee's salary.");
            Console.WriteLine("2, Press R for an ordered list of salaries by role.");
            Console.WriteLine("OR press the escape key to exit.");
            Console.WriteLine(Environment.NewLine);

            return Console.ReadKey(true);
        }

        /// <summary>
        /// Run the Employee Salary summary report and output with Local and GBP format
        /// </summary>
        private static void RunEmployeeSalary()
        {
            Console.Write("Enter an Employees Name: ");
            string employeeName = Console.ReadLine();

            // Get the Employee Summary from the Data Access Layer
            EmployeeSalary employee = EmployeeData.GetLocalSalaryByName(employeeName);

            // Output the data in the reports format
            if (employee.Id != int.MinValue)
            {
                Console.WriteLine("ID: {0}", employee.Id);
                Console.WriteLine("Name: {0}", employee.Name);
                Console.WriteLine("Role: {0}", employee.Role);
                Console.WriteLine("Local Currency: {0}", employee.LocalCurrency);
                Console.WriteLine("Salary (Local): {0}", employee.SalaryLocal);
                Console.WriteLine("----------------------");
                Console.WriteLine("Salary (GBP): {0}", employee.SalaryGbp);
                Console.WriteLine("----------------------");
            }
            else
            {
                Console.WriteLine("Sorry no employee was found with that name.");
            }
            Console.WriteLine(Environment.NewLine);
        }

        /// <summary>
        /// Run the Ordered Salary report using the role entered by the user
        /// </summary>
        private void RunOrderedSalaryByRole()
        {
            // Get the role to filter by
            Console.Write("Enter a Role: ");
            string roleName = Console.ReadLine();

            // Get the list of employees from the data layer who have a corresponding role
            List<EmployeeSalary> employees = EmployeeData.GetOrderedSalariesByRole(roleName);

            Console.WriteLine(Environment.NewLine);
            if (employees.Count > 0)
            {
                // If some employees are found output the employee's salary with local currency and GBP
                foreach (EmployeeSalary empSalary in employees)
                {
                    Console.WriteLine("{0} {1} ({2}) £{3} (GBP)", empSalary.Name, empSalary.SalaryLocal, empSalary.LocalCurrency, empSalary.SalaryGbp);
                }
            }
            else
            {
                Console.WriteLine("Sorry no results were found with that role.");
            }
            Console.WriteLine(Environment.NewLine);
        }
    }
}
