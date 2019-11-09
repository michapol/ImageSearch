//
//  SearchViewController.swift
//  Candyspace
//
//  Created by Mike Pollard on 12/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var switchPhoto: UISwitch!
    @IBOutlet weak var switchIllustration: UISwitch!
    @IBOutlet weak var switchVector: UISwitch!
    @IBOutlet weak var switchAll: UISwitch!
    
    var searchController = SearchController()
    var searchText: String = "" {
        didSet {
            if searchText != "" && self.categorySelected() {
                searchButton.isEnabled = true
            } else {
                searchButton.isEnabled = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        
        self.switchPhoto.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        self.switchIllustration.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        self.switchVector.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        self.switchAll.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        progressView.alpha = 0.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        self.searchController.reduceCache()
    }
    
    @IBAction func searchButtonPressed() {
        guard searchText != "" else { return }
        let searchCategories = self.getSearchCategories()
        
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        
        UIView.animate(withDuration: 0.2) {
            self.progressView.alpha = 1.0
        }
    
        self.searchController.search(searchText: searchText, searchCategories: searchCategories) { (cache)  in
            if let cache = cache {
                self.launchResultsView(cache: cache)
            } else {
                DispatchQueue.main.async {
                    let alertView = UIAlertController(title: "Download Failed", message: "We were unable to complete your search, please try again", preferredStyle: .alert)
                    alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alertView, animated: true, completion: {
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.2) {
                                self.progressView.alpha = 0.0
                            }
                        }
                    })
                }
            }
        }
    }
    
    @objc func switchChanged(changedSwitch: UISwitch) {
        if switchPhoto.isOn, !(changedSwitch === self.switchPhoto) {
            switchPhoto.setOn(false, animated: true)
        }
        
        if switchIllustration.isOn, !(changedSwitch === self.switchIllustration) {
            switchIllustration.setOn(false, animated: true)
        }
        
        if switchVector.isOn, !(changedSwitch === self.switchVector) {
            switchVector.setOn(false, animated: true)
        }
        
        if switchAll.isOn, !(changedSwitch === self.switchAll) {
            switchAll.setOn(false, animated: true)
        }
        
        if self.searchText != "" && self.categorySelected() {
            self.searchButton.isEnabled = true
        } else {
            self.searchButton.isEnabled = false
        }
    }
    
    func launchResultsView(cache: SearchItem) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            if let resultsVC = storyboard.instantiateViewController(withIdentifier: "resultsViewController") as? ResultsViewController {
                resultsVC.cache = cache
                self.navigationController?.pushViewController(resultsVC, animated: true)
            }
        }
    }
    
    private func categorySelected() -> Bool {
        if switchPhoto.isOn || switchIllustration.isOn || switchVector.isOn || switchAll.isOn {
            return true
        }
        
        return false
    }
    
    private func getSearchCategories() -> String {
        if switchPhoto.isOn {
            return "photo"
        } else if switchIllustration.isOn {
            return "illustration"
        } else if switchVector.isOn {
            return "vector"
        } else {
            return "all"
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if self.categorySelected() {
            self.searchButtonPressed()
        }
    }
    
}
