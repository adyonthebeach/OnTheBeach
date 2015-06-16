using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using DataModels;
using MongoDB.Driver;
using MongoDB.Bson;
using MongoDB.Driver.Builders;

namespace DataAccess
{
    /// <summary>
    /// Data Access class provides methods to
    /// </summary>
    public static class EmployeeData
    {
        /// <summary>
        /// Get Mongo Database
        /// </summary>
        /// <returns></returns>
        private static MongoDatabase GetDatabase()
        {
            MongoClient mongo = new MongoClient(ConfigurationManager.AppSettings["MongoServer"]);
            var server = mongo.GetServer();
            MongoDatabase db = server.GetDatabase(ConfigurationManager.AppSettings["Database"]);

            return db;
        }

        /// <summary>
        /// Get the Employee information and local salary including GBP conversion for the employee
        /// with the mathing name
        /// </summary>
        /// <param name="name">Employee Name</param>
        /// <returns>An instance of an Employee Salary</returns>
        public static EmployeeSalary GetLocalSalaryByName(string name)
        {
            try
            {
                if (!String.IsNullOrEmpty(name))
                {
                    MongoDatabase db = GetDatabase();
                    IMongoQuery query = Query<Employee>.Matches(c => c.name, new BsonRegularExpression(name, "i"));
                    Employee employee = db.GetCollection<Employee>("employees").Find(query).FirstOrDefault<Employee>();

                    if (employee != null)
                    {
                        return ReadEmployeeSalary(employee);
                    }
                    else
                    {
                        return new EmployeeSalary();
                    }
                }
                else
                {
                    return new EmployeeSalary();
                }
            }
            catch (Exception)
            {
                throw new Exception("There has been a problem trying to access the Employee data.");
            }
        }

        /// <summary>
        /// Get a list of Employee Salary records for employees who's role is passed in through the rolename parameter
        /// </summary>
        /// <param name="roleName">The Role to filter employee records on</param>
        /// <returns>An ordered list of  Employee Salary records</returns>
        public static List<EmployeeSalary> GetOrderedSalariesByRole(string roleName)
        {
            try
            {
                if (!String.IsNullOrEmpty(roleName))
                {
                    MongoDatabase db = GetDatabase();
                    IMongoQuery query = Query<Employee>.Matches(c => c.role.name, new BsonRegularExpression(roleName, "i"));
                    List<Employee> employees = db.GetCollection<Employee>("employees").Find(query).ToList<Employee>();

                    if (employees.Count > 0)
                    {
                        List<EmployeeSalary> empSalaries = new List<EmployeeSalary>();
                        foreach (Employee emp in employees)
                        {
                            empSalaries.Add(ReadEmployeeSalary(emp));
                        }

                        return empSalaries.OrderByDescending(x => x.SalaryGbp).ToList();
                    }
                    else
                    {
                        return new List<EmployeeSalary>();
                    }
                }
                else
                {
                    return new List<EmployeeSalary>();
                }
            }
            catch (Exception)
            {
                throw new Exception("There has been a problem trying to access the Employee data.");
            }
        }

        /// <summary>
        /// Create a single Employee Salary using the Employee Entity model passed in
        /// </summary>
        /// <param name="Employee">A single employee model.</param>
        /// <returns>A single EmployeeSalary record</returns>
        private static EmployeeSalary ReadEmployeeSalary(Employee entity)
        {
            EmployeeSalary empSalary = new EmployeeSalary()
            {
                Id = entity.employee_id,
                Name = entity.name,
                Role = entity.role.name,
                LocalCurrency = entity.salaries.currency.unit,
                SalaryLocal = entity.salaries.annual_amount,
                SalaryGbp = Math.Round(entity.salaries.annual_amount / entity.salaries.currency.conversion_factor)
            };

            return empSalary;
        }
    }
}
