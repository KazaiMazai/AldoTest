//
//  CachableNetworkRequest.swift
//  AldoTest
//
//  Created by Sergey Kazakov on 19/02/2020.
//  Copyright © 2020 Piyush Sharma. All rights reserved.
//

import Foundation
import AHNetwork
import CryptoKit


extension IRequest {
    var cachableRequest: CachableNetworkRequest {
        return CachableNetworkRequestImpl(baseURL: baseURL, path: path, parameters: parameters)
    }
}



