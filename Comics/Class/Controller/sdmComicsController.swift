//
//  sdmComicsController.swift
//  Comics
//
//  Created by Peter Spencer on 20/07/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class ComicsController: UIViewController
{
    // MARK: - Property(s)
    
    var comicsProvider: ComicsProvider?
    
    
    // MARK: - Creating a View Controller Programmatically
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.comicsProvider = ComicsAPI(dataStore: UIApplication.shared.dataStore)
    }
    
    required init?(coder aDecoder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
     
    deinit
    { NotificationCenter.default.removeObserver(CoverController.self) }
    
    
    // MARK: - Managing the View
    
    override func loadView()
    {
        let rootView = ComicsView(frame: CGRect(origin: .zero, size: ComicsView.fixedSize))
        self.view = rootView
        self.viewRespectsSystemMinimumLayoutMargins = false
        
        self.comicsProvider?.dataSource.register(rootView.collectionView)
        self.comicsProvider?.objects(request: nil, fetch: nil)
        { (response) in
            
            DispatchQueue.main.async
            {
                if let rootView = self.view as? ComicsView
                { rootView.collectionView.reloadData() }
            }
        }
        
        NotificationCenter.default.addObserver(forName: SDMDataSourceDidSelectNotification,
                                               object: nil,
                                               queue: nil,
                                               using: CoverController.notification(_:))
    }
    
    
    // MARK: - Responding to View Events
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        DataStoreRequest.delegate = self
        
        let offset = self.comicsProvider?.dataSource.section(at: 0)?.numberOfObjects() ?? 0
        let queryItems = [URLQueryItem(name: Comic.Keys.offset.rawValue, value: String(offset))]
        
        self.comicsProvider?.objects(request: Comic.apiRequest(queryItems: queryItems),
                                     fetch: DataStoreRequest.delegate?.dataStoreRequest())
        { (response) in
            
            DispatchQueue.main.async
            {
                if let rootView = self.view as? ComicsView
                { rootView.collectionView.insertItems(at: response.indexPaths) }
            }
        }
    }
}

// MARK: - DataStoreRequestDelegate
extension ComicsController: DataStoreRequestDelegate
{
    func dataStoreRequest() -> DataStoreRequest
    {
        let offset: Int = self.comicsProvider?.dataSource.section(at: 0)?.numberOfObjects() ?? 0
        
        return DataStoreRequest(offset: offset,
                                limit: 25,
                                sortDescriptors: nil,
                                predicate: nil)
    }
}


