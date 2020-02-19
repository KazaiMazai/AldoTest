//
//  CoreNetworkCache.swift
//  AldoTest
//
//  Created by Sergey Kazakov on 18/02/2020.
//  Copyright © 2020 Piyush Sharma. All rights reserved.
//

import Foundation
import AHNetwork
import EitherResult

protocol CacheProvider {
    associatedtype Key
    associatedtype Value

    func retrieveObjectFor(key: Key, completion: @escaping Callback<CachedResult<Value>>)
    func addObject(_ data: Value, for key: Key, completion: @escaping () -> Void)
}
