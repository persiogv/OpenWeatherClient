//
//  HTTPClient.swift
//  https://github.com/persiogv/HTTPClient
//
//  Created by Pérsio on 09/03/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import Foundation

struct HTTPClient {
    
    typealias Completion = (@escaping () throws -> (data: Data?, response: URLResponse)) -> Void
    typealias HTTPHeader = (field: String, value: String)
    
    enum HTTPMethod: String {
        case GET
        case POST
        case HEAD
        case PUT
        case DELETE
    }
    
    enum HTTPClientError: Error {
        case invalidMethod
        case invalidResponse
        case noInternetConnection
        case serverError(code: Int, data: Data?)
        case unhandled(error: Error)
    }
}

// MARK: - Request stack
extension HTTPClient {
    
    /// Performs an HTTP request using a given URLRequest
    ///
    /// - Parameters:
    ///   - request: Your URLRequest
    ///   - session: Your URLSession, optional
    ///   - completion: A closure called when the request is finished
    func request(request: URLRequest, session: URLSession = URLSession.shared, completion: @escaping Completion) {
        performRequest(session: session, request: request, completion: completion)
    }
    
    /// Performs an HTTP request using a given URL and HTTP method
    ///
    /// - Parameters:
    ///   - url: The URL to be requested
    ///   - method: The HTTP request method
    ///   - session: Your URLSession, optional
    ///   - body: A data to be sent as the request body, optional
    ///   - headers: Your HTTP headers, optional
    ///   - completion: A closure called when the request is finished
    func request(url: URL,
                 method: HTTPMethod,
                 session: URLSession = URLSession.shared,
                 body: Data? = nil,
                 headers: [HTTPHeader]? = nil,
                 completion: @escaping Completion) {
        let request = URLRequest(url: url, method: method, body: body, headers: headers)
        
        performRequest(session: session, request: request, completion: completion)
    }
}

// MARK: - Upload stack
extension HTTPClient {
    
