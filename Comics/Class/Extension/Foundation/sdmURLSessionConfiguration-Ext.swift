//
//  sdmURLSessionConfiguration-Ext.swift
//  Comics
//
//  Created by Peter Spencer on 21/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


extension URLSessionConfiguration
{
    class func small(_ path: String) -> URLSessionConfiguration
    {
        let anObject: URLSessionConfiguration = URLSessionConfiguration.default
        anObject.requestCachePolicy = .useProtocolCachePolicy
        anObject.timeoutIntervalForRequest = 10.0
        anObject.allowsCellularAccess = false
        anObject.waitsForConnectivity = true
        anObject.urlCache = URLCache(memoryCapacity: 1.megabytes(),
                                     diskCapacity: 10.megabytes(),
                                     diskPath: path)
        
        return anObject
    }
}

