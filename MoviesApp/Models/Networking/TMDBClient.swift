//
//  TMDBClient.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//

import Foundation

final class TMDBClient {
    private let apiKey: String
    private let session: URLSession
    private let decoder: JSONDecoder

    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
        let decoder = JSONDecoder()
        self.decoder = decoder
    }

    private func request<T: Decodable>(_ endpoint: TMDBEndpoint,
                                       as type: T.Type = T.self) async throws -> T {
        let url = endpoint.url(apiKey: apiKey)
        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse else {
            throw TMDBError.invalidResponse
        }
        guard (200..<300).contains(http.statusCode) else {
            throw TMDBError.httpError(http.statusCode)
        }

        return try decoder.decode(T.self, from: data)
    }

    func fetchBestMovies2024(page: Int) async throws -> MovieListResponse {
        try await request(.bestMovies2024(page: page))
    }

    func fetchMovieDetail(id: Int) async throws -> MovieDetailDTO {
        try await request(.movieDetail(id: id))
    }

    func imageURL(path: String?, size: String = "w500") -> URL? {
        guard let path = path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/\(size)\(path)")
    }
}
