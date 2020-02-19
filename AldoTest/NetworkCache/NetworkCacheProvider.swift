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

protocol NetworkCacheProvider {
    func retrieve(request: IRequest, completion: @escaping Callback<CachedResult<Data>>)
    func addToCache(_ data: Data, for request: IRequest, completion: @escaping () -> Void)
}
