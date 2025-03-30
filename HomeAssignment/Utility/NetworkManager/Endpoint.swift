//
//  Endpoint.swift
//  HomeAssignment
//
//  Created by Hrishbha Jain on 29/03/25.
//

import Foundation

enum AppEnvironment {
    
    static let baseURL = "https://api.themoviedb.org/3"
    
}

enum EndPoint : String {
    case movies = "/movie/popular"
}

