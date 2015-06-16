namespace DataModels
{
    /// <summary>
    /// An employees salary model implementation
    /// </summary>
    public class Salary : MongoEntity
    {
        public int salary_id { get; set; }
        public Currency currency { get; set; }
        public long annual_amount { get; set; }
    }
}
