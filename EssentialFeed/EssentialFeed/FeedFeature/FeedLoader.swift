//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Preetham Baliga on 24/10/21.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> ())
}
