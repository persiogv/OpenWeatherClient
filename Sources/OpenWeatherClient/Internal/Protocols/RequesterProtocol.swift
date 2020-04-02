//
//  RequesterProtocol.swift
//  OpenWeatherClient
//
//  Created by Pérsio on 26/04/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import Foundation

protocol RequesterProtocol {
    
    /// Preforms an HTTP request
    ///
    /// - Parameters:
    ///   - url: The target url
    ///   - method: HTTP method
    ///   - body: Optional data to send within the request
    ///   - headers: HTTP headers
    ///   - completion: Callback completion handler
    func performRequest(url: URL,
                        method: HTTPClient.Method,
                        body: Data?,
                        headers: [HTTPClient.Header],
                        completion: @escaping ApiProvider.Completion)
}
