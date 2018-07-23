//
//  sdmComicsAPI.swift
//  Comics
//
//  Created by Peter Spencer on 20/07/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


protocol ComicsProvider
{
    var dataSource: ComicsDataSource  { get }
    
    func objects(request: APIRequest?,
                 fetch: DataStoreRequest?,
                 completion: @escaping (APIDataResponse<Comic>) -> Void)
}

class ComicsAPI: API, ComicsProvider
{
    // MARK: - Property(s)
    
    var dataStore: DataStore?
    
    
    // MARK: - Initialisation
    
    init(dataStore: DataStore)
    { self.dataStore = dataStore }
    
    
    // MARK: - ComicsProvider Protocol
    
    private(set) lazy var dataSource: ComicsDataSource =
    { [unowned self] in
        
        let section = ComicsDataSourceSection()
        let anObject = ComicsDataSource(with: [section])
        
        return anObject
    }()
    
    func objects(request: APIRequest?,
                 fetch: DataStoreRequest?,
                 completion: @escaping (APIDataResponse<Comic>) -> Void)
    {
        guard let request = request else
        {
            self.fetch(fetch)
            { (indexPaths) in
                
                completion(APIDataResponse(objects: [], indexPaths: indexPaths))
            }
            return
        }
        
        self.results(request)
        { [weak self] results in
            
            self?.cache(fromJSONCollection: results, completion: nil)
            
            self?.fetch(fetch)
            { (indexPaths) in
                
                completion(APIDataResponse(objects: [], indexPaths: indexPaths))
            }
        }
    }
}

// MARK: - DataStoreSerialisation
extension ComicsAPI: DataStoreSerialisation
{
    func cache(fromJSONCollection collection: JSONCollection,
               completion: ((DataStoreError) -> Void)?)
    {
        for jsonObject in collection
        {
            guard let template = Comic.compile(jsonObject: jsonObject) else
            { continue }
            
            let fetchRequest = ComicMO.validateFetchRequest(id: template.id)
            
            self.dataStore?.fetch(fetchRequest, mapTo: Comic.self)
            { (results, _) in
                
                if let source = results.first
                {
                    self.dataStore?.update(fetchRequest, source: source) { (_) in }
                    return
                }
                
                self.dataStore?.insert(ComicMO.self, template: template) { (_, _) in }
            }
        }
    }
}

// MARK: - DataStoreFetchRequest
extension ComicsAPI: DataStoreFetchRequest
{
    func fetch(_ dataStoreRequest: DataStoreRequest?,
               completion: @escaping ([IndexPath]) -> Void)
    {
        guard let fetchRequest = ComicMO.dataStoreFetchRequest(dataStoreRequest) else
        {
            completion([])
            return
        }
        
        self.dataStore?.fetch(fetchRequest, mapTo: Comic.self)
        { (results, _) in
            
            if results.count <= 0
            {
                completion([])
                return
            }
            
            if let section = self.dataSource.section(at: 0) as? DataSourceSection<Comic>
            { section.objects.append(contentsOf: results) }
            
            let start = fetchRequest.fetchOffset
            let end = start + (results.count-1)
            let indexPaths = Array(start...end).map { IndexPath(item: $0, section: 0) }
            
            completion(indexPaths)
        }
    }
}


