//
//  sdmDataStore.swift
//  Comics
//
//  Created by Peter Spencer on 23/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation
import CoreData


enum DataStoreError: Error
{
    case none
    case unkown
    case success, fail
}

struct DataStoreRequest
{
    let offset: Int
    let limit: Int
    let sortDescriptors: [NSSortDescriptor]?
    let predicate: NSPredicate?
    
    static var delegate: DataStoreRequestDelegate?
}

protocol DataStoreRequestDelegate
{
    func dataStoreRequest() -> DataStoreRequest
}

protocol DataStoreURIStringRepresentation
{
    var absoluteUri: String { get set }
}

protocol DataStoreSerialisation
{
    typealias DataStoreSerialisationCallback = (DataStoreError) -> Void
    
    func cache(fromJSONCollection collection: JSONCollection,
               completion: DataStoreSerialisationCallback?) // Optional closures are escaping: https://bugs.swift.org/browse/SR-4637
}

protocol DataStoreFetchRequest
{
    associatedtype DataType
    
    func fetch(_ request: DataStoreRequest?,
               completion: @escaping ([DataType]) -> Void)
}

class DataStore
{
    // MARK: - Private Property(s)
    
    fileprivate let modelName: String = "Model"
    
    fileprivate lazy var objectModel: NSManagedObjectModel =
    { [unowned self] in
        
        guard let url = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else
        { fatalError("Error finding object model.") }
        
        guard let anObject = NSManagedObjectModel(contentsOf: url) else
        { fatalError("Error loading object model.") }
        
        return anObject
    }()
    
    fileprivate lazy var coordinator: NSPersistentStoreCoordinator =
    { [unowned self] in
        
        let anObject = NSPersistentStoreCoordinator(managedObjectModel: self.objectModel)
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let location = url.appendingPathComponent("\(self.modelName).sqlite")
        
        do
        {
            try anObject.addPersistentStore(ofType: NSSQLiteStoreType,
                                            configurationName: nil,
                                            at: location,
                                            options: nil)
        }
        catch
        { fatalError("Error adding persistent store.") }
        
        return anObject
    }()
    
    fileprivate lazy var mainContext: NSManagedObjectContext =
    { [unowned self] in
        
        let anObject = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        anObject.persistentStoreCoordinator = self.coordinator
        
        return anObject
    }()
    
    fileprivate lazy var privateContext: NSManagedObjectContext =
    { [unowned self] in
        
        let anObject = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        anObject.parent = self.mainContext
        
        return anObject
    }()
    
    
    // MARK: - Deinitializing
    
    deinit
    {
        do
        { try self.save() }
        catch
        { fatalError("Error deinitializing main context.") }
    }
    
    
    // MARK: - Utility
    
    func createBackgroundContext() -> NSManagedObjectContext
    {
        let anObject = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        anObject.parent = self.mainContext
        return anObject
    }
    
    
    // MARK: - Operation(s)
    
    func insert<T, U>(_ objectType: T.Type,
                      template: U,
                      completion: @escaping (URL?, DataStoreError) -> Void) where T: NSManagedObject, T: ObjectMapping
    {
        self.privateContext.performAndWait
        {
            do
            {
                let name = String(describing: T.self)
                let object = NSEntityDescription.insertNewObject(forEntityName: name,
                                                                 into: self.privateContext) as! T
                object.from(template)
                try self.save()
                
                completion(object.objectID.uriRepresentation(),
                           .success)
            }
            catch
            { completion(nil, .fail) }
        }
    }
    
    func fetch<T, U>(_ request: NSFetchRequest<T>,
                     mapTo: U.Type,
                     completion: @escaping ([U], DataStoreError?) -> Void) where T: NSManagedObject, T: ObjectMapping
    {
        self.privateContext.performAndWait
        {
            do
            {
                let results = try self.privateContext.fetch(request).map { $0.to() }
                guard let objects = results as? [U] else
                {
                    completion([], .fail)
                    return
                }
                completion(objects, .success)
            }
            catch
            { completion([], .fail) }
        }
    }
    
    func execute<T, U>(_ request: NSFetchRequest<T>,
                       mapTo: U.Type,
                       completion: @escaping ([U], DataStoreError?) -> Void) where T: NSManagedObject, T: ObjectMapping
    {
        self.privateContext.performAndWait
        {
            do
            {
                let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: request)
                { asyncResult in
                    
                    guard let results = asyncResult.finalResult else
                    {
                        completion([], .fail)
                        return
                    }
                    
                    var buffer: [U] = []
                    for fault in results
                    {
                        guard let object = self.mainContext.object(with: fault.objectID) as? T,
                            let mapped =  object.to() as? U else
                        { continue }
                        
                        buffer.append(mapped)
                    }
                    completion(buffer, .success)
                }
                
                try privateContext.execute(asyncRequest)
            }
            catch
            { completion([], .fail) }
        }
    }
    
    func update<T, U>(_ request: NSFetchRequest<T>,
                      source: U,
                      completion: @escaping (DataStoreError?) -> Void) where T: NSManagedObject, T: ObjectMapping
    {
        self.privateContext.performAndWait
        {
            do
            {
                let results = try self.privateContext.fetch(request)
                guard let object = results.first else
                {
                    completion(.fail)
                    return
                }
                
                object.from(source)
                try self.save()
                
                completion(.success)
            }
            catch
            { completion(.fail) }
        }
    }
    
    func delete<T: NSManagedObject>(_ request: NSFetchRequest<T>,
                                    completion: @escaping (DataStoreError) -> Void)
    {
        self.privateContext.performAndWait
        {
            do
            {
                guard let object = try self.privateContext.fetch(request).first else
                {
                    completion(.fail)
                    return
                }
                
                self.privateContext.delete(object)
                try self.save()
                
                completion(.success)
            }
            catch
            { completion(.fail) }
        }
    }
    
    fileprivate func save() throws
    {
        var saveError: Error?
        
        self.privateContext.performAndWait
        {
            if self.privateContext.hasChanges
            {
                do
                { try self.privateContext.save() }
                catch
                { saveError = error }
            }
        }
        
        self.mainContext.performAndWait
        {
            if self.mainContext.hasChanges
            {
                do
                { try self.mainContext.save() }
                catch
                { saveError = error }
            }
        }
        
        if let saveError = saveError
        { throw saveError }
    }
}

