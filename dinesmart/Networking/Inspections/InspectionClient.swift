import Foundation

class InspectionClient: APIClient {
    let session = URLSession(configuration: .default)
    let jsonDecoder = JSONDecoder()
    
    typealias InspectionCompletionHandler = (Result<[InspectedLocation], APIError>) -> Void
    
    func inspections(completion: @escaping InspectionCompletionHandler) {
        fetchWith(Inspections.all.request, decode: [InspectedLocation].self, completion: completion)
    }
}
