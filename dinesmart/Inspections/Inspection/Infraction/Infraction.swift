import RealmSwift

class Infraction: Object, Decodable {
    @Persisted var details = ""
    @Persisted var severity = ""
}
