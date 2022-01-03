//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Preetham Baliga on 28/10/21.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let imageURL: URL
}

internal final class FeedItemsMapper {

    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }

    internal static func map(data: Data, response: HTTPURLResponse) throws -> [RemoteFeedItem] {

        guard response.statusCode == 200,
        let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }

        return root.items
    }
}

