//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Preetham Baliga on 15/04/22.
//

import Foundation
import EssentialFeed

final class FeedViewModel {

    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    var onChange: ((FeedViewModel) -> Void)?
    var onFeedLoad: (([FeedImage]) -> Void)?

    private(set) var isLoading: Bool = false {
        didSet {
            onChange?(self)
        }
    }

    func loadFeed() {
        isLoading = true
        feedLoader.load(completion: { [weak self] result in
            switch result {
            case .success(let feedImage):
                self?.onFeedLoad?(feedImage)

            case .failure: break
            }
            self?.isLoading = false
        })
    }
}
