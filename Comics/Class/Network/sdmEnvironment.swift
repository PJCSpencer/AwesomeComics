//
//  sdmEnvironment.swift
//  Comics
//
//  Created by Peter Spencer on 20/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


enum Environment: String
{
    case staging
    case production
    
    static var current: Environment
    {
        #if STAGING // TODO:Xcode build support ...
        return .staging
        #else
        return .production
        #endif
    }
    
    static var host: String
    {
        switch Environment.current
        {
        case .staging:
            return "127.0.0.1"
        case .production:
            return "gateway.marvel.com"
        }
    }
}

