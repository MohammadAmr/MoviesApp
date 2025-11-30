//
//  MovieTableViewCell.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//

import UIKit
import Kingfisher

final class MovieTableViewCell: UITableViewCell {
    static let reuseId = "MovieTableViewCell"

    // MARK: - Callbacks
    var onFavoriteTapped: (() -> Void)?

    // MARK: - UI

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .secondarySystemBackground
        v.layer.cornerRadius = 16
        v.layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
        v.layer.shadowOpacity = 1
        v.layer.shadowRadius = 8
        v.layer.shadowOffset = CGSize(width: 0, height: 4)
        return v
    }()

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .tertiarySystemFill
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 17, weight: .semibold)
        l.numberOfLines = 2
        return l
    }()

    private let ratingLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .medium)
        return l
    }()

    private let dateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        return l
    }()

    let favoriteButton: UIButton = {
        let b = UIButton(type: .system)
        b.tintColor = .systemRed
        b.setImage(UIImage(systemName: "heart"), for: .normal)
        b.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        b.layer.cornerRadius = 16
        b.layer.masksToBounds = true
        b.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return b
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        favoriteButton.addTarget(self, action: #selector(favoritePressed), for: .touchUpInside)
        selectionStyle = .none
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = UIImage(systemName: "photo")
        titleLabel.text = nil
        ratingLabel.text = nil
        dateLabel.text = nil
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }

    // MARK: - Layout

    private func setupUI() {
        contentView.backgroundColor = .systemBackground

        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        cardView.addSubview(posterImageView)
        cardView.addSubview(favoriteButton)

        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        let ratingIcon = UIImageView(image: UIImage(systemName: "star.fill"))
        ratingIcon.tintColor = .systemYellow
        ratingIcon.translatesAutoresizingMaskIntoConstraints = false

        let dateIcon = UIImageView(image: UIImage(systemName: "calendar"))
        dateIcon.tintColor = .secondaryLabel
        dateIcon.translatesAutoresizingMaskIntoConstraints = false

        let ratingStack = UIStackView(arrangedSubviews: [ratingIcon, ratingLabel])
        ratingStack.axis = .horizontal
        ratingStack.spacing = 4
        ratingStack.alignment = .center

        let dateStack = UIStackView(arrangedSubviews: [dateIcon, dateLabel])
        dateStack.axis = .horizontal
        dateStack.spacing = 4
        dateStack.alignment = .center

        let infoStack = UIStackView(arrangedSubviews: [titleLabel, ratingStack, dateStack])
        infoStack.axis = .vertical
        infoStack.spacing = 6
        infoStack.alignment = .leading

        cardView.addSubview(infoStack)
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Poster
            posterImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            posterImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            posterImageView.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -10),

            // Info stack
            infoStack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            infoStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            infoStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            infoStack.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -12),

            // Favorite
            favoriteButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 32),
            favoriteButton.heightAnchor.constraint(equalToConstant: 32),

            ratingIcon.widthAnchor.constraint(equalToConstant: 14),
            ratingIcon.heightAnchor.constraint(equalToConstant: 14),
            dateIcon.widthAnchor.constraint(equalToConstant: 14),
            dateIcon.heightAnchor.constraint(equalToConstant: 14)
        ])

        cardView.bringSubviewToFront(favoriteButton)
    }

    // MARK: - Configure

    func configure(with movie: Movie, imageURL: URL?) {
        titleLabel.text = movie.title

        if let rating = movie.voteAverage {
            ratingLabel.text = String(format: "%.1f", rating)
        } else {
            ratingLabel.text = "N/A"
        }

        dateLabel.text = movie.releaseDate ?? "Unknown"

        let heartName = movie.isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: heartName), for: .normal)

        if let url = imageURL {
            posterImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo"),
                options: [.transition(.fade(0.2))]
            )
        } else {
            posterImageView.image = UIImage(systemName: "photo")
        }
    }

    // MARK: - Actions

    @objc private func favoritePressed() {
        onFavoriteTapped?()
    }
}
