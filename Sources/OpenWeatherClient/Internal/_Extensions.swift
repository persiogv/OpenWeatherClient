//
//  _Extensions.swift
//  OpenWeatherClient
//
//  Created by Pérsio on 26/04/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import Foundation

extension Double {
    
    var stringValue: String {
        return String(self)
    }
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Int {
    
    var description: String {
        return String(self)
    }
}

extension String {
    
    var folded: String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
}
