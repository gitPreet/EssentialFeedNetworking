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
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(delegate: presentationAdapter)
        let feedController = FeedViewController(refreshController: refreshController)
        presentationAdapter.presenter = FeedPresenter(
            feedView: FeedViewAdapter(controller: feedController, imageLoader: imageLoader),
            loadingView: WeakRefVirtualProxy(object: refreshController))
//        viewModel.onFeedLoad = adaptFeedToCellControllers(forwardingTo: feedController, loader: imageLoader)
        return feedController
    }
}

// Creating a weak proxy to remove memory management details from the MVP classes
private final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?

    init(object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {

    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}

private final class FeedViewAdapter: FeedView {

    private weak var controller: FeedViewController?
    private let imageLoader: FeedImageDataLoader

    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map({ model in
            FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init))
        })
    }
}

private final class FeedLoaderPresentationAdapter: FeedRefreshViewControllerDelegate {

    private let feedLoader: FeedLoader
    var presenter: FeedPresenter?

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()

        feedLoader.load { [weak self] result in
            switch result {

            case .success(let feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)

            case .failure(let error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
}
