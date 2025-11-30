//
//  MovieDetails.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//

// MARK: - Movie details
struct MovieDetailDTO: Decodable {
    let id: Int
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double?
    let releaseDate: String?
    let originalLanguage: String?
    let overview: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
    }
}
