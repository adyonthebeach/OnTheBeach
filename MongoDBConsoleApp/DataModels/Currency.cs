namespace DataModels
{
    /// <summary>
    /// The Currency model implementation
    /// </summary>
    public class Currency : MongoEntity
    {
        public int currency_id { get; set; }
        public string unit { get; set; }
        public decimal conversion_factor { get; set; }
    }
}
