//
//  sdmDataService.swift
//  Comics
//
//  Created by Peter Spencer on 20/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


typealias DataTaskResponseCallback = (TaskData?, Error?) -> Void

class DataService /* TODO:Support protocol ... */
{
    // MARK: - Property(s)
    
    var session: URLSession?
    
    
    // MARK: - Creating a Data Task
    
    func task(request: URLRequest,
              callbacks: [Int:DataTaskResponseCallback] = [:],
              status: @escaping DataTaskResponseCallback) -> URLSessionTask?
    {
        guard let session = self.session else
        { return nil }
        
        let task: URLSessionDataTask = session.dataTask(with: request)
        { (data, response, error) in
            
            guard error == nil,
                let response = response as? HTTPURLResponse else
            {
                status(nil, SessionServiceError.unkown)
                return
            }
            
            let statusCode = response.statusCode
            let serviceError = SessionServiceError.status(statusCode)
            
            guard let callback = callbacks[statusCode] else
            {
                status(nil, serviceError)
                return
            }
            
            guard let contentType = response.allHeaderFields[HTTPKeys.contentType.rawValue] as? String,
                let data = data  else
            {
                status(nil, serviceError) /* TODO:Which function callback/status ..? */
                return
            }
            
            let mediaType = ContentType.mediaType(from: contentType)
            guard mediaType != .unkown else
            {
                status(nil, SessionServiceError.unkownData)
                return
            }
            
            callback(TaskData(data: data, type: mediaType), serviceError)
        }
        return task
    }
}

