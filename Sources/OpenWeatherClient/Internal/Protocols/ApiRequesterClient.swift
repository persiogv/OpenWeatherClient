//
//  ApiRequesterClient.swift
//  OpenWeatherClient
//
//  Created by Pérsio on 28/04/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import Foundation

protocol ApiRequesterClient {
    
    /// Performs an Api request using a given URLRequest
    ///
    /// - Parameters:
    ///   - request: Your URLRequest
    ///   - completion: A closure called when the request is finished
    func request(with request: URLRequest, completion: @escaping ApiProviderRequester.Completion)
}
