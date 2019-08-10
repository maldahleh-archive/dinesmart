//
//  DetailViewController.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-07-16.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import GoogleMobileAds
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var inspectionsTable: UITableView!
    @IBOutlet weak var adView: GADBannerView!
    
    var inspectedLocations = [InspectedLocation]()
    var filteredLocations = [InspectedLocation]()
    
    private struct Constants {
        static let ReuseIdentifier = "InspectionCell"
        static let InspectionSegue = "toInspectionView"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesKeyboardOnTap()
        
        inspectionsTable.dataSource = self
        inspectionsTable.delegate = self
        searchBar.delegate = self
        
        filteredLocations = inspectedLocations
        
        adView.rootViewController = self
        adView.adSize = kGADAdSizeBanner
        adView.adUnitID = "ca-app-pub-8516405525746627/9140906583"
        adView.load(GADRequest())
    }
    
    @IBAction func dismissControllerTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedLocation = filteredLocations.safeGet(index: indexPath.row) else {
            return
        }
        
        performSegue(withIdentifier: Constants.InspectionSegue, sender: selectedLocation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let destination = segue.destination as? InspectionViewController,
            let location = sender as? InspectedLocation,
            identifier == Constants.InspectionSegue else {
                return
        }
        
        destination.inspectedLocation = location
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

// MARK - UISearchBarDelegate
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
