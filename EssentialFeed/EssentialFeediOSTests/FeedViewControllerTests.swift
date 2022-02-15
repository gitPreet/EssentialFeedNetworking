//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Preetham Baliga on 10/02/22.
//

import XCTest
import UIKit
import EssentialFeed

class FeedViewController: UITableViewController {

    private var loader: FeedLoader?

    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }

    override func viewDidLoad() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        refreshControl?.beginRefreshing()
        load()
    }

    @objc func load() {
        loader?.load(completion: { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        })
    }
}

final class FeedViewControllerTests: XCTestCase {

    func test_init_doesNotLoadFeed() {
        let (_, loader) = makeSUT()

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    func test_viewDidLoad_loadsFeed() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.loadCallCount, 1)
    }

    func test_pullToRefresh_loadsFeed() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.loadCallCount, 2)

        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.loadCallCount, 3)
    }

    func test_viewDidLoad_showsLoadingIndicator() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
    }

    func test_viewDidLoad_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeFeedLoading()

        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }

    func test_pullToRefresh_showsLoadingIndicator() {
        let (sut, _) = makeSUT()

        sut.refreshControl?.simulatePullToRefresh()

        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
    }

    func test_pullToRefresh_hidesLoadingIndicatorOnLoadCompletion() {
        let (sut, loader) = makeSUT()

        sut.refreshControl?.simulatePullToRefresh()
        loader.completeFeedLoading()

        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeak(instance: loader, file: file, line: line)
        trackForMemoryLeak(instance: sut, file: file, line: line)
        return (sut, loader)
    }

    class LoaderSpy: FeedLoader {
        private var completions = [(LoadFeedResult) -> ()]()

        var loadCallCount: Int {
            return completions.count
        }

        func load(completion: @escaping (LoadFeedResult) -> ()) {
            completions.append(completion)
        }

        func completeFeedLoading() {
            completions[0](.success([]))
        }
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