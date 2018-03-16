//
//  MainViewController.swift
//  DoughFlow
//
//  Created by admin on 3/12/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class MainViewController: UITableViewController {
    
    let realm = try! Realm()
    let defaults = UserDefaults.standard
    var items: Results<Item>?
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        searchBar.backgroundImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItems()
    }
    
    // MARK: - tableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = "$\(item.price)"
            
            if let color = UIColor(hexString: item.backgroundColor)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(items!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                cell.detailTextLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        }
        
        return cell
    }
    
    //  MARK: - tableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItemInfo", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if let itemForDeletion = self.items?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(itemForDeletion)
                    }
                } catch {
                    displayAlert("Error deleting item")
                }
                loadItems()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem

        if segue.identifier == "goToItemInfo" {
            
            guard let dollarsPerYear = Double(defaults.object(forKey: "dollarsPerYear") as! String!) else {
                displayAlert("Please enter your salary first")
                return
            }
            
            guard let hoursPerWeek = Double(defaults.object(forKey: "hoursPerWeek") as! String!) else {
                displayAlert("Please enter your hours/week worked first")
                return
            }
            
            let destinationVC = segue.destination as! ItemInfoViewController

            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedItem = items?[indexPath.row]
                destinationVC.salary = dollarsPerYear
                destinationVC.hours = hoursPerWeek
            }
        }
    }
    
    func loadItems() {
        items = realm.objects(Item.self).sorted(byKeyPath: "dateCreated")
        tableView.reloadData()
    }
    
}

// MARK: - SearchBar methods

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
