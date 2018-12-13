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

class ViewController: UIViewController {
    
    @IBOutlet weak var fetchDogButton: UIButton!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var currentBreedView: UIView!
    @IBOutlet weak var breedButton: UIButton!
    @IBOutlet weak var breedPickerView: UIPickerView!
    
    var breeds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchBreedsList()
        fetchNewDog()
    }
    
    func setupUI() {
        breedPickerView.isHidden = true
        breedPickerView.delegate = self
        breedButton.contentHorizontalAlignment = .left
        breedButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        dogImageView.layer.cornerRadius = 5
        dogImageView.clipsToBounds = true
        currentBreedView.layer.cornerRadius = 5
        currentBreedView.clipsToBounds = true
        fetchDogButton.layer.cornerRadius = 10
        fetchDogButton.clipsToBounds = true
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func dataToDictionary(data: Data?) -> [String: Any]? {
        if let data = data {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            } catch {
                print("Error!")
            }
        }
        return nil
    }
    
    @IBAction func fetchDogButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        fetchNewDog()
    }
    
    func fetchNewDog() {
        SVProgressHUD.show()
        getData(from: URL(string: "https://dog.ceo/api/breeds/image/random")!) { (optionalData, optionalResponse, optionalError) in
            if let dict = self.dataToDictionary(data: optionalData) {
                let dogImageURL = URL(string: dict["message"]! as! String)!
                self.downloadImage(from: dogImageURL)
            }
        }
    }
    
    func fetchBreedsList() {
        SVProgressHUD.show()
        getData(from: URL(string: "https://dog.ceo/api/breeds/list/all")!) { (optionalData, optionalResponse, optionalError) in
            if let dict = self.dataToDictionary(data: optionalData), let breedDict = dict["message"]! as? [String: [String]] {
                for (breed, subBreed) in breedDict {
                    if subBreed.isEmpty {
                        self.breeds.append(breed.capitalizingFirstLetter())
                    } else {
                        for sub in subBreed {
                            self.breeds.append("\(sub.capitalizingFirstLetter()) \(breed.capitalizingFirstLetter())")
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.breedPickerView.reloadAllComponents()
            }
        }
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.dogImageView.image = UIImage(data: data)
                SVProgressHUD.dismiss()
                self.fetchDogButton.isEnabled = true
            }
        }
    }
}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let name = breeds[row]
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    
    @IBAction func breedPickerButtonPressed(_ sender: UIButton) {
        breedPickerView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.breedPickerView.frame = CGRect(x: 0, y: self.view.frame.height - self.breedPickerView.frame.height, width: self.breedPickerView.frame.width, height: self.breedPickerView.frame.height)
        }
    }
}
