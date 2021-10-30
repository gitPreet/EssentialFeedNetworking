//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Preetham Baliga on 24/10/21.
//

import Foundation

public enum LoadFeedResult<T: Swift.Error> {
    case success([FeedItem])
    case failure(T)
}

extension LoadFeedResult: Equatable where T: Equatable {}

protocol FeedLoader {

    associatedtype Error: Swift.Error

    func load(completion: @escaping (LoadFeedResult<Error>) -> ())
}
