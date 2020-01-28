//
//  ForecastOperation.swift
//  OpenWeatherClient
//
//  Created by Pérsio on 23/10/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import UIKit

class ForecastOperation: AsyncOperation {
    
    private let provider: WeatherCoreProtocol
    private let latitude: Double
    private let longitude: Double
    private let units: Units
    private let language: Language
    private let cacheTime: TimeInterval
    private let completion: ForecastCompletion
    
    required init(provider: WeatherCoreProtocol, latitude: Double, longitude: Double, units: Units, language: Language, cacheTime: TimeInterval, completion: @escaping ForecastCompletion) {
        self.provider = provider
        self.latitude = latitude
        self.longitude = longitude
        self.units = units
        self.language = language
        self.cacheTime = cacheTime
        self.completion = completion
    }
    
    override func main() {
        super.main()
        
        provider.fetchForecast(latitude: latitude, longitude: longitude, units: units, language: language, cacheTime: cacheTime) { [weak self] result in
            guard let self = self else { return }
            
            do {
                let forecast = try result()
                self.completion { forecast }
                self.finish()
            } catch {
                self.completion { throw error }
                self.finish()
            }
        }
    }
}
