//
//  CachableProtocol.swift
//  AldoTest
//
//  Created by Sergey Kazakov on 19/02/2020.
//  Copyright © 2020 Piyush Sharma. All rights reserved.
//

import Foundation

protocol CachableObjectProtocol {
    associatedtype ObjectType: AnyObject

    init(from: ObjectType)

    var value: ObjectType { get }
}

protocol CachableObjectKeyProtocol {
    associatedtype KeyType: AnyObject

    var key: KeyType { get }
}
