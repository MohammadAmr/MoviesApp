//
//  AppDependencies.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//

import CoreData

struct AppDependencies {
    let coreDataStack: CoreDataStack
    let tmdbClient: TMDBClient
    let moviesRepository: MoviesRepository
    let moviesListViewModel: MoviesListViewModel

    init() {
        let coreDataStack = CoreDataStack.shared

        let client = TMDBClient(apiKey: "becc2eeef73fb53b27cc10dce2099f39")

        let repository = MoviesRepository(
            client: client,
            context: coreDataStack.viewContext
        )

        let moviesListViewModel = MoviesListViewModel(
            repository: repository,
            client: client
        )

        self.coreDataStack = coreDataStack
        self.tmdbClient = client
        self.moviesRepository = repository
        self.moviesListViewModel = moviesListViewModel
    }
}
