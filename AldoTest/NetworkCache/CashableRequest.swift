//
//  CashableRequest.swift
//  AldoTest
//
//  Created by Sergey Kazakov on 19/02/2020.
//  Copyright © 2020 Piyush Sharma. All rights reserved.
//

import Foundation
import CryptoKit

protocol CachableNetworkRequest {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: String] { get }
}

struct CachableNetworkRequestImpl: CachableNetworkRequest {
    var baseURL: String
    var path: String
    var parameters: [String : String]
}

extension CachableNetworkRequest {
    var hashString: String {
        let parametersString = parameters.map { return "\($0.0):\($0.1)" }.joined(separator: ",")
        let stringToUseForHash = [baseURL, path, parametersString].joined(separator: ";")
        return MD5(string: stringToUseForHash)
    }

    private func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
