//
//  CoreNetwork.swift
//  AldoTest
//
//  Created by Piyush Sharma on 2020-02-17.
//  Copyright © 2020 Piyush Sharma. All rights reserved.
//

import Foundation
import AHNetwork
import EitherResult

typealias Callback<T> = (ALResult<T>) -> Void

protocol CoreNetwork {
    func send(request: IRequest, completion: @escaping (ALResult<Data>) -> Void)
}

/**
    CoreNetwork class sends IRequest using AHNetwork library.
 
    Checks the status of response and when it's not 200 returns CoreNetworkError which
    contains Response
 
 The next sequence diagram should help understand all the connection for the class
 
 ![Sequence diagram](https://user-images.githubusercontent.com/24896943/34316502-ddc63fe6-e764-11e7-92b3-3d4ca4b08d32.png "Sequence diagram")
 
 */

final class CoreNetworkImp: CoreNetwork {

    private let provider: INetworkProvider

    init(networkProvider: INetworkProvider) {
        provider = networkProvider
    }

    /// Sends IRequest
    ///
    /// Performs status check
    /// - Parameters:
    ///   - request: request that conforms to IRequest
    ///   - completion: ALResult<Data>
    func send(request: IRequest, completion: @escaping Callback<Data>) {
        provider.send(request,
                      completion: { [weak self] in self?.processResult($0, completion: completion) },
                      progress: nil)
    }

    private func processResult(_ result: ALResult<AHNetworkResponse>,
                               completion: @escaping Callback<Data>) {
        result.onError({ completion(.wrong($0)) })
              .do(work: { self.proccess(response: $0, with: completion) })
    }

    private func proccess(response: AHNetworkResponse,
                          with completion: @escaping (ALResult<Data>) -> Void) {

        convertToError(networkResponse: response).do(work: { completion(.wrong($0)) })
                                                 .doIfNone { completion(.right(response.data)) }
    }

    private func convertToError(networkResponse: AHNetworkResponse) -> CoreNetworkError? {
        guard networkResponse.statusCode != 200  else { return nil }
        return .responseError(networkResponse)
    }
}

enum CoreNetworkError: LocalizedError {
    case timeout
    case responseError(AHNetworkResponse)

    var errorDescription: String? {
        var msg: String

        switch self {
        case .timeout:
            msg = "Response timeout"
        case let .responseError(networkResponse):
            msg = "Network status response: \(String(networkResponse.statusCode))"
        }

        return msg
    }
}
