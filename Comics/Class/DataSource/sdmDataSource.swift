//
//  sdmDataSource.swift
//  Comics
//
//  Created by Peter Spencer on 19/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


let SDMDataSourceDidSelectNotification = Notification.Name(rawValue: "com.comics.dataSource.didSelect")

protocol DataSourceRegistered
{
    associatedtype RegisterType
    
    func register(_ dataView: RegisterType)
}

class DataSource: NSObject
{
    // MARK: - Property(s)
    
    fileprivate var sections: [DataSourceSectionType] = []
    
    
    // MARK: - Initialisation
    
    init(with objects: [DataSourceSectionType])
    {
        super.init()
        
        self.sections.append(contentsOf: objects)
    }
    
    
    // MARK: - Accessing Sections
    
    func allSections() -> [DataSourceSectionType]
    { return self.sections }
    
    func section(at index: Int) -> DataSourceSectionType?
    {
        if self.sections.count <= 0 { return nil }
        
        if index < 0 { return nil }
        if index >= self.sections.count { return nil }
        
        return self.sections[index]
    }
}

