namespace DataModels
{
    /// <summary>
    /// The employee model implementation
    /// </summary>
    public class Employee : MongoEntity
    {
        public int employee_id { get; set; }
        public string name { get; set; }
        public Role role { get; set; }
        public Salary salaries { get; set; }
    }
}
