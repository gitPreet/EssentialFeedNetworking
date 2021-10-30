//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Preetham Baliga on 30/10/21.
//

import XCTest

class URLSessionHTTPClient {

    let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func get(from url: URL) {
        session.dataTask(with: url) { _, _, _ in

        }
    }
}

class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURLCreatesDataTaskWithURL() {

        let url = URL(string: "https://a-url.com")!
        let session = URLSessionSpy()

        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)

        XCTAssertEqual(session.receivedURLs, [url])
    }

    private class URLSessionSpy: URLSession {
        var receivedURLs = [URL]()

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            return FakeURLSessionDataTask()
        }
    }

    private class FakeURLSessionDataTask: URLSessionDataTask {}
}
    
