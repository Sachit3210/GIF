//
//  APIResources.swift
//  Gitfs
//
//  Created by Sagar Arora on 18/05/23.
//

import Foundation

import Foundation

class APIResources {
    typealias CompletionHandler = (Result<Data, Error>) -> Void
    static let shared = APIResources()
    private init() {
        
    }
    
    
    func makeRequest(urlString: String, method: String, headers: [String: String]? = nil, body: Data? = nil, completionHandler: @escaping CompletionHandler) {
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // Set request headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Set request body
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(NSError(domain: "Invalid HTTP response", code: 0, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                completionHandler(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)))
                return
            }
            
            completionHandler(.success(data))
        }
        
        task.resume()
    }
}

