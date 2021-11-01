import UIKit

extension UIViewController {
    typealias ActionCompletionHandler = (UIAlertAction) -> Void
    
    private struct Messages {
        static let Header = "DineSmart"
        
        static let ErrorOccurred = "An error occured, try again later.\n\nThis may be because of a poor internet connection."
        static let ErrorConfirmation = "Retry"
    }
    
    func presentAPIError(_ completion: @escaping ActionCompletionHandler) {
        let alertController = UIAlertController(title: Messages.Header, message: Messages.ErrorOccurred, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Messages.ErrorConfirmation, style: .default, handler: completion))
        
        present(alertController, animated: true, completion: nil)
    }
}
