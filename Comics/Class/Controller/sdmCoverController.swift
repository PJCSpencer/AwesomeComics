//
//  sdmCoverController.swift
//  Comics
//
//  Created by Peter Spencer on 19/07/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit
import WebKit // Wrong.


class CoverController: UIViewController
{
    // MARK: - Property(s)
    
    var comic: Comic?
    {
        didSet
        {
            // TODO:Support oldValue ...
            
            if let comic = comic
            {
                guard let url = URL(string: comic.cover),
                    let coverView = self.view as? CoverView else
                { return }
                
                coverView.webView.load(URLRequest(url: url))
            }
            else
            {
                UIView.animate(withDuration: 0.3,
                               animations: {
                                
                                self.view.alpha = 0.0
                },
                               completion: { finished in
                                
                                if self.view.superview != nil
                                {
                                    self.removeFromParentViewController()
                                    self.view.removeFromSuperview()
                                }
                })
            }
        }
    }
    
    
    // MARK: - Managing the View
    
    override func loadView()
    {
        self.view = CoverView(frame: UIScreen.main.bounds)
        self.viewRespectsSystemMinimumLayoutMargins = false
        
        if let coverView = self.view as? CoverView
        {
            let gesture = UITapGestureRecognizer(target: self,
                                                 action: #selector(callback(_:)))
            gesture.delegate = self
            coverView.webView.addGestureRecognizer(gesture)
        }
    }
}

// MARK: - Notification Support
extension CoverController
{
    class func notification(_ notification: Notification) -> Void
    {
        guard let comic = notification.object as? Comic,
            let root = UIApplication.shared.keyWindow?.rootViewController else
        { return }
        
        // TODO:Support existing root ...
        
        let controller = CoverController(nibName: nil, bundle: nil)
        controller.view.alpha = 0.0
        controller.comic = comic
        
        root.addChildViewController(controller)
        root.view.addSubview(controller.view)
        
        UIView.animate(withDuration: 0.3)
        { controller.view.alpha = 1.0 }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CoverController: UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    { return true }
}

// MARK: - Action(s)
extension CoverController
{
    @IBAction func callback(_ gesture: UITapGestureRecognizer)
    { self.comic = nil }
}


