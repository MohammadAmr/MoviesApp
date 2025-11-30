//
//  MoviesListViewModel.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//

import Foundation
import Combine

@MainActor
final class MoviesListViewModel {

    let repository: MoviesRepositoryType
    let client: TMDBClient

    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var currentPage = 1
    private var totalPages = 1
    private var loadingPage = false

    private var cancellables = Set<AnyCancellable>()

    init(repository: MoviesRepositoryType, client: TMDBClient) {
        self.repository = repository
        self.client = client

        observeFavoriteChanges()
    }

    private func observeFavoriteChanges() {
        repository.favoriteChanges
            .receive(on: RunLoop.main)
            .sink { [weak self] (movieId, isFav) in
                guard let self = self else { return }
                guard let index = self.movies.firstIndex(where: { $0.id == movieId }) else { return }
                var updated = self.movies[index]
                updated.isFavorite = isFav
                self.movies[index] = updated
            }
            .store(in: &cancellables)
    }

    func imageURL(for movie: Movie) -> URL? {
        client.imageURL(path: movie.posterPath)
    }

    // MARK: - Paging

    func loadFirstPage() {
        currentPage = 1
        totalPages = 1
        movies = []
        loadPage(1)
    }

    func loadNextPageIfNeeded(currentRow: Int) {
        let threshold = movies.count - 5
        if currentRow >= threshold,
           currentPage < totalPages,
           !loadingPage {
            loadPage(currentPage + 1)
        }
    }

    private func loadPage(_ page: Int) {
        guard !loadingPage else { return }
        loadingPage = true
        isLoading = true

        Task {
            do {
                let result = try await repository.fetchBestMovies2024(page: page)
                currentPage = page
                totalPages = result.totalPages
                if page == 1 {
                    movies = result.movies
                } else {
                    movies += result.movies
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            loadingPage = false
            isLoading = false
        }
    }

    func toggleFavorite(at index: Int) {
        guard movies.indices.contains(index) else { return }
        var movie = movies[index]
        let newValue = !movie.isFavorite
        movie.isFavorite = newValue
        movies[index] = movie
        let movieId = movie.id

        Task {
            do {
                _ = try await repository.toggleFavorite(movieId: movieId)
            } catch {
                var rollback = movie
                rollback.isFavorite.toggle()
                if let rollbackIndex = movies.firstIndex(where: { $0.id == rollback.id }) {
                    movies[rollbackIndex] = rollback
                }
                errorMessage = error.localizedDescription
            }
        }
    }

}
