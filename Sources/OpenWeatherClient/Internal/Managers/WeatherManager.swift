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
        let callback: WeatherCompletion = { [weak self] result in
            guard let self = self else { return }
            let operation = BlockOperation { completion(result) }
            self.executeInMainQueue(operation: operation)
        }
        
        let operation = WeatherOperation(provider: provider, latitude: latitude, longitude: longitude, units: units, language: language, cacheTime: cacheTime, completion: callback)
        
        addOperation(operation)
    }
    
    func fetchForecast(latitude: Double, longitude: Double, units: Units, language: Language, cacheTime: TimeInterval, completion: @escaping ForecastCompletion) {
        let callback: ForecastCompletion = { [weak self] result in
            guard let self = self else { return }
            let operation = BlockOperation { completion(result) }
            self.executeInMainQueue(operation: operation)
        }
        
        let operation = ForecastOperation(provider: provider, latitude: latitude, longitude: longitude, units: units, language: language, cacheTime: cacheTime, completion: callback)
        
        addOperation(operation)
    }
}
