//
//  CoreNetworkBuilder.swift
//  AldoTest
//
//  Created by Piyush Sharma on 2020-02-17.
//  Copyright © 2020 Piyush Sharma. All rights reserved.
//

import Foundation
import AHNetwork

final class CoreNetworkBuilder {
    let networkInMemoryCacheTimeInterval: TimeInterval = 60
    let networkDiskCacheTimeInterval: TimeInterval = 120

    let session = URLSession(configuration: .default)


    var coreNetwork: CoreNetwork {
        let provider = AHNetworkProvider(session: session)
        return CoreNetworkImp(networkProvider: provider)
    }

/**
     Nested CoreNetworkCacheDecorator are used to provide two layers of cache:  1) in-memory  2) disk.
     Firstly, CoreNework is decorated with disk cache. Then the result is decorated with in-memory cache
*/

    var cachedCoreNetwork: CoreNetwork {
        let diskCacheLayer = DiskCacheProvider<String, Data>(cacheLifespanTimeInterval: networkDiskCacheTimeInterval)
        let diskCacheDecorator = CoreNetworkCacheDecorator(coreNetwork: coreNetwork, cacheProvider: diskCacheLayer)

        let inMemoryCacheLayer = InMemoryCacheProvider<String, Data>(cacheLifespanTimeInterval: networkInMemoryCacheTimeInterval)
        let memoryWithDiskCacheDecorator = CoreNetworkCacheDecorator(coreNetwork: diskCacheDecorator, cacheProvider: inMemoryCacheLayer)

        return memoryWithDiskCacheDecorator
    }
}
