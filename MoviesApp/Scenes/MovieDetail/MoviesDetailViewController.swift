//
//  MoviesDetailViewController.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//

import UIKit
import Kingfisher
import Combine

final class MovieDetailViewController: UIViewController {

    private let viewModel: MovieDetailViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let headerContainerView = UIView()
    private let backdropImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .tertiarySystemFill
        return iv
    }()

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.separator.cgColor
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemRed
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.85)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return button
    }()

    // Info chips
    private let ratingChip = InfoChipView(iconName: "star.fill", tintColor: .systemYellow)
    private let dateChip = InfoChipView(iconName: "calendar", tintColor: .systemBlue)
    private let languageChip = InfoChipView(iconName: "globe", tintColor: .systemGreen)

    // Section title
    private let overviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
        viewModel.load()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addGradientToHeader()
    }

    // MARK: - Setup UI

    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .never

        // Scroll view
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        // Header
        contentView.addSubview(headerContainerView)
        headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        headerContainerView.addSubview(backdropImageView)
        backdropImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerContainerView.heightAnchor.constraint(equalToConstant: 220),

            backdropImageView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            backdropImageView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor)
        ])

        // Poster overlapping header bottom
        contentView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -60),
            posterImageView.widthAnchor.constraint(equalToConstant: 120),
            posterImageView.heightAnchor.constraint(equalToConstant: 180)
        ])

        // Title + favorite row
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: favoriteButton.leadingAnchor, constant: -8),

            favoriteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        // Chips stack
        let chipsStack = UIStackView(arrangedSubviews: [ratingChip, dateChip, languageChip])
        chipsStack.axis = .horizontal
        chipsStack.spacing = 8
        chipsStack.alignment = .leading
        chipsStack.distribution = .fillProportionally

        contentView.addSubview(chipsStack)
        chipsStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            chipsStack.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            chipsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            chipsStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16)
        ])

        // Overview section
        let overviewStack = UIStackView(arrangedSubviews: [overviewTitleLabel, overviewLabel])
        overviewStack.axis = .vertical
        overviewStack.spacing = 8
        overviewStack.alignment = .fill

        contentView.addSubview(overviewStack)
        overviewStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            overviewStack.topAnchor.constraint(equalTo: chipsStack.bottomAnchor, constant: 20),
            overviewStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            overviewStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            overviewStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    // MARK: - Gradient on header

    private func addGradientToHeader() {
        // Remove old gradient
        headerContainerView.layer.sublayers?
            .filter { $0.name == "backdropGradient" }
            .forEach { $0.removeFromSuperlayer() }

        let gradient = CAGradientLayer()
        gradient.name = "backdropGradient"
        gradient.frame = headerContainerView.bounds
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.45).cgColor,
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradient.locations = [0.0, 0.4, 1.0]
        headerContainerView.layer.insertSublayer(gradient, above: backdropImageView.layer)
    }

    // MARK: - Bindings

    private func bindViewModel() {
        viewModel.$detail
            .receive(on: RunLoop.main)
            .sink { [weak self] detail in
                guard let self, let detail = detail else { return }
                self.updateUI(with: detail)
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self else { return }
                let alert = UIAlertController(title: "Error",
                                              message: message,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }


    private func updateUI(with detail: MovieDetail) {
        titleLabel.text = detail.title

        if let vote = detail.voteAverage {
            ratingChip.setText(String(format: "%.1f", vote))
        } else {
            ratingChip.setText("N/A")
        }

        dateChip.setText(detail.releaseDate ?? "Unknown")
        languageChip.setText(detail.originalLanguage?.uppercased() ?? "N/A")

        overviewLabel.text = detail.overview?.isEmpty == false
            ? detail.overview
            : "No overview available."

        // Favorite state
        let heartName = detail.isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: heartName), for: .normal)

        // Images
        if let url = viewModel.posterURL() {
            posterImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo"),
                options: [.transition(.fade(0.2))]
            )
        } else {
            posterImageView.image = UIImage(systemName: "photo")
        }

        if let detailBackdropPath = detail.backdropPath,
           let backdropURL = URL(string: "https://image.tmdb.org/t/p/w780\(detailBackdropPath)") {
            backdropImageView.kf.setImage(
                with: backdropURL,
                placeholder: UIImage(systemName: "photo"),
                options: [.transition(.fade(0.25))]
            )
        } else if let url = viewModel.posterURL() {
            backdropImageView.kf.setImage(with: url)
        } else {
            backdropImageView.image = nil
        }
    }

    // MARK: - Actions

    @objc private func favoriteTapped() {
        viewModel.toggleFavorite()
    }
}
