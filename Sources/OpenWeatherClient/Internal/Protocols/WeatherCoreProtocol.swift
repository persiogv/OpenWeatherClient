//
//  WeatherManagerProtocol.swift
//  OpenWeatherClient
//
//  Created by Pérsio on 23/07/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import Foundation

protocol WeatherCoreProtocol {
    
    /// Fetches weather  for the given coordinates
    ///
    /// - Parameters:
    ///   - latitude: The coordinate latitude
    ///   - longitude: The coordinate longitude
    ///   - units: The units of the weather
    ///   - language: The language of the weather
    ///   - cacheTime: Time in seconds for cache
    ///   - completion: Callback completion handler
    func fetchWeather(latitude: Double,
                      longitude: Double,
                      units: Units,
                      language: Language,
                      cacheTime: TimeInterval,
                      completion: @escaping WeatherCompletion)
    
    /// Fetches forecast  for the given coordinates
    ///
    /// - Parameters:
    ///   - latitude: The coordinate latitude
    ///   - longitude: The coordinate longitude
    ///   - units: The units of the weather
    ///   - language: The language of the weather
    ///   - cacheTime: Time in seconds for cache
    ///   - completion: Callback completion handler
    func fetchForecast(latitude: Double,
                       longitude: Double,
                       units: Units,
                       language: Language,
                       cacheTime: TimeInterval,
                       completion: @escaping ForecastCompletion)
}
