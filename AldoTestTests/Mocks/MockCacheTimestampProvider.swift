//
//  MockCacheTimestampProvider.swift
//  AldoTestTests
//
//  Created by Sergey Kazakov on 19/02/2020.
//  Copyright © 2020 Piyush Sharma. All rights reserved.
//

import Foundation
@testable import AldoTest

final class MockCacheTimestampProvider: CacheTimestampProvider {
    var currentTimestamp: Date

    init(currentTimestamp: Date) {
        self.currentTimestamp = currentTimestamp
    }
}
