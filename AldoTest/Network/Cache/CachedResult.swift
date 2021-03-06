//
//  CachedResult.swift
//  AldoTest
//
//  Created by Sergey Kazakov on 19/02/2020.
//  Copyright © 2020 Piyush Sharma. All rights reserved.
//

import Foundation

enum CachedResult<T> {
    case stale
    case notFound
    case retrievedFromCache(T)
}
