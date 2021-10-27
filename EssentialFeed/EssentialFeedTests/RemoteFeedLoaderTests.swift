//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Preetham Baliga on 24/10/21.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_load_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut: sut, toCompleteWithResult: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { (index, value) in
            expect(sut: sut, toCompleteWithResult: .failure(.invalidData)) {
                client.complete(withStatusCode: value, at: index)

            }
        }
    }

    func test_load_deliversInvalidDataOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut: sut, toCompleteWithResult: .failure(.invalidData)) {
            let invalidJSON = Data("invalid JSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }

    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONResponse() {
        let (sut, client) = makeSUT()

        expect(sut: sut, toCompleteWithResult: .success([])) {
            let emptyJSON = Data("{\"items\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyJSON)
        }
    }

    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()

        let item1 = FeedItem(id: UUID(),
                             description: nil,
                             location: nil,
                             imageURL: URL(string: "https://a-url.com")!)
        let item1Json = [
            "id": item1.id.uuidString,
            "image": item1.imageURL.absoluteString
        ]

        let item2 = FeedItem(id: UUID(),
                             description: "a description",
                             location: "a location",
                             imageURL: URL(string: "https://another-url.com")!)

        let item2Json = [
            "id": item2.id.uuidString,
            "description": item2.description,
            "location": item2.location,
            "image": item2.imageURL.absoluteString
        ]

        let itemsJSON = [
            "items": [item1Json, item2Json]
        ]

        expect(sut: sut, toCompleteWithResult: .success([item1, item2])) {
            let json = try! JSONSerialization.data(withJSONObject: itemsJSON, options: .fragmentsAllowed)
            client.complete(withStatusCode: 200, data: json)
        }
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }

    private class HTTPClientSpy: HTTPClient {

        var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()

        var requestedURLs: [URL] {
                return messages.map { $0.url
            }
        }

        //Creating a spy since we do not want requestURL as a property in production code.
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }

        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }

        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)
            messages[index].completion(.success(data, response!))
        }
    }

    private func expect(sut: RemoteFeedLoader,
                        toCompleteWithResult result: RemoteFeedLoader.Result,
                        when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load {
            capturedResults.append($0)
        }

        action()

        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
}
