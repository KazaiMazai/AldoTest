//
//  AHMethod.swift
//  Pods
//
//  Created by Alex Hmelevski on 2017-06-05.
//
//

import Foundation

public enum AHMethod: String {
    case post
    case get
    case put
    case patch
    case delete
    
    var string: String {
       return self.rawValue.uppercased()
    }
}
