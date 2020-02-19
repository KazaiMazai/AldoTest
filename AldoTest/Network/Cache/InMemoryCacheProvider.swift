//
//  InMemoryNetworkCacheProvider.swift
//  AldoTest
//
//  Created by Sergey Kazakov on 19/02/2020.
//  Copyright © 2020 Piyush Sharma. All rights reserved.
//

import Foundation

/**
    InMemoryCacheProvider wraps NSCache to conform to CacheProvider protocol
 */

final class InMemoryCacheProvider<Key, Value> where Key: CachableObjectKeyProtocol & Hashable,
                                                    Value: CachableObjectProtocol {
    
    private let cacheTimestampProvider: CacheTimestampProvider
    private let cacheLifespanTimeInterval: TimeInterval

    private var cache: NSCache<Key.KeyType, Value.ObjectType>
    private var expirationDateForCachedKeys: [Key: Date]

    init(cacheTimestampProvider: CacheTimestampProvider = CurrentDateCacheTimestampProvider(), cacheLifespanTimeInterval: TimeInterval) {
        cache = NSCache()
        expirationDateForCachedKeys = [:]

        self.cacheTimestampProvider = cacheTimestampProvider
        self.cacheLifespanTimeInterval = cacheLifespanTimeInterval
    }
}

// MARK:- CacheProvider Protocol

extension InMemoryCacheProvider: CacheProvider {
    func retrieveObjectFor(key: Key, completion: @escaping Callback<CachedResult<Value>>) {
        guard let cachedObject = cache.object(forKey: key.key) else {
            completion(.right(.notFound))
            return
        }

        guard let expirationDate = expirationDateForCachedKeys[key] else {
            completion(.wrong(InMemoryNetworkCacheProviderError.cacheExpirationDateNotFound))
            return
        }

        guard cacheTimestampProvider.currentTimestamp.compare(expirationDate) == .orderedAscending else {
            cache.removeObject(forKey: key.key)
            expirationDateForCachedKeys.removeValue(forKey: key)
            completion(.right(.stale))
            return
        }

        completion(.right(.cached(Value(from: cachedObject))))
    }

    func addObject(_ object: Value, for key: Key, completion: @escaping () -> Void) {
        cache.setObject(object.value, forKey: key.key)
        expirationDateForCachedKeys[key] = cacheTimestampProvider.currentTimestamp.addingTimeInterval(cacheLifespanTimeInterval)
        completion()
    }
}

// MARK:- InMemoryNetworkCacheProviderError

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

