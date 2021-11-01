import Realm
import RealmSwift

@objcMembers class Inspection: Object, Decodable {
    dynamic var date = ""
    dynamic var status = ""
    
    let infractions = List<Infraction>()
    
    private enum CodingKeys: String, CodingKey {
        case date, status, infractions
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.date = try container.decode(String.self, forKey: .date)
        self.status = try container.decode(String.self, forKey: .status)
        
        let infractionList = try container.decode([Infraction].self, forKey: .infractions)
        infractions.append(objectsIn: infractionList)
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
