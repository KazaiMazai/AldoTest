//
//  CachableProtocol.swift
//  AldoTest
//
//  Created by Sergey Kazakov on 19/02/2020.
//  Copyright © 2020 Piyush Sharma. All rights reserved.
//

import Foundation


// MARK:- CachableObjectProtocol

protocol CachableObjectProtocol {
    associatedtype ObjectType: AnyObject

    init(from: ObjectType)

    var value: ObjectType { get }
}

// MARK:- CachableObjectKeyProtocol Data Extension

extension Data: CachableObjectProtocol {
    init(from representingObject: NSData) {
        self = Data(referencing: representingObject)
    }

    var value: NSData {
        return NSData(data: self)
    }
}


// MARK:- CachableObjectKeyProtocol


protocol CachableObjectKeyProtocol {
    associatedtype KeyType: AnyObject

    var key: KeyType { get }
}

// MARK:- CachableObjectKeyProtocol String Extension

extension String: CachableObjectKeyProtocol {
    var key: NSString {
        return NSString(string: self)
    }
}


