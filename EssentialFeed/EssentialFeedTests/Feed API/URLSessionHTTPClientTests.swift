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

        URLProtocolStub.startInterceptingRequests()

        let url = URL(string: "https://a-url.com")!
        let expectedError = NSError(domain: "Error", code: 1)
        URLProtocolStub.stub(data: nil, response: nil, error: expectedError)

        let sut = URLSessionHTTPClient()
        let exp = expectation(description: "Wait for completion")

        sut.get(from: url) { (result) in

            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError.domain, expectedError.domain)
                XCTAssertEqual(receivedError.code, expectedError.code)

            default: XCTFail("Expected failure with \(expectedError). Got \(result) instead")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        URLProtocolStub.stopInterceptingRequests()
    }

    private class URLProtocolStub: URLProtocol {

        static var stub: Stub?

        struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }

        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }

        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }

        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            URLProtocolStub.stub = nil
        }

        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }

            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }

            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {}
    }
}
    
