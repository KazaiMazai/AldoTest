//
//  InMemoryNetworkCacheProvider.swift
//  AldoTest
//
//  Created by Sergey Kazakov on 19/02/2020.
//  Copyright © 2020 Piyush Sharma. All rights reserved.
//

import Foundation

final class InMemoryNetworkCacheProvider {
    private let cacheTimestampProvider: CacheTimestampProvider
    private let cacheLifespanTimeInterval: TimeInterval

    private var cache: NSCache<NSString, NSData>
    private var expirationDateForCachedKeys: [String: Date]

    init(cacheTimestampProvider: CacheTimestampProvider = CurrentDateCacheTimestampProvider(), cacheLifespanTimeInterval: TimeInterval) {
        cache = NSCache()
        expirationDateForCachedKeys = [:]

        self.cacheTimestampProvider = cacheTimestampProvider
        self.cacheLifespanTimeInterval = cacheLifespanTimeInterval
    }
}

// MARK:- NetworkCacheProvider Protocol

extension InMemoryNetworkCacheProvider: NetworkCacheProvider {
    func retrieve(request: CachableNetworkRequest, completion: @escaping Callback<CachedResult<Data>>) {
        let requestHashString = request.hashString

        guard let cachedObject = cache.object(forKey: NSString(string: requestHashString)) else {
            completion(.right(.notFound))
            return
        }

        guard let expirationDate = expirationDateForCachedKeys[requestHashString] else {
            completion(.wrong(InMemoryNetworkCacheProviderError.cacheExpirationDateNotFound))
            return
        }

        guard cacheTimestampProvider.currentTimestamp.compare(expirationDate) == .orderedAscending else {
            cache.removeObject(forKey: NSString(string: requestHashString))
            expirationDateForCachedKeys.removeValue(forKey: requestHashString)
            completion(.right(.stale))
            return
        }

        completion(.right(.cached(Data(referencing: cachedObject))))
    }

    func addToCache(_ data: Data, for request: CachableNetworkRequest, completion: @escaping () -> Void) {
        let requestHashString = request.hashString
        cache.setObject(NSData(data: data), forKey: NSString(string: requestHashString))
        expirationDateForCachedKeys[requestHashString] = cacheTimestampProvider.currentTimestamp.addingTimeInterval(cacheLifespanTimeInterval)
        completion()
    }
}

enum InMemoryNetworkCacheProviderError: LocalizedError {
    case cacheExpirationDateNotFound

    var errorDescription: String? {
        var msg: String

        switch self {
        case .cacheExpirationDateNotFound:
            msg = "Сache expiration date missing"
        }

        return msg
    }
}
