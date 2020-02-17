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
}
