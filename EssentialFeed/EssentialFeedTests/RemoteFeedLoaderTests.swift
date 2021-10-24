//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Preetham Baliga on 24/10/21.
//

import XCTest

class RemoteFeedLoader {

    let url: URL
    let client: HTTPClient

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {

    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {

    var requestedURL: URL?

    //Creating a spy since we do not want requestURL as a property in production code.
    func get(from url: URL) {
        self.requestedURL = url
    }
}


class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(url: URL(string: "https://a-url.com")!, client: client)

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)

        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
}
