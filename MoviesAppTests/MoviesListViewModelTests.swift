//
//  MoviesListViewModelTests.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//

import XCTest
@testable import MoviesApp

@MainActor
final class MoviesListViewModelTests: XCTestCase {

    func test_loadFirstPage_setsMovies() async {
        let fakeRepo = FakeMoviesRepository()
        fakeRepo.moviesToReturn = [
            Movie(id: 1, title: "Movie 1", posterPath: nil,
                  voteAverage: 8.0, releaseDate: "2024-01-01",
                  originalLanguage: "en", overview: "Test", isFavorite: false),
            Movie(id: 2, title: "Movie 2", posterPath: nil,
                  voteAverage: 7.5, releaseDate: "2024-02-01",
                  originalLanguage: "en", overview: "Test 2", isFavorite: false)
        ]

        let client = TMDBClient(apiKey: "FAKE") // only used for image URLs
        let viewModel = MoviesListViewModel(repository: fakeRepo, client: client)

        viewModel.loadFirstPage()
        try? await Task.sleep(nanoseconds: 200_000_000)

        XCTAssertEqual(viewModel.movies.count, 2)
        XCTAssertEqual(viewModel.movies[0].title, "Movie 1")
    }

    func test_toggleFavorite_togglesMovieAndCallsRepository() async {
        let fakeRepo = FakeMoviesRepository()
        let client = TMDBClient(apiKey: "FAKE")
        let vm = MoviesListViewModel(repository: fakeRepo, client: client)

        vm.movies = [
            Movie(id: 10, title: "Fav Movie", posterPath: nil,
                  voteAverage: 9.0, releaseDate: nil,
                  originalLanguage: nil, overview: nil, isFavorite: false)
        ]

        vm.toggleFavorite(at: 0)
        try? await Task.sleep(nanoseconds: 200_000_000)

        XCTAssertTrue(vm.movies[0].isFavorite)
        XCTAssertEqual(fakeRepo.toggleFavoriteCalledWith, [10])
    }
}
