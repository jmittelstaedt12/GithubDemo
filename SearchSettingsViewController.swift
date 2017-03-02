//
//  SearchSettingsViewController.swift
//  GithubDemo
//
//  Created by Jacob Mittelstaedt on 3/2/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class SearchSettingsViewController: UIViewController {

    weak var delegate: SettingsPresentingViewControllerDelegate?
    
    @IBOutlet weak var starsCountLabel: UILabel!
    
    var searchSettingsSVC = GithubRepoSearchSettings()
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        searchSettingsSVC.minStars = Int(starsCountLabel.text!)!
        self.delegate?.didSaveSettings(settings: searchSettingsSVC)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.delegate?.didCancelSettings()
        dismiss(animated: true, completion: nil)
    }
    //var searchSettingsCopy = searchSettingsSVC
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func starsSlider(_ sender: UISlider) {
        starsCountLabel.text = String(Int(sender.value))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
    protocol SettingsPresentingViewControllerDelegate: class {
        func didSaveSettings(settings: GithubRepoSearchSettings)
        func didCancelSettings()
}
