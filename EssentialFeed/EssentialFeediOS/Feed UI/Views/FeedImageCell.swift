//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Preetham Baliga on 15/03/22.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
    public var locationContainer = UIView()
    public var locationLabel = UILabel()
    public var descriptionLabel = UILabel()
    public let feedImageContainer = UIView()
    public let feedImageView = UIImageView()

    private(set) public lazy var feedImageRetryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()

    var onRetry: (() -> Void)?

    @objc private func retryButtonTapped() {
        onRetry?()
    }
}
