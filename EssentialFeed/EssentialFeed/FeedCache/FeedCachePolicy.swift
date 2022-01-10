//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Preetham Baliga on 10/01/22.
//

import Foundation

internal final class FeedCachePolicy {

    private init() {}

    static private let calendar = Calendar(identifier: .gregorian)

    static private var maxCacheAgeInDays: Int {
        return 7
    }

    static public func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
