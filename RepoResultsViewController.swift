//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD

// Main ViewController
class RepoResultsViewController: UIViewController, UITableViewDataSource, SettingsPresentingViewControllerDelegate{

    var searchBar: UISearchBar!
    var searchSettings = GithubRepoSearchSettings()
    @IBOutlet weak var tableView: UITableView!
    var repos: [GithubRepo]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableViewAutomaticDimension

        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar

        // Perform the first search when the view controller first loads
        doSearch()
    }
    

    // Perform the search.
    fileprivate func doSearch() {

        MBProgressHUD.showAdded(to: self.view, animated: true)

        // Perform request to GitHub API to get the list of repositories
        GithubRepo.fetchRepos(searchSettings, successCallback: { (newRepos) -> Void in

            // Print the returned repositories to the output window
            for repo in newRepos {
                print(repo)
            }   
            self.repos = newRepos
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
            }, error: { (error) -> Void in
                print(error)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let repos = repos{
            return repos.count
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell",for: indexPath) as! RepoCell
        let repo = self.repos![indexPath.row]
        
        let name = repo.name
        let description = repo.repoDescription
        let stars = repo.stars
        let forks = repo.forks
        let owner = repo.ownerHandle
        
        cell.nameLabel.text = name
        cell.descriptionLabel.text = description
        cell.ownerLabel.text = owner
        cell.forksLabel.text = "\(forks!)"
        cell.starsLabel.text = "\(stars!)"
        let imageUrl = NSURL(string: repo.ownerAvatarURL!)
        cell.avatarCell.setImageWith(imageUrl as! URL)
        cell.selectionStyle = .gray
        return cell
        
    }
    
    func didSaveSettings(settings: GithubRepoSearchSettings){
        searchSettings = settings
        doSearch()
    }
    func didCancelSettings(){
    }
    
}

// SearchBar methods
extension RepoResultsViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let vc = navController.topViewController as! SearchSettingsViewController
        vc.searchSettingsSVC = searchSettings
        vc.delegate = self
    }
}
