//
//  NetworkError.swift
//  HomeAssignment
//
//  Created by Hrishbha Jain on 29/03/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case httpError(statusCode: Int)
    case noData
    case decodingError(Error)
}
