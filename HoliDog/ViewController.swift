//
//  ViewController.swift
//  HoliDog
//
//  Created by Carles Mitjans Coma on 12/13/18.
//  Copyright © 2018 Carles Mitjans Coma. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    
    @IBOutlet weak var fetchDogButton: UIButton!
    @IBOutlet weak var dogImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchDogButton.layer.cornerRadius = 10
        fetchDogButton.clipsToBounds = true
        
        fetchNewDog()
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func dataToDictionary(data: Data?) -> [String: String]? {
        if let data = data {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
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
        getData(from: URL(string: "https://dog.ceo/api/breeds/image/random")!) { (optionalData, optionalResponse, optionalError) in
            if let dict = self.dataToDictionary(data: optionalData) {
                let dogImageURL = URL(string: dict["message"]!)!
                self.downloadImage(from: dogImageURL)
            }
        }
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                self.dogImageView.image = UIImage(data: data)
                self.fetchDogButton.isEnabled = true
            }
        }
    }
}
