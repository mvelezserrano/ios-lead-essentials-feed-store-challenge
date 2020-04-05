//
//  ManagedFeedImage.swift
//  Tests
//
//  Created by Miguel Angel Vélez Serrano on 04/04/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData
import FeedStoreChallenge

@objc(ManagedFeedImage)
public class ManagedFeedImage: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var imageDescription: String?
    @NSManaged public var location: String?
    @NSManaged public var url: URL
    @NSManaged public var cache: ManagedCache
}

extension ManagedFeedImage {
    static func feed(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map {
            let managedFeedImage = ManagedFeedImage(context: context)
            managedFeedImage.id = $0.id
            managedFeedImage.imageDescription = $0.description
            managedFeedImage.location = $0.location
            managedFeedImage.url = $0.url
            
            return managedFeedImage
        })
    }
    
    var localFeedImage: LocalFeedImage {
        return LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
    }
}
