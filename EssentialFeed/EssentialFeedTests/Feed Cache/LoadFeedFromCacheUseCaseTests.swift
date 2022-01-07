//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Preetham Baliga on 07/01/22.
//

import XCTest
import EssentialFeed

class LoadFeedFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotSendMessageToStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_load_requestsCacheRetreival() {
        let (sut, store) = makeSUT()

        sut.load { _ in }

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()

        let exp = expectation(description: "wait for load completion")

        var receivedError: Error?
        sut.load { (error) in
            receivedError = error
            exp.fulfill()
        }

        store.completeRetrieval(with: anyNSError())
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(receivedError as NSError?, retrievalError)
    }

//    func test_load_deliversNoImagesOnEmptyCache() {
//        let (sut, store) = makeSUT()
//        let retrievalError = anyNSError()
//
//        let exp = expectation(description: "wait for load completion")
//
//        var receivedError: Error?
//        sut.load { (error) in
//            receivedError = error
//            exp.fulfill()
//        }
//
//        store.completeRetrieval(with: anyNSError())
//        wait(for: [exp], timeout: 1.0)
//
//        XCTAssertEqual(receivedError as NSError?, retrievalError)
//    }

    //MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init,
                         line: UInt = #line, file: StaticString = #file) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeak(instance: store, file: file, line: line)
        trackForMemoryLeak(instance: sut, file: file, line: line)
        return (sut, store)
    }

    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0, userInfo: nil)
    }
}
