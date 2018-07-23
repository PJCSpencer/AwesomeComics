//
//  sdmCoreData-Ext.swift
//  Comics
//
//  Created by Peter Spencer on 18/07/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation
import CoreData


protocol FetchRequestMapping
{
    static var entityName: String { get }
}

protocol ValidateFetchRequestProvider
{
    associatedtype DataType: NSFetchRequestResult
    
    static func validateFetchRequest(id: Int64) -> NSFetchRequest<DataType>
}

protocol DataStoreFetchRequestProvider
{
    associatedtype DataType: NSFetchRequestResult
    
    static func dataStoreFetchRequest(_ dataStoreRequest: DataStoreRequest?) -> NSFetchRequest<DataType>?
}

