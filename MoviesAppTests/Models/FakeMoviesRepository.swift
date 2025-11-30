//
//  FakeMoviesRepository.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//

import XCTest
import Combine
@testable import MoviesApp

final class FakeMoviesRepository: MoviesRepositoryType {
    private let favoriteChangesSubject = PassthroughSubject<(Int, Bool), Never>()
    var favoriteChanges: AnyPublisher<(Int, Bool), Never> {
        favoriteChangesSubject.eraseToAnyPublisher()
    }
    var moviesToReturn: [Movie] = []
    var totalPagesToReturn: Int = 1
    var detailsToReturn: [Int: MovieDetail] = [:]

    private(set) var toggleFavoriteCalledWith: [Int] = []

    func fetchBestMovies2024(page: Int) async throws -> (movies: [Movie], totalPages: Int) {
        return (moviesToReturn, totalPagesToReturn)
    }

    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        guard let detail = detailsToReturn[id] else {
            throw NSError(domain: "FakeMoviesRepository", code: 0)
        }
        return detail
    }

    @discardableResult
    func toggleFavorite(movieId: Int) async throws -> Bool {
        toggleFavoriteCalledWith.append(movieId)
        return true
    }
}
