//
//  DetailCell.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-07-19.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    static let ReuseIdentifier = "InspectionCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    func update(for inspection: InspectedLocation) {
        nameLabel.text = inspection.name
        typeLabel.text = inspection.type
        addressLabel.text = inspection.address
    }
}
