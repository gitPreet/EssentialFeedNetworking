//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Preetham Baliga on 17/04/22.
//

import Foundation
import EssentialFeed

// The presenter communicates with the view using the FeedViewProtocol unlike a view model which made use of completion handlers.

/* Let's break this below protocol in 2 , since it violates ISP.
protocol FeedViewProtocol {
    func display(isLoading: Bool)
    func display(feed: [FeedImage])
} */

protocol FeedLoadingView: class {
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

final class FeedPresenter {

    typealias Observer<T> = (T) -> Void
    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

//    var onLoadingStateChange: Observer<Bool>?
//    var onFeedLoad: Observer<[FeedImage]>?

    var loadingView: FeedLoadingView?
    var feedView: FeedView?

    func loadFeed() {
        //onLoadingStateChange?(true)
        loadingView?.display(isLoading: true)
        feedLoader.load(completion: { [weak self] result in
            switch result {
            case .success(let feedImage):
                self?.feedView?.display(feed: feedImage)

            case .failure: break
            }
            //self?.onLoadingStateChange?(false)
            self?.loadingView?.display(isLoading: false)
        })
    }
}

