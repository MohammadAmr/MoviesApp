//
//  TMDBEndpoint.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//
import Foundation

enum TMDBError: Error {
    case invalidResponse
    case httpError(Int)
}

enum TMDBEndpoint {
    private static let baseURL = URL(string: "https://api.themoviedb.org/3")!

    case bestMovies2024(page: Int)
    case movieDetail(id: Int)

    func url(apiKey: String) -> URL {
        switch self {
        case .bestMovies2024(let page):
            var comps = URLComponents(url: Self.baseURL.appendingPathComponent("discover/movie"),
                                      resolvingAgainstBaseURL: false)!
            comps.queryItems = [
                .init(name: "api_key", value: apiKey),
                .init(name: "language", value: "en-US"),
                .init(name: "sort_by", value: "vote_average.desc"),
                .init(name: "primary_release_year", value: "2024"),
                .init(name: "vote_count.gte", value: "100"),
                .init(name: "page", value: String(page))
            ]
            return comps.url!
        case .movieDetail(let id):
            var comps = URLComponents(url: Self.baseURL.appendingPathComponent("movie/\(id)"),
                                      resolvingAgainstBaseURL: false)!
            comps.queryItems = [
                .init(name: "api_key", value: apiKey),
                .init(name: "language", value: "en-US")
            ]
            return comps.url!
        }
    }
}
