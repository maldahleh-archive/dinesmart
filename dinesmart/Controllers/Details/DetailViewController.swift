//
//  DetailViewController.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-07-16.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var inspectionsTable: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var inspectedLocations = [InspectedLocation]()
    var filteredLocations = [InspectedLocation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        inspectionsTable.dataSource = self
        filteredLocations = inspectedLocations
        
        if inspectedLocations.count > 1 {
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            definesPresentationContext = true
            
            inspectionsTable.tableHeaderView = searchController.searchBar
        }
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.ReuseIdentifier, for: indexPath) as? DetailCell,
            let inspection = filteredLocations.safeGet(index: indexPath.row) else {
                return UITableViewCell()
        }
        
        cell.update(for: inspection)
        return cell
    }
}

// MARK: - UISearchResultsUpdating
extension DetailViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        
        filteredLocations = inspectedLocations.filter { location in
            return location.address.lowercased().contains(searchText)
                || location.name.lowercased().contains(searchText)
        }
        
        inspectionsTable.reloadData()
    }
}
