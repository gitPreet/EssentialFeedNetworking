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

struct FeedLoadingViewModel {
    let isLoading: Bool
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedViewModel {
    let feed: [FeedImage]
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

// Presenters translate model values into view data.
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
        loadingView?.display(FeedLoadingViewModel(isLoading: true))
        feedLoader.load(completion: { [weak self] result in
            switch result {
            case .success(let feedImage):
                self?.feedView?.display(FeedViewModel(feed: feedImage))

            case .failure: break
            }
            //self?.onLoadingStateChange?(false)
            self?.loadingView?.display(FeedLoadingViewModel(isLoading: false))
        })
    }
}

/*

 In MVP, a view model is also called View data or presentable model.
 It only holds the data necessary or view rendering. It has no behaviour.

 This is different from MVVM. where view model has dependencies and behaviour.
 */
