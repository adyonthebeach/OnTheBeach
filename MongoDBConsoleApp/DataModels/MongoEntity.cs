using MongoDB.Bson;
namespace DataModels
{
    /// <summary>
    /// An abstract class containing the id implementation used by all Mongo records
    /// </summary>
    public abstract class MongoEntity
    {
        public ObjectId _id { get; set; }
    }
}
