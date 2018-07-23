//
//  sdmAppDelegate.swift
//  Comics
//
//  Created by Peter Spencer on 18/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    // MARK: - Property(s)
    
    var window: UIWindow?
    
    private(set) var dataStore: DataStore = DataStore()


    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        let _ = self.dataStore // Initialise data store.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = ComicsController(nibName: nil, bundle: nil)
        self.window?.backgroundColor = UIColor.lightGray
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

extension UIApplication
{
    var dataStore: DataStore
    { return (UIApplication.shared.delegate as! AppDelegate).dataStore }
}

