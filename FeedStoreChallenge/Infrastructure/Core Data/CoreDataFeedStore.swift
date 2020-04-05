//
//  CoreDataFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Miguel Angel Vélez Serrano on 05/04/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
    private static let modelName = "FeedStore"
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL) throws {
        guard let modelURL = Bundle(for: CoreDataFeedStore.self).url(forResource: CoreDataFeedStore.modelName, withExtension:"momd") else {
            throw NSError(domain: "Error loading model from bundle", code: 0)
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            throw NSError(domain: "Error initializing mom from", code: 0)
        }
        
        let description = NSPersistentStoreDescription(url: storeURL)
        container = NSPersistentContainer(name: CoreDataFeedStore.modelName, managedObjectModel: mom)
        container.persistentStoreDescriptions = [description]
        
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }
        
        context = container.newBackgroundContext()
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        let context = self.context
        context.perform {
            do {
                let managedCache = try ManagedCache.createUnique(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.feed(from: feed, in: context)
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let context = self.context
        context.perform {
            do {
                guard let managedCache = try ManagedCache.fetch(in: context) else {
                    return completion(.empty)
                }
                completion(.found(feed: managedCache.localFeed, timestamp: managedCache.timestamp))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        let context = self.context
        context.perform {
            do {
                guard let existingManagedCache = try ManagedCache.fetch(in: context) else {
                    return completion(.none)
                }
                context.delete(existingManagedCache)
                try context.save()
                completion(nil)
            } catch {
                completion(.some(error))
            }
        }
    }
}
