//
//  MovieDetailViewController.swift
//  HomeAssignment
//
//  Created by Hrishbha Jain on 29/03/25.
//

import UIKit
import CoreData

class MovieDetailViewController: UIViewController {

    private let movieDetailView = MovieDetailView()
    private var movie: MovieData
    private var isFavorite: Bool = false
    private var favoriteButton: UIBarButtonItem!


    init(movie: MovieData) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.backgroundColor = .white
        view.addSubview(movieDetailView)
        movieDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), // ✅ Safe area
            movieDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        loadData()
    }
    
    private func setupNavigationBar() {
        favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(toggleFavorite)
        )
        self.navigationItem.rightBarButtonItem = favoriteButton
        navigationController?.navigationBar.isTranslucent = false

    }

    private func loadData() {
        updateFavoriteButton()
        movieDetailView.configure(with: movie, isFavorite: isFavorite)
    }

    @objc private func toggleFavorite() {
        if DBManager.shared.isMovieFavorited(id: Int64(movie.id ?? 0)) {
            DBManager.shared.removeFromFavorites(id: Int64(movie.id ?? 0))
        }else {
            DBManager.shared.addToFavorites(title: movie.title ?? "", id: Int64(movie.id ?? 0))
        }
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        isFavorite = DBManager.shared.isMovieFavorited(id: Int64(movie.id ?? 0))
        let heartIcon = isFavorite ? "heart.fill" : "heart"
        favoriteButton.image = UIImage(systemName: heartIcon)
    }
}

