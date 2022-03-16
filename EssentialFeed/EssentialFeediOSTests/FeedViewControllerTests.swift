//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Preetham Baliga on 10/02/22.
//

import XCTest
import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewControllerTests: XCTestCase {

    func test_loadFeedAction_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0)

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1)

        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 2)

        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 3)
    }

    func test_loadingFeedIndicatorIsVisibleWhileLoadingTheFeed() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.isShowingLoadingIndicator(), true)

        loader.completeFeedLoading(at: 0)
        XCTAssertEqual(sut.isShowingLoadingIndicator(), false)

        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(sut.isShowingLoadingIndicator(), true)

        loader.completeFeedLoading(at: 1)
        XCTAssertEqual(sut.isShowingLoadingIndicator(), false)
    }

    func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
        let image0 = makeImage(description: "a description", location: "a location")
        let image1 = makeImage(description: nil, location: "a location")
        let image2 = makeImage(description: "a description", location: nil)
        let image3 = makeImage(description: nil, location: nil)

        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()

        loader.completeFeedLoading(with: [image0], at: 0)
        XCTAssertEqual(sut.numberOfRenderedFeedImageViews(), 1)
        assert(that: sut, hasViewConfiguredFor: image0, at: 0)

        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoading(with: [image0, image1, image2, image3], at: 1)
        XCTAssertEqual(sut.numberOfRenderedFeedImageViews(), 4)
        assert(that: sut, hasViewConfiguredFor: image0, at: 0)
        assert(that: sut, hasViewConfiguredFor: image1, at: 1)
        assert(that: sut, hasViewConfiguredFor: image2, at: 2)
        assert(that: sut, hasViewConfiguredFor: image3, at: 3)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeak(instance: loader, file: file, line: line)
        trackForMemoryLeak(instance: sut, file: file, line: line)
        return (sut, loader)
    }

    private func makeImage(description: String? = nil, location: String? = nil, url: URL = URL(string: "any-url")!) -> FeedImage {
        return FeedImage(id: UUID(), description: description, location: location, url: url)
    }

    private func assert(that sut: FeedViewController, isRendering feed: [FeedImage], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedFeedImageViews() == feed.count else {
            return XCTFail("Expected \(feed.count) images to be rendered")
        }
        feed.enumerated().forEach { (index, image) in
            assert(that: sut, hasViewConfiguredFor: image, at: index)
        }
    }

    private func assert(that sut: FeedViewController, hasViewConfiguredFor image: FeedImage, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.feedImageView(at: index)

        guard let cell = view as? FeedImageCell else {
            return XCTFail("Expected \(FeedImageCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        let shouldLocationBeVisible = image.location != nil
        XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible)

        XCTAssertEqual(cell.locationText, image.location)

        XCTAssertEqual(cell.descriptionText, image.description)
    }

    class LoaderSpy: FeedLoader {
        private var completions = [(LoadFeedResult) -> ()]()

        var loadCallCount: Int {
            return completions.count
        }

        func load(completion: @escaping (LoadFeedResult) -> ()) {
            completions.append(completion)
        }

        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int) {
            completions[index](.success(feed))
        }
    }
}

extension FeedViewController {

    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }

    func isShowingLoadingIndicator() -> Bool {
        return refreshControl?.isRefreshing == true
    }

    func numberOfRenderedFeedImageViews() -> Int {
        return tableView.numberOfRows(inSection: feedImagesSection)
    }

    var feedImagesSection: Int {
        return 0
    }

    func feedImageView(at row: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: row, section: feedImagesSection)
        return tableView(tableView, cellForRowAt: indexPath)
    }
}

private extension FeedImageCell {

    var isShowingLocation: Bool {
        return !locationContainer.isHidden
    }

    var locationText: String? {
        return locationLabel.text
    }

    var descriptionText: String? {
        return descriptionLabel.text
    }
}

private extension UIRefreshControl {

    func simulatePullToRefresh() {
        allTargets.forEach({ target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        })
    }
}
