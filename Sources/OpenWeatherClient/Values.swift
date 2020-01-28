//
//  Values.swift
//  OpenWeatherClient
//
//  Created by Pérsio on 26/04/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import Foundation

public enum Units: String {
    case metric
    case imperial
    
    init(stringValue: String?) {
        self = Units(rawValue: stringValue ?? "metric") ?? .metric
    }
}

public enum Language: String {
    case pt
    case en
    
    init(stringValue: String?) {
        self = Language(rawValue: stringValue ?? "en") ?? .en
    }
}
