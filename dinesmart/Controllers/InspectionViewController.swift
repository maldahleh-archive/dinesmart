//
//  InspectionViewController.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-07-19.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import UIKit

class InspectionViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dataSourceLabel: UILabel!
    
    var inspectedLocation: InspectedLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = inspectedLocation.name
        typeLabel.text = inspectedLocation.type
        addressLabel.text = inspectedLocation.address
        dataSourceLabel.text = inspectedLocation.dataSource
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
