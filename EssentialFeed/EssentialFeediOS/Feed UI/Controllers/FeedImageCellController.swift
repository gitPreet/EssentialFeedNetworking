//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Preetham Baliga on 14/04/22.
//

import Foundation
import UIKit

public final class FeedImageCellController {

    private let viewModel: FeedImageViewModel

    init(viewModel: FeedImageViewModel) {
        self.viewModel = viewModel
    }

    func view() -> UITableViewCell {

        let cell = binded(FeedImageCell())
        viewModel.loadImageData()
        return cell
    }

    func preload() {
        viewModel.loadImageData()
    }

    func cancelLoad() {
        viewModel.cancelImageLoad()
    }

    func binded(_ cell: FeedImageCell) -> FeedImageCell {
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.onRetry = viewModel.loadImageData

        viewModel.onImageLoad = { [weak cell] (image) in
            cell?.feedImageView.image = image
        }

        viewModel.onImageLoadingStateChange = { [weak cell] (isLoading) in
            cell?.feedImageContainer.isShimmering = isLoading
        }

        viewModel.onShouldRetryImageLoadStateChange = { [weak cell] (shouldRetry) in
            cell?.feedImageRetryButton.isHidden = !shouldRetry
        }

        return cell
    }
}

