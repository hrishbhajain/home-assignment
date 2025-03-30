//
//  MovieViewModel.swift
//  HomeAssignment
//
//  Created by Hrishbha Jain on 29/03/25.
//

import Foundation
protocol MovieViewModelDelegate: AnyObject {
    func didFetchMovies()
    func didFailWithError(_ error: String)
}

class MovieViewModel {
    
    var allMovies: [MovieData] = []
    var filteredMovies: [MovieData] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?
    var errorOccurred = false // To track if an error occurred during fetching
    private var page : Int = 1
    private var totalPages : Int = 1
    
    // Closure to bind the UI for movies
    var moviesDidUpdate: (() -> Void)?
    var loadingStateDidUpdate: (() -> Void)?
    
    weak var delegate: MovieViewModelDelegate?
    
    var params : JSONDictionary {
        var dict : JSONDictionary = [:]
        dict["api_key"] = Constants.tmdbApiKey
        dict["page"] = page
        return dict
    }
    
    // Fetch movies from the API
    func fetchMovies(reset: Bool = false) {
        // Prevent duplicate requests
        guard !isLoading, page <= totalPages else { return }
        
        isLoading = true
        errorOccurred = false
        loadingStateDidUpdate?()
        
        if reset {
            page = 1
            allMovies.removeAll()
        }
        
        NetworkManager.shared.request(.movies, method: .GET, parameters: params) { (result: Result<MovieResponse, NetworkError>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.totalPages = response.totalPages ?? 1
                    self.allMovies.append(contentsOf: response.results ?? [])
                    self.filteredMovies = self.allMovies
                    self.errorOccurred = false
                    self.delegate?.didFetchMovies()
                    self.page += 1
                case .failure:
                    self.errorOccurred = true
                    self.delegate?.didFailWithError("Network request failed.")
                }
            }
        }
        
    }
    
    func searchMovies(with query: String) {
        if query.isEmpty {
            filteredMovies = allMovies
        } else {
            filteredMovies = allMovies.filter { ($0.title ?? "").lowercased().contains(query.lowercased()) }
        }
        delegate?.didFetchMovies()
    }
    
    func getMovies() -> [MovieData] {
        return filteredMovies
    }
    
}
