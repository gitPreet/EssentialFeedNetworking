//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Preetham Baliga on 16/04/22.
//

import Foundation
import EssentialFeed
import UIKit

public final class FeedImageViewModel {

    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader

    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }

    var hasLocation: Bool {
        return location != nil
    }

    var location: String? {
        return model.location
    }

    var description: String? {
        return model.description
    }

    var onImageLoad: ((UIImage) -> Void)?
    var onImageLoadingStateChange: ((Bool) -> Void)?
    var onShouldRetryImageLoadStateChange: ((Bool) -> Void)?

    func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)

        task = imageLoader.loadImageData(from: model.url, completion: { [weak self] result in
            self?.handle(result)
        })
    }

    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(UIImage.init) {
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }

    func cancelImageLoad() {
        task?.cancel()
        task = nil
    }
}
