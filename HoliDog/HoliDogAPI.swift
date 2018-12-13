//
//  HoliDogAPI.swift
//  HoliDog
//
//  Created by Carles Mitjans Coma on 12/13/18.
//  Copyright © 2018 Carles Mitjans Coma. All rights reserved.
//

import UIKit

class HoliDogAPI {    
    //MARK: - REST API Endpoints
    
    //MARK: List all breeds
    static func listAllBreeds(completionHandler completion: @escaping ([String], Error?) -> ()) {
        getData(from: URL(string: "https://dog.ceo/api/breeds/list/all")!) { (optionalData, optionalResponse, optionalError) in
            var breeds: [String] = []
            if let data = optionalData, let anyDict = try? JSONSerialization.jsonObject(with: data, options: []), let dict = anyDict as? [String: Any], let breedsDict = dict["message"] as? [String: [String]] {
                for (breed, subBreedList) in breedsDict {
                    if subBreedList.isEmpty {
                        breeds.append(breed)
                    } else {
                        for subBreed in subBreedList {
                            breeds.append("\(subBreed) \(breed)")
                        }
                    }
                }
            }
            completion(breeds, optionalError)
        }
    }
    
    //MARK: Random Image (by breed, by sub-breed)
    static func randomImage(byBreed breed: String?, completionHandler: @escaping (UIImage?, Error?) -> ()) {
        var url: URL
        if let breed = breed {
            url = URL(string: "https://dog.ceo/api/breed/\(breed.split(separator: " ").reversed().joined(separator: "/"))/images/random")!
        } else {
            url = URL(string: "https://dog.ceo/api/breeds/image/random")!
        }
        getData(from: url) { (optionalData, optionalResponse, optionalError) in
            if let data = optionalData, let json = try? JSONSerialization.jsonObject(with: data, options: []), let dict = json as? [String: String], let urlString = dict["message"], let url = URL(string: urlString) {
                downloadImage(from: url, completionHandler: completionHandler)
            }
        }
    }
    
    //MARK: - Helper functions

    //MARK: - Get Data
    private static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    //MARK: - Get Image
    private static func downloadImage(from url: URL, completionHandler: @escaping (UIImage?, Error?) -> ()) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let image = UIImage(data: data)
            completionHandler(image, error)
        }
    }
}
