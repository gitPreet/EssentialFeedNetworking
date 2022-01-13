//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Preetham Baliga on 13/01/22.
//

import XCTest
import EssentialFeed

class CodableFeedStore {

    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        completion(.empty)
    }
}

class CodableFeedStoreTests: XCTestCase {

    func test_retrieve_deliversOnEmptyCache() {
        let sut = CodableFeedStore()

        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { (result) in
            switch result {
            case .empty: break
            default: XCTFail("Expected empty. Got \(result) instead.")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
