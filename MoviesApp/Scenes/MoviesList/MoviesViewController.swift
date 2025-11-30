//
//  MoviesVeiwController.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//

import UIKit
import Kingfisher
import Combine

final class MoviesViewController: UIViewController {

    private let tableView = UITableView()
    private let viewModel: MoviesListViewModel

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Best Movies 2024"
        view.backgroundColor = .systemBackground

        setupTableView()
        bindViewModel()
        viewModel.loadFirstPage()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(MovieTableViewCell.self,
                           forCellReuseIdentifier: MovieTableViewCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
    }

    private func bindViewModel() {
        // Movies -> reload table
        viewModel.$movies
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        // Errors -> show alert
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                let alert = UIAlertController(title: "Error",
                                              message: message,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }
}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let movie = viewModel.movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.reuseId,
            for: indexPath
        ) as! MovieTableViewCell

        let url = viewModel.imageURL(for: movie)
        cell.configure(with: movie, imageURL: url)

        cell.onFavoriteTapped = { [weak self] in
            self?.viewModel.toggleFavorite(at: indexPath.row)
        }

        viewModel.loadNextPageIfNeeded(currentRow: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let movie = viewModel.movies[indexPath.row]
        let detailVM = MovieDetailViewModel(
            movieId: movie.id,
            repository: viewModel.repository,
            client: viewModel.client
        )
        let vc = MovieDetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(vc, animated: true)
    }
}

