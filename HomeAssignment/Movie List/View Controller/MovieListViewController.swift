//
//  MovieListViewController.swift
//  HomeAssignment
//
//  Created by Hrishbha Jain on 30/03/25.
//

import UIKit

class MovieListViewController: UIViewController {

    private let movieViewModel = MovieViewModel()
    private let movieListView = MovieListView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let emptyStateLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(movieListView)
        movieListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieListView.topAnchor.constraint(equalTo: view.topAnchor),
            movieListView.leftAnchor.constraint(equalTo: view.leftAnchor),
            movieListView.rightAnchor.constraint(equalTo: view.rightAnchor),
            movieListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setupActivityIndicator()
        
        setupEmptyStateLabel()
        
        movieViewModel.delegate = self
        movieListView.delegate = self
        
        movieListView.isHidden = false
        emptyStateLabel.isHidden = true
        
        // Fetch initial movies
        movieViewModel.fetchMovies()
        
        // Show loading indicator when fetching data
        activityIndicator.startAnimating()

    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupEmptyStateLabel() {
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.textColor = .gray
        emptyStateLabel.font = UIFont.systemFont(ofSize: 16)
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func updateEmptyState() {
        let movies = movieViewModel.getMovies()
        
        if movies.isEmpty {
            if movieViewModel.isLoading {
                emptyStateLabel.text = "Loading..."
            } else if movieViewModel.errorOccurred {
                emptyStateLabel.text = "Failed to load movies. Please try again."
            } else {
                emptyStateLabel.text = "No movies found."
            }
            
            emptyStateLabel.isHidden = false
            movieListView.showNoResults()
        } else {
            emptyStateLabel.isHidden = true
            movieListView.showMovies(movies)
        }
    }

    

}

extension MovieListViewController: MovieViewModelDelegate {
    func didFetchMovies() {
        DispatchQueue.main.async{
            self.movieListView.setMovies(self.movieViewModel.getMovies())
            self.updateEmptyState()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func didFailWithError(_ error: String) {
        DispatchQueue.main.async{
            self.movieListView.setMovies([])
            self.updateEmptyState()
            self.activityIndicator.stopAnimating()
        }
    }
}

extension MovieListViewController: MovieListViewDelegate {
    func didScrollToBottom() {
        movieViewModel.fetchMovies()
    }
    
    func didSearchMovies(with query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else {
            print("Search query is empty. Ignoring request.")
            return
        }
        
        guard trimmedQuery.count <= 50 else {
            print("Search query too long. Please enter 50 characters or less.")
            return
        }
        
        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet.whitespaces)
        if trimmedQuery.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            print("Invalid characters in search query. Ignoring request.")
            return
        }
        movieViewModel.searchMovies(with: trimmedQuery)
    }
    
    
    func didSelectMovie(_ movie: MovieData) {
        let movieDetailVC = MovieDetailViewController(movie: movie)
        if let navigationController = self.navigationController {
            navigationController.pushViewController(movieDetailVC, animated: true)
        } else {
            print("Navigation controller is nil")
        }
    }
    
    func didClearSearch() {
        movieViewModel.fetchMovies()  
    }
}

