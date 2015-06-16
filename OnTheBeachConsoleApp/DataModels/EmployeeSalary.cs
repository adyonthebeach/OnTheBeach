namespace DataModels
{
    /// <summary>
    /// Employee Salary class provides access to all the fields required by both report outputs
    /// </summary>
    public class EmployeeSalary
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Role { get; set; }
        public string LocalCurrency { get; set; }
        public long SalaryLocal { get; set; }
        public decimal SalaryGbp { get; set; }

        public EmployeeSalary()
        {
            Id = int.MinValue;
        }
    }
}
