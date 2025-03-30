//
//  MovieTableViewCell.swift
//  HomeAssignment
//
//  Created by Hrishbha Jain on 29/03/25.
//

import UIKit
import SDWebImage
class MovieTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let releaseYearLabel = UILabel()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        // Add poster image view
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(posterImageView)

        // Add title label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        // Add release year label
        releaseYearLabel.font = UIFont.systemFont(ofSize: 14)
        releaseYearLabel.textColor = .gray
        releaseYearLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(releaseYearLabel)

        // Setup AutoLayout constraints
        NSLayoutConstraint.activate([
            // Poster image constraints
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title label constraints
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            // Release year label constraints
            releaseYearLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            releaseYearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            releaseYearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            releaseYearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Configure Cell with Movie Data
    func configure(with movie: MovieData) {
        titleLabel.text = movie.title
        releaseYearLabel.text = (movie.releaseDate ?? "").split(separator: "-").first.map { String($0) }

        if let posterPath = movie.posterPath {
            loadImage(from: posterPath)
        }
    }

    // MARK: - Load Image from URL
    private func loadImage(from posterPath: String) {
        // Assuming the image base URL is known
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let imageURLString = baseURL + posterPath
        guard let imageURL = URL(string: imageURLString) else { return }
        posterImageView.sd_setImage(with: imageURL)
        
    }
}
