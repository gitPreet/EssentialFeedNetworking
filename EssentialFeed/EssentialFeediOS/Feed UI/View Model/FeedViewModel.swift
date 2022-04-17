//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Preetham Baliga on 15/04/22.
//

/*
import Foundation
import EssentialFeed

final class FeedViewModel {

    typealias Observer<T> = (T) -> Void
    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    var onLoadingStateChange: Observer<Bool>?
    var onFeedLoad: Observer<[FeedImage]>?

    func loadFeed() {
        onLoadingStateChange?(true)
        feedLoader.load(completion: { [weak self] result in
            switch result {
            case .success(let feedImage):
                self?.onFeedLoad?(feedImage)

            case .failure: break
            }
            self?.onLoadingStateChange?(false)
        })
    }
}
 */
