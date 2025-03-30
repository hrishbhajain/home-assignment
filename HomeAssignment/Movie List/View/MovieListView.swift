//
//  MovieListView.swift
//  HomeAssignment
//
//  Created by Hrishbha Jain on 29/03/25.
//

import UIKit

protocol MovieListViewDelegate: AnyObject {
    func didScrollToBottom()
    func didSelectMovie(_ movie: MovieData)
    func didSearchMovies(with query: String)
    func didClearSearch()
}

class MovieListView: UIView {
    
    weak var delegate: MovieListViewDelegate?
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    private var movies: [MovieData] = []
    
    var movieCellIdentifier: String {
        return "MovieCell"
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        searchBar.placeholder = "Search Movies"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: movieCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [searchBar, tableView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    // MARK: - Data Handling
    
    func setMovies(_ movies: [MovieData]) {
        self.movies = movies
        self.tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - scrollViewHeight * 2 {
            delegate?.didScrollToBottom()
        }
    }
    
    func showNoResults() {
        tableView.isHidden = false
        movies = []
        tableView.reloadData()
    }
    
    func showMovies(_ movies: [MovieData]) {
        self.movies = movies
        tableView.isHidden = false
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MovieListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieCellIdentifier, for: indexPath) as! MovieTableViewCell
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        delegate?.didSelectMovie(selectedMovie)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - UISearchBarDelegate
extension MovieListView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let trimmedQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedQuery.isEmpty {
            delegate?.didClearSearch() 
        } else {
            delegate?.didSearchMovies(with: trimmedQuery)
        }
    }
}
