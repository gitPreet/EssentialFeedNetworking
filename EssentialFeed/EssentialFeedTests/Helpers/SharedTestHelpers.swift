//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Preetham Baliga on 10/01/22.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0, userInfo: nil)
}

func anyURL() -> URL {
    return URL(string: "https://a-url.com")!
}
