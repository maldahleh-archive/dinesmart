import Alamofire

class InspectionClient {
    typealias InspectionsCompletionHandler = ([InspectedLocation]?) -> Void

    func inspections(completion: @escaping InspectionsCompletionHandler) {
        AF.request("https://infinite-stream-30246.herokuapp.com/inspections")
          .validate()
          .responseDecodable(of: [InspectedLocation].self) { response in
              guard let inspections = response.value else {
                  completion(nil)
                  return
              }

              completion(inspections)
          }
    }
}
