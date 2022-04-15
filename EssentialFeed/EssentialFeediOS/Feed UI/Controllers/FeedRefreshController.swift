//
//  FeedRefreshController.swift
//  EssentialFeediOS
//
//  Created by Preetham Baliga on 14/04/22.
//

import Foundation
import UIKit

final class FeedRefreshViewController: NSObject {

    private(set) lazy var view: UIRefreshControl = binded(UIRefreshControl())

    private let viewModel: FeedViewModel

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }

    @objc func refresh() {
        viewModel.loadFeed()
    }

    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        // binds view model to view
        viewModel.onChange = { [weak self] (viewModel) in
            if viewModel.isLoading {
                self?.view.beginRefreshing()
            } else {
                self?.view.endRefreshing()
            }
        }
        // binds view to view model
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
