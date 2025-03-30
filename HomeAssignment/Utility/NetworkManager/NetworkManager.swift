//
//  NetworkManager.swift
//  HomeAssignment
//
//  Created by Hrishbha Jain on 29/03/25.
//

import Foundation

typealias JSONDictionary = [String: Any]

// Define HTTPMethod enum
enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

// Define a NetworkManager class
class NetworkManager {
    static let shared = NetworkManager()
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: EndPoint, method: HTTPMethod = .GET, parameters: JSONDictionary? = nil, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard let request = urlRequest(for: endpoint, method: method, parameters: parameters) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
            }
        }
        
        task.resume()
    }
    
    
    private func urlRequest(for endpoint: EndPoint, method: HTTPMethod, parameters: JSONDictionary?) -> URLRequest? {
        guard let fullUrl = URL(string: AppEnvironment.baseURL + endpoint.rawValue) else {return nil}
        var urlComponents = URLComponents(url: fullUrl, resolvingAgainstBaseURL: false)
        
        if method == .GET, let params = parameters {
            urlComponents?.queryItems = params.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        guard let url = urlComponents?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if method == .POST || method == .PUT || method == .PATCH, let params = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
                print("Error encoding parameters: \(error)")
                return nil
            }
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {} 
