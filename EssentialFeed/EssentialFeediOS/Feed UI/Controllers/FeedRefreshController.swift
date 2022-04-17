//
//  FeedRefreshController.swift
//  EssentialFeediOS
//
//  Created by Preetham Baliga on 14/04/22.
//

import Foundation
import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {

    private(set) lazy var view: UIRefreshControl = loadView()

    /* Let's replace the view model with the presenter.

    private let viewModel: FeedViewModel

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    } */

    private let presenter: FeedPresenter

    init(presenter: FeedPresenter) {
        self.presenter = presenter
    }

    @objc func refresh() {
        presenter.loadFeed()
    }

    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }

    /*
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        // binds view model to view
        viewModel.onLoadingStateChange = { [weak view] (isLoading) in
            if isLoading {
                view?.beginRefreshing()
            } else {
                view?.endRefreshing()
            }
        }
        // binds view to view model
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    } */

    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }

}
