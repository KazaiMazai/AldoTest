//
//  AHNetworkProvider.swift
//  Pods
//
//  Created by Alex Hmelevski on 2017-06-05.
//
//

import Foundation
import EitherResult
import Combine

enum NetworkProviderError: Error {
    case imposibleToSendTask
}

public typealias progressTracker = (Double) -> Void
public typealias completionHandler = (ALResult<AHNetworkResponse>) -> Void

public protocol INetworkProvider {
    @discardableResult
    func send(_ request: IRequest, completion: completionHandler?, progress: progressTracker?) -> ICancellable
    @available(iOS 13.0, *)
    func send(_ request: IRequest) -> AnyPublisher<AHNetworkResponse, URLError>
}


struct NetworkTaskRequest {
    let urlRequest: URLRequest
    let type: AHTaskType
}

public class AHNetworkProvider: INetworkProvider {

    fileprivate let adapter: IRequestAdapter = AHRequestAdapter()
    fileprivate let sender: BasicTaskNode
    
    public init(session: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        sender = BasicTaskNode.createChain(from: [RequestTaskNode.self, DownloadTaskNode.self], using: session)
    }
    
    @available(iOS 13.0, *)
    public func send(_ request: IRequest) -> AnyPublisher<AHNetworkResponse, URLError> {
        let nRequest = NetworkTaskRequest(urlRequest: adapter.urlRequest(for: request), type: request.taskType)
        return sender.send(request: nRequest)
    }

    
    @discardableResult
    public func send(_ request: IRequest,
                     completion: completionHandler?,
                     progress: progressTracker? = nil) -> ICancellable {
        let nRequest = NetworkTaskRequest(urlRequest: adapter.urlRequest(for: request), type: request.taskType)
        return sender.send(request: nRequest,
                           completion: completion,
                           progress:progress)
    }
}


