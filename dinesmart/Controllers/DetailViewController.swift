//
//  DetailViewController.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-07-16.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var inspectionsTable: UITableView!
    
    var inspectedLocations = [InspectedLocation]()
    var filteredLocations = [InspectedLocation]()
    
    private struct Constants {
        static let ReuseIdentifier = "InspectionCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesKeyboardOnTap()
        
        inspectionsTable.dataSource = self
        searchBar.delegate = self
        
        filteredLocations = inspectedLocations
    }
    
    @IBAction func dismissControllerTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let inspection = filteredLocations.safeGet(index: indexPath.row) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseIdentifier, for: indexPath)
        guard let mainLabel = cell.textLabel, let secondaryLabel = cell.detailTextLabel else {
            return UITableViewCell()
        }
        
        mainLabel.text = inspection.name
        secondaryLabel.text = inspection.address

        return cell
    }
}

// MARKL - UISearchBarDelegate
extension DetailViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty || searchText == "" {
            filteredLocations = inspectedLocations
        } else {
            filteredLocations = inspectedLocations.filter { location in
                return location.address.lowercased().contains(searchText.lowercased())
                    || location.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        inspectionsTable.reloadData()
    }
}
