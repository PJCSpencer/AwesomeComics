//
//  sdmComicMO.swift
//  Comics
//
//  Created by Peter Spencer on 29/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//
//

import Foundation
import CoreData


public class ComicMO: NSManagedObject {}

// MARK: - FetchRequestMapping
extension ComicMO: FetchRequestMapping 
{
    static var entityName: String = "ComicMO"
}

// MARK: - ObjectMapping
extension ComicMO: ObjectMapping
{
    func to() -> Any
    {
        return Comic(id: self.id,
                     thumbnail: self.thumbnail!,
                     cover: self.cover!)
    }
    
    func from(_ object: Any) /* TODO:Support throws ... */
    {
        guard let object = object as? Comic else
        { return }
        
        self.id = object.id
        self.thumbnail = object.thumbnail
        self.cover = object.cover
    }
}

