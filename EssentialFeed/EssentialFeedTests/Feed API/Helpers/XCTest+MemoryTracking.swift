//
//  XCTest+MemoryTracking.swift
//  EssentialFeedTests
//
//  Created by Preetham Baliga on 01/11/21.
//

import XCTest

extension XCTestCase {

    func trackForMemoryLeak(instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Potential memory leak. Expected instance to be nil", file: file, line: line)
        }
    }
}
