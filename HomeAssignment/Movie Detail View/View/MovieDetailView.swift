//
//  MovieDetailView.swift
//  HomeAssignment
//
//  Created by Hrishbha Jain on 29/03/25.
//

import UIKit
import SDWebImage

class MovieDetailView: UIView {

    // MARK: - UI Elements
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let releaseYearLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let ratingLabel = UILabel()


    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .white

        // Poster Image View
        posterImageView.contentMode = .scaleToFill
        posterImageView.clipsToBounds = true
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(posterImageView)

        // Title Label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        // Release Year Label
        releaseYearLabel.font = UIFont.systemFont(ofSize: 18)
        releaseYearLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(releaseYearLabel)

        // Description Label
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)

        // Rating Label
        ratingLabel.font = UIFont.systemFont(ofSize: 16)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ratingLabel)

        // Set up constraints
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Poster Image (Now respects the safe area)
            posterImageView.heightAnchor.constraint(equalToConstant: 300),
            posterImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            // Title Label
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            // Release Year Label
            releaseYearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            releaseYearLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            releaseYearLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: releaseYearLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            // Rating Label
            ratingLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }


    // MARK: - Configure the View
    func configure(with movie: MovieData, isFavorite: Bool) {
        titleLabel.text = movie.title
        releaseYearLabel.text = "Release Year: \((movie.releaseDate ?? "").split(separator: "-").first ?? "N/A")"
        descriptionLabel.text = movie.overview
        if let rating = movie.voteAverage {
            ratingLabel.text = "Rating: \(rating)"
        }

        if let posterPath = movie.posterPath {
            let baseURL = "https://image.tmdb.org/t/p/w500"
            if let imageURL = URL(string: baseURL + posterPath) {
                posterImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"))
            }
        }
    }
}
