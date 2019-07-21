//
//  ViewController.swift
//  SearchControllerTest
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 20/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {
    
    let tableData = ["One","Two","Three","Twenty-One","One","Two","Three","Twenty-One","One","Two","Three","Twenty-One","One","Two","Three","Twenty-One","One","Two","Three","Twenty-One","One","Two","Three","Twenty-One"]
    var filteredTableData = [String]()
//    var resultSearchController = UISearchController(searchResultsController: nil)
    var resultSearchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resultSearchController.searchResultsUpdater = self
        // tableview가 불완전해지는 거 막기...?
        resultSearchController.obscuresBackgroundDuringPresentation = false
        // 레이아웃 에러 피하기
        definesPresentationContext = true
        tableView.tableHeaderView = resultSearchController.searchBar
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.searchBar.tintColor = UIColor.white
        resultSearchController.searchBar.barTintColor = UIColor.red
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.isActive {
            return filteredTableData.count
        }
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell") as! DetailTableViewCell
        
        if resultSearchController.isActive {
            cell.titleLabel.text = filteredTableData[indexPath.row]
        } else {
            cell.titleLabel.text = tableData[indexPath.row]
        }
        
        return cell
    }

    func updateSearchResults(for searchController: UISearchController) {
//        filteredTableData.removeAll()
//
//        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] $@", searchController.searchBar.text!)
//        let array = (tableData as NSArray).filtered(using: searchPredicate)
//        filteredTableData = array as! [String]
//
//        tableView.reloadData()
        
        let text = searchController.searchBar.text ?? ""
        filteredTableData = tableData.filter { $0.lowercased().contains(text.lowercased()) }
        tableView.reloadData()
    }

}

