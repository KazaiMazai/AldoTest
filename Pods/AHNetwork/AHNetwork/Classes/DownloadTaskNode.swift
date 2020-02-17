//
//  DownloadTaskNode.swift
//  AHFuture
//
//  Created by Esteban Garro on 2019-01-10.
//

import Foundation

class DownloadTaskNode: BasicTaskNode {
    var downloadAdapter: INetworkDownloadAdapter = AHNetworkResponseAdapter()
    var observation: NSKeyValueObservation?
    
    override func send(request: NetworkTaskRequest, completion: completionHandler?, progress: progressTracker?) -> ICancellable {
        guard case .download = request.type else {
            return super.send(request: request, completion: completion, progress: progress)
        }

        let task = session.downloadTask(with: request.urlRequest, completionHandler:{ (localURL, response, error) in
            self.downloadAdapter.response(from: localURL, with: response, and: error)
                                .do(work: { completion?(.right($0)) })
                                .doIfWrong(work: { completion?(.wrong($0))})
        })
        
        task.resume()
        observation = task.observe(\.progress.fractionCompleted, options: .new) { (downloadTask, _) in
            progress?(downloadTask.progress.fractionCompleted)
        }
        return task
    }
}
