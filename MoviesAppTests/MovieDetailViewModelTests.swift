//
//  MovieDetailViewModelTests.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//

import XCTest
@testable import MoviesApp

@MainActor
final class MovieDetailViewModelTests: XCTestCase {

    func test_load_setsDetail() async {
        let fakeRepo = FakeMoviesRepository()
        let detail = MovieDetail(
            id: 99,
            title: "Detail Movie",
            posterPath: nil,
            backdropPath: nil,
            voteAverage: 8.7,
            releaseDate: "2024-03-01",
            originalLanguage: "en",
            overview: "Nice movie",
            isFavorite: false
        )
        fakeRepo.detailsToReturn[99] = detail

        let client = TMDBClient(apiKey: "FAKE")
        let vm = MovieDetailViewModel(movieId: 99, repository: fakeRepo, client: client)

        vm.load()
        try? await Task.sleep(nanoseconds: 200_000_000)

        XCTAssertNotNil(vm.detail)
        XCTAssertEqual(vm.detail?.title, "Detail Movie")
    }

    func test_toggleFavorite_togglesLocalStateAndCallsRepository() async {
        let fakeRepo = FakeMoviesRepository()
        let client = TMDBClient(apiKey: "FAKE")
        let vm = MovieDetailViewModel(movieId: 1, repository: fakeRepo, client: client)

        vm.detail = MovieDetail(
            id: 1,
            title: "Test",
            posterPath: nil,
            backdropPath: nil,
            voteAverage: 7.0,
            releaseDate: nil,
            originalLanguage: nil,
            overview: nil,
            isFavorite: false
        )

        vm.toggleFavorite()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(fakeRepo.toggleFavoriteCalledWith, [1])
    }
}
