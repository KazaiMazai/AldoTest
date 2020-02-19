//
//  CoreNetworkCacheDecorator.swift
//  AldoTest
//
//  Created by Sergey Kazakov on 18/02/2020.
//  Copyright © 2020 Piyush Sharma. All rights reserved.
//

import Foundation
import AHNetwork
import EitherResult

final class CoreNetworkCacheDecorator<CoreNetworkType, CacheProviderType> where CoreNetworkType: CoreNetwork,
                                                                                CacheProviderType: CacheProvider,
                                                                                CacheProviderType.Value == Data,
                                                                                CacheProviderType.Key == CachableNetworkRequest {
    private let coreNetwork: CoreNetworkType
    private let cacheProvider: CacheProviderType

    init(coreNetwork: CoreNetworkType, cacheProvider: CacheProviderType) {
        self.coreNetwork = coreNetwork
        self.cacheProvider = cacheProvider
    }
}

// MARK:- CoreNetwork Protocol

extension CoreNetworkCacheDecorator: CoreNetwork {
    func send(request: IRequest, completion: @escaping (ALResult<Data>) -> Void) {
        cacheProvider.retrieveObjectFor(key: request.cachableRequest) { [weak self] in self?.handleResultFromCache($0, for: request, completion: completion) }
    }

    private func handleResultFromCache(_ result: ALResult<CachedResult<Data>>,
                                     for request: IRequest,
                                     completion: @escaping Callback<Data>) {

        result.onError({ completion(.wrong($0)) })
              .do(work: { processCachedResult($0, for: request, completion: completion) })

    }

    private func processCachedResult(_ result: CachedResult<Data>,
                                              for request: IRequest,
                                              completion: @escaping Callback<Data>) {
        switch result {
        case .cached(let data):
            completion(.right(data))
        case .stale, .notFound:
            coreNetwork.send(request: request) { [weak self] in self?.handleResultFromNetwork($0, for: request, completion: completion) }
        }
    }

    private func handleResultFromNetwork(_ result: ALResult<Data>,
                                      for request: IRequest,
                                      completion: @escaping Callback<Data>) {
        result.onError({ completion(.wrong($0)) })
              .do(work: { processDataFromNetworkResponse($0, for: request, completion: completion) })
    }

    private func processDataFromNetworkResponse(_ data: Data,
                                             for request: IRequest,
                                             completion: @escaping Callback<Data>) {
        cacheProvider.addObject(data, for: request.cachableRequest) { completion(.right(data)) }
    }
}

