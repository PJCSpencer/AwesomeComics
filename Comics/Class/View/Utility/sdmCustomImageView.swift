//
//  sdmCustomImageView.swift
//  Comics
//
//  Created by Peter Spencer on 17/07/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class CustomImageView: UIImageView
{
    // MARK: - Hidden Property(s)
    
    fileprivate var task: URLSessionDataTask?
    
    
    // MARK: - Requesting an Image
    
    func setImage(_ url: URL?, placeholder: UIImage?)
    {
        self.task?.cancel()
        self.task = nil
        
        guard let url = url else
        {
            self.image = placeholder
            return
        }
        
        let request = URLRequest(url: url)
        if let cached = URLSession.shared.configuration.urlCache?.cachedResponse(for: request)
        {
            self.image = UIImage(data: cached.data)
            return
        }
        
        if self.image == nil
        { self.image = placeholder }
        
        self.task = URLSession.shared.dataTask(with: request)
        { [unowned self] (data, response, error) in
            
            guard error == nil,
                let data = data else
            { return }
            
            DispatchQueue.main.async { self.image = UIImage(data: data) }
        }
        self.task?.resume()
    }
}

