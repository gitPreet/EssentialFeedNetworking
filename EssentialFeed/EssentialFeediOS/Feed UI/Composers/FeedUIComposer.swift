//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Preetham Baliga on 14/04/22.
//

import Foundation
import EssentialFeed
import UIKit

public class FeedUIComposer {

    private init() {}

    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
//        let viewModel = FeedViewModel(feedLoader: feedLoader)
        let presenter = FeedPresenter(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(presenter: presenter)
        let feedController = FeedViewController(refreshController: refreshController)
        presenter.loadingView = refreshController
        presenter.feedView = FeedViewAdapter(controller: feedController, imageLoader: imageLoader)
//        viewModel.onFeedLoad = adaptFeedToCellControllers(forwardingTo: feedController, loader: imageLoader)
        return feedController
    }
}

private final class FeedViewAdapter: FeedView {

    private weak var controller: FeedViewController?
    private let imageLoader: FeedImageDataLoader

    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(feed: [FeedImage]) {
        controller?.tableModel = feed.map({ model in
            FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init))
        })
    }
}
