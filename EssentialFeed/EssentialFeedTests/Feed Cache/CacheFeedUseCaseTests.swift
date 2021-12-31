//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Preetham Baliga on 31/12/21.
//

import XCTest
import EssentialFeed

class LocalFeedLoader {

    let store: FeedStore

    init(store: FeedStore) {
        self.store = store
    }

    func save(items: [FeedItem]) {
        store.deleteCachedFeed()
    }
}

class FeedStore {

    var deleteCachedFeedCallCount = 0

    func deleteCachedFeed() {
        deleteCachedFeedCallCount += 1
    }
}

class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }

    func test_save_requestsCacheDeletion() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()

        sut.save(items: items)

        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }

    //MARK: - Helpers

    private func makeSUT() -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        return (sut, store)
    }

    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(),
                        description: "any desc",
                        location: "any loc",
                        imageURL: anyURL())
    }

    private func anyURL() -> URL {
        return URL(string: "https://a-url.com")!
    }
}
