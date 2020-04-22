//
//  OpenWeatherClient.swift
//  OpenWeatherClient
//
//  Created by Pérsio on 09/04/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import Foundation

public typealias Forecast = [Weather]
public typealias WeatherCompletion = (Result<Weather, Error>) -> Void
public typealias ForecastCompletion = (Result<Forecast, Error>) -> Void

public final class OpenWeatherClient {
    
    private var appId = String()
    private lazy var manager = WeatherManager(provider: WeatherProvider(requester: Requester(), appId: appId))
    public static let shared = OpenWeatherClient()
    
    private init() {}
    
    public static func with(appId: String) {
        OpenWeatherClient.shared.appId = appId
    }
}

// MARK: - Fetching weather
extension OpenWeatherClient: WeatherCoreProtocol {
    
    public func fetchWeather(latitude: Double, longitude: Double, units: Units, language: Language, cacheTime: TimeInterval, completion: @escaping WeatherCompletion) {
        manager.fetchWeather(latitude: latitude, longitude: longitude, units: units, language: language, cacheTime: cacheTime, completion: completion)
    }
    
    public func fetchForecast(latitude: Double, longitude: Double, units: Units, language: Language, cacheTime: TimeInterval, completion: @escaping ForecastCompletion) {
        manager.fetchForecast(latitude: latitude, longitude: longitude, units: units, language: language, cacheTime: cacheTime, completion: completion)
    }
}
