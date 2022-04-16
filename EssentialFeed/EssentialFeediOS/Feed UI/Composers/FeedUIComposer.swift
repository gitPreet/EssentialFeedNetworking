//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Preetham Baliga on 14/04/22.
//

import Foundation
import EssentialFeed

public class FeedUIComposer {

    private init() {}

    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let viewModel = FeedViewModel(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(viewModel: viewModel)
        let feedController = FeedViewController(refreshController: refreshController)
        viewModel.onFeedLoad = adaptFeedToCellControllers(forwardingTo: feedController, loader: imageLoader)
        return feedController
    }

    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak controller] (feedImages) in
            controller?.tableModel = feedImages.map({ model in
                FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: loader))
            })
        }
    }
}
