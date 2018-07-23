//
//  sdmComicMO+Properties.swift
//  Comics
//
//  Created by Peter Spencer on 29/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//
//

import Foundation
import CoreData


extension ComicMO
{
    @NSManaged public var id: Int64
    @NSManaged public var cover: String?
    @NSManaged public var thumbnail: String?
}

// MARK: - ValidateFetchRequestProvider
extension ComicMO: ValidateFetchRequestProvider
{
    static func validateFetchRequest(id: Int64) -> NSFetchRequest<ComicMO>
    {
        let fetchRequest = NSFetchRequest<ComicMO>(entityName: ComicMO.entityName)
        fetchRequest.predicate = NSPredicate(format: "%K == %d",
                                             Comic.CompilableKeys.id.rawValue,
                                             id)
        return fetchRequest
    }
}

// MARK: - DataStoreFetchRequestProvider
extension ComicMO: DataStoreFetchRequestProvider
{
    static func dataStoreFetchRequest(_ dataStoreRequest: DataStoreRequest?) -> NSFetchRequest<ComicMO>?
    {
        guard let dataStoreRequest = dataStoreRequest else
        { return NSFetchRequest<ComicMO>(entityName: ComicMO.entityName) }
        
        let fetchRequest = NSFetchRequest<ComicMO>(entityName: ComicMO.entityName)
        fetchRequest.fetchOffset = dataStoreRequest.offset
        fetchRequest.fetchLimit = dataStoreRequest.limit
        fetchRequest.sortDescriptors = dataStoreRequest.sortDescriptors
        fetchRequest.predicate = dataStoreRequest.predicate
        
        return fetchRequest
    }
}

