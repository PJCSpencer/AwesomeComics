//
//  sdmActivityView.swift
//  Comics
//
//  Created by Peter Spencer on 20/07/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


enum Activity
{
    case on, off
}

class ActivityView: UIView
{
    // MARK: - Property(s)
    
    var contentView: UIView?
    {
        didSet
        {
            oldValue?.removeFromSuperview()
            
            if let subview = contentView
            { self.addSubview(subview) }
            
            self.layoutSubviews()
        }
    }
    
    private(set) lazy var backroundView: UIView =
    { [unowned self] in
        
        let anObject = UIView(frame: .zero)
        anObject.backgroundColor = UIColor.black
        anObject.alpha = 0.8
        
        self.addSubview(anObject)
        return anObject
    }()
    
    
    // MARK: - Hidden Property(s)
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView =
    { [unowned self] in
        
        let anObject = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        self.insertSubview(anObject, aboveSubview: self.backroundView)
        return anObject
    }()
    
    
    // MARK: - Setting Activity 
    
    func setActivity(_ activity: Activity, animated: Bool)
    {
        if animated
        {
            UIView.animate(withDuration: 0.3)
            {
                self.activityIndicator.alpha = activity == .on ? 1.0 : 0.0
                self.contentView?.alpha = activity == .on ? 0.0 : 1.0
            }
        }
        else
        {
            self.activityIndicator.alpha = activity == .on ? 1.0 : 0.0
            self.contentView?.alpha = activity == .on ? 0.0 : 1.0
        }
        
        switch activity
        {
        case .on:
            self.activityIndicator.startAnimating()
        case .off:
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    // MARK: - Creating a View Object
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.updateLayout(nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - Laying out Subviews
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.backroundView.frame = self.bounds
        self.contentView?.frame = self.bounds
    }
}

// MARK: - GeometryLayout Protocol
extension ActivityView: GeometryLayout
{
    func updateLayout(_ container: UIView?)
    {
        let guide = self.layoutMarginsGuide
        
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
    }
}

