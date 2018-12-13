//
//  ViewController.swift
//  HoliDog
//
//  Created by Carles Mitjans Coma on 12/13/18.
//  Copyright © 2018 Carles Mitjans Coma. All rights reserved.
//

import UIKit
import QuartzCore
import SVProgressHUD

class ViewController: UIViewController, BreedsTableViewDelegate {
    
    @IBOutlet weak var fetchDogButton: UIButton!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var currentBreedView: UIView!
    @IBOutlet weak var breedButton: UIButton!
    
    var breeds: [String] = []
    var currentBreed: String? = nil {
        didSet {
            self.breedButton.setTitle((currentBreed?.capitalized ?? "Random") + " ▾", for: .normal)
            self.fetchNewDog()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchNewDog()
    }
    
    func setupUI() {
        
        breedButton.titleLabel?.adjustsFontSizeToFitWidth = true
        breedButton.contentHorizontalAlignment = .left
        breedButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        breedButton.isEnabled = false
        
        dogImageView.layer.cornerRadius = 5
        dogImageView.clipsToBounds = true
        
        currentBreedView.layer.cornerRadius = 5
        currentBreedView.clipsToBounds = true
        
        fetchDogButton.layer.cornerRadius = 10
        fetchDogButton.clipsToBounds = true
        fetchDogButton.isEnabled = false
    }
    
    @IBAction func fetchDogButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        breedButton.isEnabled = false
        fetchNewDog()
    }
    
    func fetchNewDog() {
        SVProgressHUD.show()
        HoliDogAPI.randomImage(byBreed: currentBreed) { (optionalImage, optionalError) in
            if let error = optionalError {
                print("Error: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.dogImageView.image = optionalImage
                self.fetchDogButton.isEnabled = true
                self.breedButton.isEnabled = true
            }
            SVProgressHUD.dismiss()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBreedsSegue" {
            let destinationVC = (segue.destination as! UINavigationController).viewControllers.first as! BreedsTableViewController
            destinationVC.breeds = breeds
            destinationVC.currentBreed = currentBreed
            destinationVC.delegate = self
        }
    }
}
