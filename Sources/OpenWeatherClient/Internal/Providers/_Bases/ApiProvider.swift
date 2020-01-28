//
//  ApiProvider.swift
//  OpenWeatherClient
//
//  Created by Pérsio on 16/03/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import Foundation

class ApiProvider {
    
    typealias Response = () throws -> Data
    typealias Completion = (@escaping Response) -> Void
    typealias Parameter = (name: String, value: String)
    
    enum ApiProviderError: Error {
        case invalidUrl
        case invalidData
        case unhandled(error: Error)
    }
    
    private let requester: ApiProviderRequesterProtocol
    private let baseUrl: String
    
    init(requester: ApiProviderRequesterProtocol = ApiProviderRequester(), baseUrl: String) {
        self.requester = requester
        self.baseUrl = baseUrl
    }
    
    /// GET
    ///
    /// - Parameters:
    ///   - path: The path of the service
    ///   - body: Optional data to send within the request
    ///   - headers: HTTP headers
    ///   - parameters: Parameters to send within the request
    ///   - completion: Callback completion handler
    func GET(path: String, body: Data?, headers: [HTTPClient.HTTPHeader], parameters: [Parameter], completion: @escaping Completion) {
        var components = URLComponents(string: baseUrl.appending(path))
        var queryItems: [URLQueryItem] = []
        
        parameters.forEach { parameter in
            let queryItem = URLQueryItem(name: parameter.name, value: parameter.value)
            queryItems.append(queryItem)
        }
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            return completion {
                throw ApiProviderError.invalidUrl
            }
        }
        
        requester.performRequest(url: url, method: HTTPClient.HTTPMethod.GET, body: body, headers: headers) { [weak self] (response) in
            guard let self = self else { return }
            self.handleResponse(response: response, completion: completion)
        }
    }
    
    /// POST
    ///
    /// - Parameters:
    ///   - path: The path of the service
    ///   - body: Optional data to send within the request
    ///   - headers: HTTPHeaders
    ///   - completion: Callback completion handler
    func POST(path: String, body: Data?, headers: [HTTPClient.HTTPHeader], completion: @escaping Completion) {
        guard let url = URL(string: baseUrl.appending(path)) else {
            return completion {
                throw ApiProviderError.invalidUrl
            }
        }
        
        requester.performRequest(url: url, method: HTTPClient.HTTPMethod.POST, body: body, headers: headers) { [weak self] (response) in
            guard let self = self else { return }
            self.handleResponse(response: response, completion: completion)
        }
    }
}

// MARK: - Private
private extension ApiProvider {
    
    func handleResponse(response: @escaping Response, completion: @escaping Completion) {
        completion {
            do {
                return try response()
            } catch let error as HTTPClient.HTTPClientError {
                switch error {
                case .unhandled(let error):
                    throw ApiProviderError.unhandled(error: error)
                default:
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
}
