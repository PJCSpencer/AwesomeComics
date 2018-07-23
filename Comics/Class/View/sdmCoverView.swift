//
//  sdmCoverView.swift
//  Comics
//
//  Created by Peter Spencer on 20/07/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit
import WebKit


class CoverView: ActivityView
{
    // MARK: - Property(s)
    
    private(set) lazy var webView: WKWebView =
    { [unowned self] in
        
        let anObject = WKWebView(frame: .zero)
        anObject.isOpaque = false
        anObject.backgroundColor = .clear
        anObject.scrollView.backgroundColor = .clear
        
        return anObject
    }()
    
    
    // MARK: - Hidden Property(s)
    
    fileprivate var observation: NSKeyValueObservation?
    
    
    // MARK: - Creating a View Object
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.contentView = self.webView
        self.observation = self.webView.observe(\.isLoading, options: [.new, .old])
        { [weak self] (_, change) in
            
            if let status = change.newValue, status == true
            { self?.setActivity(.on, animated: true) }
            else
            { self?.setActivity(.off, animated: true) }
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
    
    deinit
    { self.observation?.invalidate() }
}

