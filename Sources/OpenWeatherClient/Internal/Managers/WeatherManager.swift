//
//  WeatherManager.swift
//  OpenWeatherClient
//
//  Created by Pérsio on 25/04/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import Foundation

class WeatherManager: Manager {
    
    private let provider: WeatherCoreProtocol
    
    required init(provider: WeatherCoreProtocol) {
        self.provider = provider
    }
}

// MARK: - Weather core protocol
extension WeatherManager: WeatherCoreProtocol {
    
    func fetchWeather(latitude: Double, longitude: Double, units: Units, language: Language, cacheTime: TimeInterval, completion: @escaping WeatherCompletion) {
        let callback: WeatherCompletion = { result in
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        let operation = WeatherOperation(provider: provider, latitude: latitude, longitude: longitude, units: units, language: language, cacheTime: cacheTime, completion: callback)
        
        addOperation(operation)
    }
    
    func fetchForecast(latitude: Double, longitude: Double, units: Units, language: Language, cacheTime: TimeInterval, completion: @escaping ForecastCompletion) {
        let callback: ForecastCompletion = { result in
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        let operation = ForecastOperation(provider: provider, latitude: latitude, longitude: longitude, units: units, language: language, cacheTime: cacheTime, completion: callback)
        
        addOperation(operation)
    }
}
