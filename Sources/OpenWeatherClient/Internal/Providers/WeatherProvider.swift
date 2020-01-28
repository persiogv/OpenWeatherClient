//
//  WeatherProvider.swift
//  OpenWeatherClient
//
//  Created by Pérsio on 09/04/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import Foundation

class WeatherProvider: ApiProvider {
    
    private struct Constants {
        static let baseUrl = "http://api.openweathermap.org/data/2.5"
        
        struct Paths {
            static let weather = "/weather"
            static let forecast = "/forecast"
        }
        
        struct Values {
            static let appId = "5144f37b9088e3b7566bf03f8236011e"
        }
        
        struct Keys {
            static let appId = "appid"
            static let units = "units"
            static let language = "lang"
            static let latitude = "lat"
            static let longitude = "lon"
            static let list = "list"
        }
    }
    
    private let appId: String
    
    required init(requester: ApiProviderRequesterProtocol = ApiProviderRequester(), appId: String) {
        self.appId = appId
        super.init(requester: requester, baseUrl: Constants.baseUrl)
    }
}

// MARK: - Private
extension WeatherProvider {
    
    private func handleWeatherResponse(_ response: @escaping Response, cacheKey: String, cacheTime: TimeInterval, completion: @escaping WeatherCompletion) {
        completion {
            let data = try response()
            
            if cacheTime > 0 {
                _ = Cacher.persistent.cacheValue(data, toKey: cacheKey, expires: .seconds(cacheTime))
            }
            
            return try JSONDecoder().decode(Weather.self, from: data)
        }
    }
    
    private func handleForecastResponse(_ response: @escaping Response, cacheKey: String, cacheTime: TimeInterval, completion: @escaping ForecastCompletion) {
        completion {
            let data = try response()
            
            if cacheTime > 0 {
                _ = Cacher.persistent.cacheValue(data, toKey: cacheKey, expires: .seconds(cacheTime))
            }
            
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let list = json[Constants.Keys.list] {
                let listData = try JSONSerialization.data(withJSONObject: list, options: [])
                
                return try JSONDecoder().decode([Weather].self, from: listData)
            }
            
            throw ApiProviderError.invalidData
        }
    }
    
    private func buildParameters(latitude: Double, longitude: Double, units: Units, language: Language) -> [Parameter] {
        var parameters = buildParameters(units: units, language: language)
        parameters.append((Constants.Keys.latitude, latitude.stringValue))
        parameters.append((Constants.Keys.longitude, longitude.stringValue))
        
        return parameters
    }
    
    private func buildParameters(units: Units, language: Language) -> [Parameter] {
        return [(Constants.Keys.appId, Constants.Values.appId),
                (Constants.Keys.units, units.rawValue),
                (Constants.Keys.language, language.rawValue)]
    }
    
    private func GET(path: String, parameters: [Parameter], completion: @escaping Completion) {
        GET(path: path, body: nil, headers: [], parameters: parameters, completion: completion)
    }
}

// MARK: - Weather core protocol
extension WeatherProvider: WeatherCoreProtocol {
    
    func fetchWeather(latitude: Double,
                      longitude: Double,
                      units: Units,
                      language: Language,
                      cacheTime: TimeInterval,
                      completion: @escaping WeatherCompletion) {
        let parameters = buildParameters(latitude: latitude, longitude: longitude, units: units, language: language)
        
        let cacheKey = "weather:\(latitude);\(longitude);\(language.rawValue);\(units.rawValue)"
        
        if let data = Cacher.persistent.fetchValue(ofType: Data.self, fromKey: cacheKey) {
            let response: Response = { return data }
            return handleWeatherResponse(response, cacheKey: cacheKey, cacheTime: 0, completion: completion)
        }

        GET(path: Constants.Paths.weather, parameters: parameters) { [weak self] (response) in
            guard let self = self else { return }
            self.handleWeatherResponse(response, cacheKey: cacheKey, cacheTime: cacheTime, completion: completion)
        }
    }
    
    func fetchForecast(latitude: Double,
                       longitude: Double,
                       units: Units,
                       language: Language,
                       cacheTime: TimeInterval,
                       completion: @escaping ForecastCompletion) {
        let parameters = buildParameters(latitude: latitude, longitude: longitude, units: units, language: language)
        
        let cacheKey = "forecast:\(latitude);\(longitude);\(language.rawValue);\(units.rawValue)"
        
        if let data = Cacher.persistent.fetchValue(ofType: Data.self, fromKey: cacheKey) {
            let response: Response = { return data }
            return handleForecastResponse(response, cacheKey: cacheKey, cacheTime: 0, completion: completion)
        }
        
        GET(path: Constants.Paths.forecast, parameters: parameters) { [weak self] (response) in
            guard let self = self else { return }
            self.handleForecastResponse(response, cacheKey: cacheKey, cacheTime: cacheTime, completion: completion)
        }
    }
}
