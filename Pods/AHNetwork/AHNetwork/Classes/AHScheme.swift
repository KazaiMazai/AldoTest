//
//  AHScheme.swift
//  Pods
//
//  Created by Alex Hmelevski on 2017-06-05.
//
//

import Foundation

public enum AHScheme {
    case http
    case https
    
    var string: String {
        let str: String
        switch  self {
            case .http: str = "http"
            case .https: str = "https"
        }
        return str
    }
}
