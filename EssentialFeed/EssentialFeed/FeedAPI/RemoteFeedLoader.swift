//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Preetham Baliga on 24/10/21.
//

import Foundation

public final class RemoteFeedLoader {

    let url: URL
    let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public enum Result: Equatable {
        case success([FeedItem])
        case failure(RemoteFeedLoader.Error)
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (RemoteFeedLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success(let data, let response):
                completion(FeedItemsMapper.map(data: data, response: response))
 
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
