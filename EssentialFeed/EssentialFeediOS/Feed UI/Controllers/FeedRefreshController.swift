//
//  FeedRefreshController.swift
//  EssentialFeediOS
//
//  Created by Preetham Baliga on 14/04/22.
//

import Foundation
import UIKit
import EssentialFeed

final class FeedRefreshViewController: NSObject {

    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()

    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    var onRefresh: (([FeedImage]) -> Void)?

    @objc func refresh() {
        view.beginRefreshing()
        feedLoader.load(completion: { [weak self] result in
            switch result {
            case .success(let feedImage):
                self?.onRefresh?(feedImage)

            case .failure: break
            }
            self?.view.endRefreshing()
        })
    }
}
