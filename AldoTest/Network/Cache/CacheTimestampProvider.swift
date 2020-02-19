//
//  CacheTimestampProvider.swift
//  AldoTest
//
//  Created by Sergey Kazakov on 19/02/2020.
//  Copyright © 2020 Piyush Sharma. All rights reserved.
//

import Foundation

protocol CacheTimestampProvider {
    var currentTimestamp: Date { get }
}

final class CurrentDateCacheTimestampProvider: CacheTimestampProvider {
    var currentTimestamp: Date {
        return Date()
    }
}

