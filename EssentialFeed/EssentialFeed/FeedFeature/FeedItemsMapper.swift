//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Preetham Baliga on 28/10/21.
//

import Foundation

internal final class FeedItemsMapper {

    private struct Root: Decodable {
        let items: [Item]

        var feed: [FeedItem] {
            return items.map({ $0.item })
        }
    }

    private struct Item: Decodable {
        public let id: UUID
        public let description: String?
        public let location: String?
        public let imageURL: URL

        var item: FeedItem {
            return FeedItem(id: id,
                            description: description,
                            location: location,
                            imageURL: imageURL)
        }

        private enum CodingKeys: String, CodingKey {
            case id
            case description
            case location
            case imageURL = "image"
        }
    }

    internal static func map(data: Data, response: HTTPURLResponse) -> RemoteFeedLoader.Result {

        guard response.statusCode == 200,
        let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }

        return .success(root.feed)
    }
}

