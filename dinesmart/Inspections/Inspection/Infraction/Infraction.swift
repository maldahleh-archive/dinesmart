import Realm
import RealmSwift

@objcMembers class Infraction: Object, Decodable {
    dynamic var details = ""
    dynamic var severity = ""
    
    private enum CodingKeys: String, CodingKey {
        case details, severity
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.details = try container.decode(String.self, forKey: .details)
        self.severity = try container.decode(String.self, forKey: .severity)
        
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
