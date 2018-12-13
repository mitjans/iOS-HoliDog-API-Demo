//
//  BreedsTableViewController.swift
//  HoliDog
//
//  Created by Carles Mitjans Coma on 12/13/18.
//  Copyright © 2018 Carles Mitjans Coma. All rights reserved.
//

import UIKit

protocol BreedsTableViewDelegate {
    var currentBreed: String? { get set }
    var breeds: [String] { get set }
}

class BreedsTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var currentBreed: String?
    var delegate: BreedsTableViewDelegate?
    var breeds: [String] = [] {
        didSet {
            self.delegate?.breeds = breeds
            self.searchBreeds = breeds
        }
    }
    var searchBreeds: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor.black
        fetchBreeds()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBreeds.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "breedCell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "Random"
        } else {
            cell.textLabel?.text = searchBreeds[indexPath.row - 1].capitalized
        }
        
        if indexPath.row == 0 && currentBreed == nil {
            cell.accessoryType = .checkmark
            cell.backgroundColor = UIColor(red: 160/255, green: 213/255, blue: 157/255, alpha: 1)
        } else if searchBreeds.indices.contains(indexPath.row - 1) && searchBreeds[indexPath.row - 1].lowercased() == currentBreed {
            cell.accessoryType = .checkmark
            cell.backgroundColor = UIColor(red: 160/255, green: 213/255, blue: 157/255, alpha: 1)
        } else {
            cell.accessoryType = .none
            cell.backgroundColor = UIColor(red: 221/255, green: 240/255, blue: 222/255, alpha: 1)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.currentBreed = indexPath.row == 0 ? nil : searchBreeds[indexPath.row - 1]
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper functions
    @IBAction func cancelButtonPressed(_ sender: Any) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    func fetchBreeds() {
        HoliDogAPI.listAllBreeds { (breeds, optionalError) in
            if let error = optionalError {
                print("Error: \(error)")
                return
            }
            self.breeds = breeds.sorted()
        }
    }
}

extension BreedsTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBreeds = breeds
        return true
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var temp: [String] = []
        if let text = searchBar.text, text.count != 0 {
            for breed in breeds {
                if breed.contains(text.lowercased()) {
                    temp.append(breed)
                }
            }
        } else {
            temp = breeds
        }
        self.searchBreeds = temp
    }
}
