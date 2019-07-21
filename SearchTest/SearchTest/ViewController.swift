//
//  ViewController.swift
//  SearchTest
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let data = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var filteredData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredData = data
    }
    
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! 
        
        cell.textLabel?.text = filteredData[indexPath.row]
        
        return cell
    }
    
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Text is changing....")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Text change is ended")
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel button clicked")
        searchBar.text = ""
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Text did begin")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Did click search button")
        
        filteredData = data.filter{ $0 == searchBar.text }
        tableView.reloadData()
    }
    

}

