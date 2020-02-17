//
//  BasicTaskNode.swift
//  Pods
//
//  Created by Alex Hmelevski on 2017-06-05.
//
//

import Foundation
import Combine
protocol INetworkTaskNode {
    init(session: URLSession)
    func send(request: NetworkTaskRequest, completion: completionHandler?, progress: progressTracker?) -> ICancellable
}

@available(iOS 13.0, *)
protocol INetworkTaskNodePublisher {
    func send(request: NetworkTaskRequest) -> AnyPublisher<AHNetworkResponse,URLError> 
}

extension URLSessionTask: ICancellable {}

public protocol ICancellable {
    func cancel()
}

class BasicTaskNode: INetworkTaskNode, INetworkTaskNodePublisher {
    let session: URLSession
    private var nextLink: BasicTaskNode?
    
    required init(session: URLSession) {
        self.session = session
    }
    
    func send(request: NetworkTaskRequest, completion: completionHandler?, progress: progressTracker?) -> ICancellable {
        guard let cancellable = nextLink?.send(request: request, completion: completion, progress: progress) else {
            fatalError("Cancellable hasn't been returned")
        }
        return cancellable
    }
    
    @available(iOS 13.0, *)
    func send(request: NetworkTaskRequest) -> AnyPublisher<AHNetworkResponse,URLError>  {
        guard let future = nextLink?.send(request: request) else {
          fatalError("Cancellable hasn't been returned")
        }
        return future
    }
    
    static func createChain(from types: [BasicTaskNode.Type], using session: URLSession) -> BasicTaskNode {
        let result = types.reversed().reduce(nil) { (result, type) -> BasicTaskNode? in
            var link = result
            let existingLink = link
            link = type.init(session: session)
            link?.nextLink = existingLink
            return link
        }
        guard let l = result else {
            fatalError("Couldn't create chain from array")
        }
        return l
    }
    
}

