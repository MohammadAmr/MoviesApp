//
//  MoviesRepository.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//

import CoreData
import Combine

import Combine

protocol MoviesRepositoryType {
    var favoriteChanges: AnyPublisher<(Int, Bool), Never> { get }

    func fetchBestMovies2024(page: Int) async throws -> (movies: [Movie], totalPages: Int)
    func fetchMovieDetail(id: Int) async throws -> MovieDetail
    @discardableResult
    func toggleFavorite(movieId: Int) async throws -> Bool
}


final class MoviesRepository: MoviesRepositoryType {
    private let client: TMDBClient
    private let context: NSManagedObjectContext

    private let favoriteChangesSubject = PassthroughSubject<(Int, Bool), Never>()
    var favoriteChanges: AnyPublisher<(Int, Bool), Never> {
        favoriteChangesSubject.eraseToAnyPublisher()
    }
    
    init(client: TMDBClient, context: NSManagedObjectContext) {
        self.client = client
        self.context = context
    }

    // MARK: List
    func fetchBestMovies2024(page: Int) async throws -> (movies: [Movie], totalPages: Int) {
        let response = try await client.fetchBestMovies2024(page: page)

        try await context.perform {
            for dto in response.results {
                let fetch: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
                fetch.predicate = NSPredicate(format: "id == %d", dto.id)
                fetch.fetchLimit = 1

                let entity = (try? self.context.fetch(fetch).first) ?? MovieEntity(context: self.context)
                entity.update(from: dto)
            }
            try self.context.save()
        }

        let ids = response.results.map(\.id)
        let movies = try await context.perform { () -> [Movie] in
            let fetch: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetch.predicate = NSPredicate(format: "id IN %@", ids)
            let entities = try self.context.fetch(fetch)
            return entities.map(Movie.init(entity:))
        }

        return (movies: movies, totalPages: response.totalPages)
    }

    // MARK: Detail

    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        let dto = try await client.fetchMovieDetail(id: id)

        let detail: MovieDetail = try await context.perform {
            let fetch: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %d", id)
            fetch.fetchLimit = 1

            let entity = (try? self.context.fetch(fetch).first) ?? MovieEntity(context: self.context)
            entity.update(from: dto)
            try self.context.save()

            return MovieDetail(entity: entity)
        }

        return detail
    }

    // MARK: Favorites

    @discardableResult
    func toggleFavorite(movieId: Int) async throws -> Bool {
        try await context.perform {
            let fetch: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %d", movieId)
            fetch.fetchLimit = 1

            guard let entity = try self.context.fetch(fetch).first else {
                throw NSError(domain: "MoviesRepository",
                              code: 0,
                              userInfo: [NSLocalizedDescriptionKey: "Movie not found"])
            }

            entity.isFavorite.toggle()
            try self.context.save()

            let newState = entity.isFavorite
            self.favoriteChangesSubject.send((movieId, newState))
            return newState
        }
    }

    func isFavorite(movieId: Int) async throws -> Bool {
        try await context.perform {
            let fetch: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %d", movieId)
            fetch.fetchLimit = 1
            return try self.context.fetch(fetch).first?.isFavorite ?? false
        }
    }
}
