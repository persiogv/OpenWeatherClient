//
//  Weather.swift
//  OpenWeatherClient
//
//  Created by Pérsio on 13/04/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import Foundation

public struct Weather: Codable {
    
    public enum Condition: String, Codable {
        case clearSky
        case fewClouds
        case scatteredClouds
        case brokenClouds
        case showerRain
        case rain
        case thunderstorm
        case snow
        case mist
        case unknown
    }
    
    public var date: Date
    public var temp: Double
    public var minTemp: Double
    public var maxTemp: Double
    public var title: String
    public var isDay: Bool
    public var condition: Condition
    
    private struct Info: Codable {
        var description: String
        var icon: String
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case minTemp
        case maxTemp
        case title
        case isDay
        case condition

        case dt
        case main
        case temp
        case temp_min
        case temp_max
        case weather
    }
    
    public init(date: Date, temp: Double, minTemp: Double, maxTemp: Double, title: String, isDay: Bool, condition: Condition) {
        self.date = date
        self.temp = temp
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.title = title
        self.isDay = isDay
        self.condition = condition
    }
    
    public init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            date = try rootContainer.decode(Date.self, forKey: .date)
            temp = try rootContainer.decode(Double.self, forKey: .temp)
            minTemp = try rootContainer.decode(Double.self, forKey: .minTemp)
            maxTemp = try rootContainer.decode(Double.self, forKey: .maxTemp)
            title = try rootContainer.decode(String.self, forKey: .title)
            isDay = try rootContainer.decode(Bool.self, forKey: .isDay)
            condition = try rootContainer.decode(Condition.self, forKey: .condition)
        } catch {
            let timeInterval = try rootContainer.decode(TimeInterval.self, forKey: .dt)
            date = Date(timeIntervalSince1970: timeInterval)
            
            let mainContainer = try rootContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .main)
            temp = try mainContainer.decode(Double.self, forKey: .temp)
            minTemp = try mainContainer.decode(Double.self, forKey: .temp_min)
            maxTemp = try mainContainer.decode(Double.self, forKey: .temp_max)
            
            let info: Info = try rootContainer.decode([Info].self, forKey: .weather).first!
            title = info.description
            isDay = info.icon.contains("d")
            
            switch info.icon {
            case "01d", "01n":
                condition = .clearSky
            case "02d", "02n":
                condition = .fewClouds
            case "03d", "03n":
                condition = .scatteredClouds
            case "04d", "04n":
                condition = .brokenClouds
            case "09d", "09n":
                condition = .showerRain
            case "10d", "10n":
                condition = .rain
            case "11d", "11n":
                condition = .thunderstorm
            case "13d", "13n":
                condition = .snow
            case "50d", "50n":
                condition = .mist
            default:
                condition = .unknown
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(temp, forKey: .temp)
        try container.encode(minTemp, forKey: .minTemp)
        try container.encode(maxTemp, forKey: .maxTemp)
        try container.encode(title, forKey: .title)
        try container.encode(isDay, forKey: .isDay)
        try container.encode(condition, forKey: .condition)
    }
}
