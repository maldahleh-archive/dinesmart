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
    @IBOutlet weak var inspectionTableView: UITableView!
    
    var inspectedLocation: InspectedLocation!
    
    private struct Constants {
        static let CellIdentifier = "InfractionCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inspectionTableView.dataSource = self
        
        nameLabel.text = inspectedLocation.name
        typeLabel.text = inspectedLocation.type
        addressLabel.text = inspectedLocation.address
        dataSourceLabel.text = "Source: "
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension InspectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return inspectedLocation.inspections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalInfractions = inspectedLocation.inspections[section].infractions.count
        if totalInfractions == 0 {
            return 1
        }
        
        return totalInfractions
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let inspection = inspectedLocation.inspections.safeGet(index: section) else {
            return nil
        }
        
        return "\(inspection.date) - \(inspection.status)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let inspection = inspectedLocation.inspections.safeGet(index: indexPath.section) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier, for: indexPath)
        guard let mainLabel = cell.textLabel, let secondaryLabel = cell.detailTextLabel else {
            return UITableViewCell()
        }
        
        guard let infraction = inspection.infractions.safeGet(index: indexPath.row) else {
            mainLabel.text = "No Violations"
            secondaryLabel.text = ""
            
            return cell
        }
        
        mainLabel.text = infraction.details
        secondaryLabel.text = "Severity: \(infraction.severity)"
        
        return cell
    }
}