    /// Performs an HTTP file upload using a given URLRequest
    ///
    /// - Parameters:
    ///   - request: Your URLRequest
    ///   - data: The data of the file to be uploaded
    ///   - session: Your URLSession, optional
    ///   - completion: A closure called when the upload is finished
    func upload(request: URLRequest,
                data: Data,
                session: URLSession = URLSession.shared,
                completion: @escaping Completion) {
        let task = session.uploadTask(with: request, from: data) { (data, response, error) in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        
        task.resume()
    }
    
    /// Performs an HTTP file upload using a given URL and HTTP method
    ///
    /// - Parameters:
    ///   - url: The URL to send the file
    ///   - method: The HTTP request method, should not be different of POST or PUT
    ///   - data: The data of the file to be uploaded
    ///   - session: Your URLSession, optional
    ///   - completion: A closure called when the upload is finished
    func upload(url: URL,
                method: HTTPMethod,
                data: Data,
                session: URLSession = URLSession.shared,
                completion: @escaping Completion) {
        if method != .POST || method != .PUT {
            return completion {
                throw HTTPClientError.invalidMethod
            }
        }
        
        let request = URLRequest(url: url, method: method, body: nil, headers: nil)
        let task = session.uploadTask(with: request, from: data) { (data, response, error) in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        
        task.resume()
    }
    
    /// Performs an HTTP file upload using a given URLRequest and URLSession
    ///
    /// - Parameters:
    ///   - request: Your URLRequest
    ///   - data: The data of the file to be uploaded
    ///   - session: Your URLSession (you must adopt its delegate protocols to get notified)
    func upload(request: URLRequest, data: Data, session: URLSession) {
        let task = session.uploadTask(with: request, from: data)
        
        task.resume()
    }
    
    /// Performs an HTTP file upload using a given URL, HTTP method, and URLSession
    ///
    /// - Parameters:
    ///   - url: The URL to send the file
    ///   - method: The HTTP request method, should not be different of POST or PUT
    ///   - data: The data of the file to be upladed
    ///   - session: Your URLSession (you must adopt its delegate protocols to get notified)
    /// - Throws: An error will be thrown if the given method is different of POST or PUT
    func upload(url: URL,
                method: HTTPMethod,
                data: Data,
                session: URLSession) throws {
        if method != .POST || method != .PUT {
            throw HTTPClientError.invalidMethod
        }
        
        let request = URLRequest(url: url, method: method, body: nil, headers: nil)
        let task = session.uploadTask(with: request, from: data)
        
        task.resume()
    }
}

// MARK: - Download stack
extension HTTPClient {
    
    /// Performs an HTTP file download using a given URLRequest
    ///
    /// - Parameters:
    ///   - request: Your URLRequest
    ///   - session: Your URLSession, optional
    ///   - completion: A closure called when the download is finished
    func download(request: URLRequest, session: URLSession = URLSession.shared, completion: @escaping Completion) {
        let task = session.downloadTask(with: request) { (_, response, error) in
            self.handleResponse(data: nil, response: response, error: error, completion: completion)
        }
        
        task.resume()
    }
    
    /// Performs an HTTP file download using a given URL
    ///
    /// - Parameters:
    ///   - url: The URL that contains the file to be downloaded
    ///   - session: Your URLSession, optional
    ///   - completion: A closure called when the download is finished
    func download(url: URL, session: URLSession = URLSession.shared, completion: @escaping Completion) {
        let request = URLRequest(url: url, method: nil, body: nil, headers: nil)
        let task = session.downloadTask(with: request) { (_, response, error) in
            self.handleResponse(data: nil, response: response, error: error, completion: completion)
        }
        
        task.resume()
    }
    
    /// Performs an HTTP file download using a given URLRequest and URLSession
    ///
    /// - Parameters:
    ///   - request: Your URLRequest
    ///   - session: Your URLSession (you must adopt its delegate protocols to get notified)
    func download(request: URLRequest, session: URLSession) {
        let task = session.downloadTask(with: request)
        
        task.resume()
    }
    
    /// Performs an HTTP file download using a given URL and URLSession
    ///
    /// - Parameters:
    ///   - url: The URL that contains the file to be downloaded
    ///   - session: Your URLSession (you must adopt its delegate protocols to get notified)
    func download(url: URL, session: URLSession) {
        let request = URLRequest(url: url, method: nil, body: nil, headers: nil)
        let task = session.downloadTask(with: request)
        
        task.resume()
    }
}

// MARK: - Helpful extensions
private extension HTTPClient {
    
    func performRequest(session: URLSession, request: URLRequest, completion: @escaping Completion) {
        let task = session.dataTask(with: request) { (data, response, error) in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        
        task.resume()
    }
    
    func handleResponse(data: Data?,
                        response: URLResponse?,
                        error: Error?,
                        completion: Completion) {
        guard let error = error else {
            guard case let response as HTTPURLResponse = response else {
                return completion {
                    throw HTTPClientError.invalidResponse
                }
            }
            
            if 200...299 ~= response.statusCode {
                return completion {
                    return (data, response)
                }
            }
            
            return completion {
                throw HTTPClientError.serverError(code: response.statusCode, data: data)
            }
        }
        
        completion {
            if let error = error as? URLError {
                if error.code == .networkConnectionLost || error.code == .notConnectedToInternet {
                    throw HTTPClientError.noInternetConnection
                }
            }
            throw HTTPClientError.unhandled(error: error)
        }
    }
}

private extension URLRequest {
    
    init(url: URL, method: HTTPClient.HTTPMethod?, body: Data?, headers: [HTTPClient.HTTPHeader]?) {
        self.init(url: url)
        self.httpMethod = method?.rawValue
        self.httpBody = body
        
        if let headers = headers {
            headers.forEach({ (header) in
                self.setValue(header.value, forHTTPHeaderField: header.field)
            })
        }
    }
}
