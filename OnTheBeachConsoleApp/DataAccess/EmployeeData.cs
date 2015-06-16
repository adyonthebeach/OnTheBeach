using System;
using DataModels;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace DataAccess
{
    /// <summary>
    /// Data Access class provides methods to
    /// </summary>
    public static class EmployeeData
    {
        /// <summary>
        /// Get the Employee information and local salary including GBP conversion for the employee
        /// with the mathing name
        /// </summary>
        /// <param name="name">Employee Name</param>
        /// <returns>An instance of an Employee Salary</returns>
        public static EmployeeSalary GetLocalSalaryByName(string name)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSQLConnection"].ToString());

            try
            {
                var cmd = new SqlCommand("GetEmployeeSalary", conn) {CommandType = CommandType.StoredProcedure};
                cmd.Parameters.Add(new SqlParameter("employee_name", name));

                conn.Open();
                var reader = cmd.ExecuteReader();

                if(reader.HasRows)
                {
                    reader.Read();

                    return ReadEmployeeSalary(reader);
                }
                else
                {
                    return new EmployeeSalary();
                }
            }
            catch (SqlException sex)
            {
                throw new Exception("There has been a problem trying to access the Employee data.");
            }
            finally
            {
                conn.Close();
            }
        }

        /// <summary>
        /// Get a list of Employee Salary records for employees who's role is passed in through the rolename parameter
        /// </summary>
        /// <param name="roleName">The Role to filter employee records on</param>
        /// <returns>An ordered list of  Employee Salary records</returns>
        public static List<EmployeeSalary> GetOrderedSalariesByRole(string roleName)
        {
            SqlConnection conn = GetDatabaseConnection();

            try
            {
                var cmd = new SqlCommand("GetOrderedSalariesByRole", conn) {CommandType = CommandType.StoredProcedure};
                cmd.Parameters.Add(new SqlParameter("role", roleName));

                conn.Open();
                var reader = cmd.ExecuteReader();

                List<EmployeeSalary> results = new List<EmployeeSalary>();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        results.Add(ReadEmployeeSalary(reader));
                    }
                }

                return results;
            }
            catch (SqlException sex)
            {
                throw new Exception("There has been a problem trying to access the Employee data.");
            }
            finally
            {
                conn.Close();
            }
        }

        /// <summary>
        /// Get the MSSQL database connection
        /// </summary>
        /// <returns></returns>
        private static SqlConnection GetDatabaseConnection()
        {
            return new SqlConnection(ConfigurationManager.ConnectionStrings["MSSQLConnection"].ToString());
        }

        /// <summary>
        /// Create a single Employee Salary using the SQL Data reader passed in
        /// </summary>
        /// <param name="reader">A SQL Data Reader ready to read out the next employee salary record.</param>
        /// <returns>A single EmployeeSalary record</returns>
        private static EmployeeSalary ReadEmployeeSalary(SqlDataReader reader)
        {
            EmployeeSalary salary = new EmployeeSalary();
            salary.Id = int.Parse(reader["employee_id"].ToString());
            salary.Name = reader["name"].ToString();
            salary.Role = reader["role"].ToString();
            salary.LocalCurrency = reader["local_currency"].ToString();
            salary.SalaryLocal = long.Parse(reader["salary_local"].ToString());
            salary.SalaryGbp = decimal.Parse(reader["salary_gbp"].ToString());

            return salary;
        }
    }
}
