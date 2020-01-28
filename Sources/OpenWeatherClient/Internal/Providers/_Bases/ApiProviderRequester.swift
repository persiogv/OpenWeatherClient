//
//  ApiProviderRequester.swift
//  OpenWeatherClient
//
//  Created by Pérsio on 26/04/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import Foundation

struct ApiProviderRequester {
    
    typealias Completion = (@escaping () throws -> Data?) -> Void

    private let client: ApiRequesterClient
    
    init(client: ApiRequesterClient = HTTPClient()) {
        self.client = client
    }
}

// MARK: - Api provider requester protocol
extension ApiProviderRequester: ApiProviderRequesterProtocol {
    
    func performRequest(url: URL,
                        method: HTTPClient.HTTPMethod,
                        body: Data?, headers: [HTTPClient.HTTPHeader],
                        completion: @escaping ApiProvider.Completion) {
        var request = URLRequest(url: url)
        
        headers.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.field)
        }
        
        request.httpBody = body
        request.httpMethod = method.rawValue
        
        client.request(with: request) { (result) in
            completion {
                guard let data = try result() else {
                    throw ApiProvider.ApiProviderError.invalidData
                }
                
                return data
            }
        }
    }
}

// MARK: - Helpful extension
extension HTTPClient: ApiRequesterClient {
    
    func request(with request: URLRequest, completion: @escaping ApiProviderRequester.Completion) {
        self.request(request: request) { (response) in
            completion {
                do {
                    let result = try response()
                    return result.data
                }
            }
        }
    }
}
