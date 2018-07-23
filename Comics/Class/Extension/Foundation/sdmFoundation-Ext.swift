//
//  sdmFoundation-Ext.swift
//  Comics
//
//  Created by Peter Spencer on 20/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


protocol ObjectMapping
{
    func to() -> Any
    
    func from(_ object: Any)
}

extension Int
{
    func megabytes() -> Int
    {
        return self * 1024 * 1024
    }
}

