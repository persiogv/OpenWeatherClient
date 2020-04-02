//
//  Requester.swift
//  OpenWeatherClient
//
//  Created by Pérsio on 26/04/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import Foundation

struct Requester {
    
    private let client: ApiRequesterClient
    
    init(client: ApiRequesterClient = HTTPClient()) {
        self.client = client
    }
}

// MARK: - Api provider requester protocol
extension Requester: RequesterProtocol {
    
    func performRequest(url: URL,
                        method: HTTPClient.Method,
                        body: Data?, headers: [HTTPClient.Header],
                        completion: @escaping ApiProvider.Completion) {
        var request = URLRequest(url: url)
        
        headers.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.field)
        }
        
        request.httpBody = body
        request.httpMethod = method.rawValue
        
        client.request(with: request) { result in
            switch result {
            case .success(let data):
                return completion(.success(data))
            case .failure:
                return completion(.failure(ApiProvider.ApiProviderError.invalidData))
            }
        }
    }
}

// MARK: - Helpful extension
extension HTTPClient: ApiRequesterClient {
    
    func request(with request: URLRequest, completion: @escaping ApiProvider.Completion) {
        self.request(request: request) { result in
            switch result {
            case .success(let response):
                return completion(.success(response.data))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}
