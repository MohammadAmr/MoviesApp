//
//  MovieDetailViewModel.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//

import Foundation
import Combine

@MainActor
final class MovieDetailViewModel {

    private let repository: MoviesRepositoryType
    private let client: TMDBClient
    private let movieId: Int

    @Published var detail: MovieDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init(movieId: Int, repository: MoviesRepositoryType, client: TMDBClient) {
        self.movieId = movieId
        self.repository = repository
        self.client = client

        observeFavoriteChanges()
    }

    private func observeFavoriteChanges() {
        repository.favoriteChanges
            .filter { [weak self] (id, _) in id == self?.movieId }
            .receive(on: RunLoop.main)
            .sink { [weak self] (_, isFav) in
                guard let self = self, var current = self.detail else { return }
                current.isFavorite = isFav
                self.detail = current
            }
            .store(in: &cancellables)
    }

    func load() {
        isLoading = true
        Task {
            do {
                let data = try await repository.fetchMovieDetail(id: movieId)
                detail = data
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func toggleFavorite() {
        Task {
            do {
                _ = try await repository.toggleFavorite(movieId: movieId)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func posterURL() -> URL? {
        client.imageURL(path: detail?.posterPath)
    }
}

