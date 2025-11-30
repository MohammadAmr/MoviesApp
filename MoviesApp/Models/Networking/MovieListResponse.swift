//
//  MovieListResponse.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//

// MARK: - List response
struct MovieListResponse: Decodable {
    let page: Int
    let results: [MovieSummaryDTO]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Movie in list
struct MovieSummaryDTO: Decodable {
    let id: Int
    let title: String
    let posterPath: String?
    let voteAverage: Double?
    let releaseDate: String?
    let originalLanguage: String?
    let overview: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
    }
}
