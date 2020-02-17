//
//  AHNetworkResponse.swift
//  Pods
//
//  Created by Alex Hmelevski on 2017-06-05.
//
//

import Foundation

public struct AHNetworkResponse {
    public let statusCode: Int
    public let data: Data
    public let response: URLResponse
    
    init?(data: Data?, response: URLResponse?) {
        guard let d = data,
            let r = response else { return nil }
        self.data = d
        self.response = r
        statusCode = (r as? HTTPURLResponse)?.statusCode ?? 200
    }
    
    init(data: Data, response: URLResponse) {
        self.data = data
        self.response = response
        statusCode = (response as? HTTPURLResponse)?.statusCode ?? 200
    }
}
