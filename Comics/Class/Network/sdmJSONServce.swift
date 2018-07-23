//
//  sdmJSONService.swift
//  Comics
//
//  Created by Peter Spencer on 19/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


enum JSONAccessError: Error
{
    case unkown
    case failed
    case badData
}

typealias JSONAccessResponseCallback = (JSONObject?, Error?) -> Void

class JSONService: DataService
{
    func resource(_ request: URLRequest,
                  completion: @escaping JSONAccessResponseCallback)
    {
        let serialise: DataTaskResponseCallback =
        { (taskData, error) in
            
            guard let taskData = taskData,
                taskData.type == .applicationJson,
                let json = try? JSONSerialization.object(with: taskData.data) else
            {
                completion(nil, JSONAccessError.badData)
                return
            }
            completion(json, nil)
        }
        
        guard let task = self.task(request: request,
                                   callbacks: [200:serialise],
                                   status: { _, error in completion(nil, error) }) else
        {
            completion(nil, JSONAccessError.unkown)
            return
        }
        task.resume()
    }
}

