//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Preetham Baliga on 24/10/21.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: (LoadFeedResult) -> ())
}
