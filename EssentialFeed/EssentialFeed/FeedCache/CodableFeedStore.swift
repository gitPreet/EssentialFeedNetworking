//
//  CodableFeedStore.swift
//  EssentialFeed
//
//  Created by Preetham Baliga on 18/01/22.
//

import Foundation

public class CodableFeedStore: FeedStore {

    private struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timestamp: Date

        var localFeed: [LocalFeedImage] {
            return feed.map { $0.local }
        }
    }

    private struct CodableFeedImage: Codable {
        private let id: UUID
        private let description: String?
        private let location: String?
        private let url: URL

        init(_ localFeedImage: LocalFeedImage) {
            self.id = localFeedImage.id
            self.description = localFeedImage.description
            self.location = localFeedImage.location
            self.url = localFeedImage.url
        }

        var local: LocalFeedImage {
            return LocalFeedImage(id: self.id, description: self.description, location: self.location, url: self.url)
        }
    }

    private let storeURL: URL

    private let queue = DispatchQueue(label: "\(CodableFeedStore.self) queue", qos: .userInitiated)

    public init(storeURL: URL) {
        self.storeURL = storeURL
    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        let url = self.storeURL
        queue.async {
            guard let data = try? Data(contentsOf: url) else {
                return completion(.empty)
            }
            do {
                let decoder = JSONDecoder()
                let cache = try decoder.decode(Cache.self, from: data)
                completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        let url = self.storeURL
        queue.async {
            do {
                let encoder = JSONEncoder()
                let cache = Cache(feed: feed.map(CodableFeedImage.init), timestamp: timestamp)
                let encode = try encoder.encode(cache)
                try encode.write(to: url)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        let url = self.storeURL

        queue.async {
            guard FileManager.default.fileExists(atPath: url.path) else {
                return completion(nil)
            }
            do {
                try FileManager.default.removeItem(at: url)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
