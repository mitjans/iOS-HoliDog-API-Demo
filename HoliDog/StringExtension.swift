//
//  StringExtension.swift
//  HoliDog
//
//  Created by Carles Mitjans Coma on 12/13/18.
//  Copyright © 2018 Carles Mitjans Coma. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
