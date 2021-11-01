import RealmSwift

class Inspection: Object, Decodable {
    @Persisted var date = ""
    @Persisted var status = ""
    @Persisted var infractions: List<Infraction>
}
