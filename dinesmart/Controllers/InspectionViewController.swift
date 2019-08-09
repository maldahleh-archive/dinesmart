//
//  InspectionViewController.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-07-19.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import GoogleMobileAds
import UIKit

class InspectionViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var inspectionTableView: UITableView!
    @IBOutlet weak var adView: GADBannerView!
    
    var inspectedLocation: InspectedLocation!
    
    private struct Constants {
        static let SmallView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0,
            height: Double(Float.leastNormalMagnitude)))
        
        static let CellIdentifier = "InfractionCell"
        
        static let NoViolations = "No Violations"
        static let Severity = "Severity:"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inspectionTableView.dataSource = self
        inspectionTableView.tableHeaderView = Constants.SmallView
        inspectionTableView.tableFooterView = Constants.SmallView
        inspectionTableView.sectionHeaderHeight = 0
        inspectionTableView.sectionFooterHeight = 0
        
        nameLabel.text = inspectedLocation.name
        typeLabel.text = inspectedLocation.type
        addressLabel.text = inspectedLocation.address
        
        adView.rootViewController = self
        adView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        adView.load(GADRequest())
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
            mainLabel.text = Constants.NoViolations
            secondaryLabel.text = ""
            
            return cell
        }
        
        mainLabel.text = infraction.details
        secondaryLabel.text = "\(Constants.Severity) \(infraction.severity)"
        
        return cell
    }
}
