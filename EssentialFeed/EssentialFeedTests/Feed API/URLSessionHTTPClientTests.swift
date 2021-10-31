//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Preetham Baliga on 30/10/21.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {

    let session: URLSession

    init(session: URLSession = .shared)  {
        self.session = session
    }

    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }

        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURL_failsOnRequestError() {

        startInterceptingRequests()

        let url = URL(string: "https://a-url.com")!
        let expectedError = NSError(domain: "Error", code: 0, userInfo: nil)
        URLProtocolStub.stub(url: url, error: expectedError)

        let sut = URLSessionHTTPClient()
        let exp = expectation(description: "Wait for completion")

        sut.get(from: url) { (result) in
            switch result {
            case .failure(let receivedError as NSError):
                XCTAssertEqual(receivedError, expectedError)
            default: XCTFail("Expected failure with \(expectedError). Got \(result) instead")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        stopInterceptingRequests()
    }

    func startInterceptingRequests() {
        URLProtocol.registerClass(URLProtocol.self)
    }

    func stopInterceptingRequests() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
    }

    private class URLProtocolStub: URLProtocol {

        private static var stubs = [URL: Stub]()

        private struct Stub {
            let error: Error?
        }

        static func stub(url: URL, error: Error? = nil) {
            stubs[url] = Stub(error: error)
        }

        override class func canInit(with request: URLRequest) -> Bool {
            guard let url = request.url else { return false }

            return stubs[url] != nil
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {
            guard let url = request.url, let stub = URLProtocolStub.stubs[url] else { return }

            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }

            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {}
    }
}
    
