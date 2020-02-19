//
//  DiskCacheProvider.swift
//  AldoTest
//
//  Created by Sergey Kazakov on 19/02/2020.
//  Copyright © 2020 Piyush Sharma. All rights reserved.
//

import Foundation

final class DiskCacheProvider<Key, Value> where Key: CachableObjectKeyProtocol & Hashable,
                                                    Value: CachableObjectProtocol & Codable {

    private let cacheTimestampProvider: CacheTimestampProvider
    private let cacheLifespanTimeInterval: TimeInterval

    init(cacheTimestampProvider: CacheTimestampProvider = CurrentDateCacheTimestampProvider(), cacheLifespanTimeInterval: TimeInterval) {
        self.cacheTimestampProvider = cacheTimestampProvider
        self.cacheLifespanTimeInterval = cacheLifespanTimeInterval
    }
}

// MARK:- CacheProvider Protocol

extension DiskCacheProvider: CacheProvider {
// MARK:- Read and write to disk will be implemented here

    func retrieveObjectFor(key: Key, completion: @escaping Callback<CachedResult<Value>>) {
        completion(.right(.notFound))
    }

    func addObject(_ data: Value, for key: Key, completion: @escaping () -> Void) {
        completion()
    }
}
