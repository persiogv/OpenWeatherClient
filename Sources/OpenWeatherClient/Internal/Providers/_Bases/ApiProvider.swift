//
//  ApiProvider.swift
//  OpenWeatherClient
//
//  Created by Pérsio on 16/03/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import Foundation

class ApiProvider {
    
    typealias ApiResult = Result<Data, Error>
    typealias Completion = (ApiResult) -> Void
    typealias Parameter = (name: String, value: String)
    
    enum ApiProviderError: Error {
        case invalidUrl
        case invalidData
        case unhandled(error: Error)
    }
    
    private let requester: RequesterProtocol
    private let baseUrl: String
    
    init(requester: RequesterProtocol = Requester(), baseUrl: String) {
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
    func GET(path: String, body: Data?, headers: [HTTPClient.Header], parameters: [Parameter], completion: @escaping ApiProvider.Completion) {
        var components = URLComponents(string: baseUrl.appending(path))
        var queryItems: [URLQueryItem] = []
        
        parameters.forEach { parameter in
            let queryItem = URLQueryItem(name: parameter.name, value: parameter.value)
            queryItems.append(queryItem)
        }
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            return completion(.failure(ApiProviderError.invalidUrl))
        }
        
        requester.performRequest(url: url, method: .GET, body: body, headers: headers) { [weak self] result in
            guard let self = self else { return }
            self.handleResult(result: result, completion: completion)
        }
    }
    
    /// POST
    ///
    /// - Parameters:
    ///   - path: The path of the service
    ///   - body: Optional data to send within the request
    ///   - headers: HTTPHeaders
    ///   - completion: Callback completion handler
    func POST(path: String, body: Data?, headers: [HTTPClient.Header], completion: @escaping Completion) {
        guard let url = URL(string: baseUrl.appending(path)) else {
            return completion(.failure(ApiProviderError.invalidUrl))
        }
        
        requester.performRequest(url: url, method: .POST, body: body, headers: headers) { [weak self] result in
            guard let self = self else { return }
            self.handleResult(result: result, completion: completion)
        }
    }
}

// MARK: - Private
private extension ApiProvider {
    
    func handleResult(result: ApiResult, completion: @escaping Completion) {
        switch result {
        case .success(let data):
            return completion(.success(data))
        case .failure(let error):
            return completion(.failure(error))
        }
    }
}
