//
//  MovieEntity+CoreDataProperties.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//
//

public import Foundation
public import CoreData


public typealias MovieEntityCoreDataPropertiesSet = NSSet

extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var releaseDate: String?
    @NSManaged public var originalLanguage: String?
    @NSManaged public var overview: String?
    @NSManaged public var isFavorite: Bool

}

extension MovieEntity : Identifiable {

}

extension MovieEntity {
    func update(from dto: MovieSummaryDTO) {
        id = Int64(dto.id)
        title = dto.title
        posterPath = dto.posterPath
        voteAverage = dto.voteAverage ?? voteAverage
        releaseDate = dto.releaseDate
        originalLanguage = dto.originalLanguage
        overview = dto.overview
        // isFavorite stays as is
    }

    func update(from dto: MovieDetailDTO) {
        id = Int64(dto.id)
        title = dto.title
        posterPath = dto.posterPath
        voteAverage = dto.voteAverage ?? voteAverage
        releaseDate = dto.releaseDate
        originalLanguage = dto.originalLanguage
        overview = dto.overview
        // isFavorite stays
    }
}
