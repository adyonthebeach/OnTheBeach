namespace DataModels
{
    /// <summary>
    /// The company role implementation
    /// </summary>
    public class Role : MongoEntity
    {
        public int role_id { get; set; }
        public string name { get; set; }
    }
}
