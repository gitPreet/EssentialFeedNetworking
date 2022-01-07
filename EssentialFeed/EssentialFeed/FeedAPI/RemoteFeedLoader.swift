//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Preetham Baliga on 24/10/21.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {

    let url: URL
    let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public typealias Result = LoadFeedResult

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            switch result {
            case .success(let data, let response):
                completion(RemoteFeedLoader.map(data: data, response: response))
 
            case .failure:
                completion(.failure(RemoteFeedLoader.Error.connectivity))
            }
        }
    }

    private static func map(data: Data, response: HTTPURLResponse) -> Result {
        do {
            let remoteFeedItems = try FeedItemsMapper.map(data: data, response: response)
            return .success(remoteFeedItems.toModels())
        } catch {
            return .failure(error)
        }
    }
}

extension Array where Element == RemoteFeedItem {

    func toModels() -> [FeedImage] {
        return self.map {
            FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.imageURL)
        }
    }
}
