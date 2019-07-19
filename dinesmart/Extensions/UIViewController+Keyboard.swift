//
//  UIViewController+Keyboard.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-07-19.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import UIKit

extension UIViewController {
    func hidesKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
}
