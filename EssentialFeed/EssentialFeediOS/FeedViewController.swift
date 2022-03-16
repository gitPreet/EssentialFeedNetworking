//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Preetham Baliga on 17/02/22.
//

import Foundation
import UIKit
import EssentialFeed

final public class FeedViewController: UITableViewController {

    private var loader: FeedLoader?
    var tableModel = [FeedImage]()

    public convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }

    public override func viewDidLoad() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }

    @objc func load() {
        refreshControl?.beginRefreshing()
        loader?.load(completion: { [weak self] result in
            switch result {
            case .success(let feedImage):
                self?.tableModel = feedImage
                self?.tableView.reloadData()
            case .failure: break
            }
            self?.refreshControl?.endRefreshing()
        })
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = tableModel[indexPath.row]
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = model.location == nil
        cell.locationLabel.text = model.location
        cell.descriptionLabel.text = model.description
        return cell
    }
}
