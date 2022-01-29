//
//  CoreDataFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Preetham Baliga on 27/01/22.
//

import XCTest
import EssentialFeed

class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()

        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()

        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
 
    }
    
    func test_retrieve_hasNoSideEffectsonNonEmptyCache() {
 
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
 
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
 
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
 
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() {
 
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
 
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
 
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
 
    }
    
    func test_storeSideEffectsRunSerially() {
 
    }

    // MARK: Helper methods

    func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")

        let sut = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        trackForMemoryLeak(instance: sut, file: file, line: line)
        return sut
    }
}
