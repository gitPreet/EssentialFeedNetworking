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

    var loadingView: FeedLoadingView
    var feedView: FeedView

    init(feedView: FeedView, loadingView: FeedLoadingView) {
        self.feedView = feedView
        self.loadingView = loadingView
    }

    func didStartLoadingFeed() {
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}

/*

 In MVP, a view model is also called View data or presentable model.
 It only holds the data necessary or view rendering. It has no behaviour.

 This is different from MVVM. where view model has dependencies and behaviour.
 */
