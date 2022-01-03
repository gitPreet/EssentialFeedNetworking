//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Preetham Baliga on 03/01/22.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let imageURL: URL
}
