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

    let session = URLSession(configuration: .default)

    var coreNetwork: CoreNetwork {
        let provider = AHNetworkProvider(session: session)
        return CoreNetworkImp(networkProvider: provider)
    }

    var cachedCoreNetwork: CoreNetwork {
        let inMemoryCacheLayer = InMemoryCacheProvider<String, Data>(cacheLifespanTimeInterval: 60)
        let diskCacheLayer = DiskCacheProvider<String, Data>(cacheLifespanTimeInterval: 60)
        let diskCacheDecorator = CoreNetworkCacheDecorator(coreNetwork: coreNetwork, cacheProvider: diskCacheLayer)
        let memoryWithDiskCacheDecorator = CoreNetworkCacheDecorator(coreNetwork: diskCacheDecorator, cacheProvider: inMemoryCacheLayer)

        return memoryWithDiskCacheDecorator
    }
}
