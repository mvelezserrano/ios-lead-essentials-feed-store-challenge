//
//  ManagedCache.swift
//  Tests
//
//  Created by Miguel Angel Vélez Serrano on 04/04/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData
import FeedStoreChallenge

@objc(ManagedCache)
public class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
}

extension ManagedCache {
    var localFeed: [LocalFeedImage] {
        return feed
            .compactMap {
                guard let managedFeedImage = $0 as? ManagedFeedImage else {
                    return nil
                }
                return managedFeedImage.localFeedImage
        }
    }
}
