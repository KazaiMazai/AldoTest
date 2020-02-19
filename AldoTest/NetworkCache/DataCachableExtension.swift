//
//  DataCachableExtension.swift
//  AldoTest
//
//  Created by Sergey Kazakov on 19/02/2020.
//  Copyright © 2020 Piyush Sharma. All rights reserved.
//

import Foundation

extension Data: CachableObjectProtocol {
    init(from representingObject: NSData) {
        self = Data(referencing: representingObject)
    }

    var value: NSData {
        return NSData(data: self)
    }
}
