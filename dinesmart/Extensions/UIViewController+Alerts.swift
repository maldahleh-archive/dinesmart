//
//  UIViewController+Alerts.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-07-10.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import UIKit

extension UIViewController {
    private struct Messages {
        static let Header = "DineSmart"
        static let ErrorOccurred = "An error occured, try again later."
        static let Confirmation = "OK"
    }
    
    func presentGenericError() {
        let alertController = UIAlertController(title: Messages.Header, message: Messages.ErrorOccurred, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Messages.Confirmation, style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
