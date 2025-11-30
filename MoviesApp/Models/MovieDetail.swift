//
//  MovieDetail.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//

struct MovieDetail {
    let id: Int
    let title: String?
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double?
    let releaseDate: String?
    let originalLanguage: String?
    let overview: String?
    var isFavorite: Bool
}

extension MovieDetail {
    init(entity: MovieEntity) {
        self.id = Int(entity.id)
        self.title = entity.title
        self.posterPath = entity.posterPath
        self.backdropPath = nil
        self.voteAverage = entity.voteAverage
        self.releaseDate = entity.releaseDate
        self.originalLanguage = entity.originalLanguage
        self.overview = entity.overview
        self.isFavorite = entity.isFavorite
    }
}
