//
//  sdmComicsCollectionViewCell.swift
//  Comics
//
//  Created by Peter Spencer on 17/07/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class ComicsCollectionViewCell: UICollectionViewCell
{
    // MARK: - Property(s)
    
    private(set) lazy var imageView: CustomImageView =
    { [unowned self] in
        
        let anObject = CustomImageView(frame: .zero)
        anObject.contentMode = .scaleAspectFit
        anObject.backgroundColor = UIColor.white
        anObject.layer.borderColor = UIColor.white.cgColor
        anObject.layer.borderWidth = 3.0
        anObject.layer.shadowOpacity = 0.3 /* Not really neccessary, but lifts it off the background. */
        anObject.layer.shadowRadius = 3.0
        
        self.contentView.addSubview(anObject)
        return anObject
    }()
    
    
    // MARK: - Laying out Subviews
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.imageView.frame = self.contentView.bounds
    }
}

// MARK: - Geometry Protocol
extension ComicsCollectionViewCell: Geometry
{
    static var fixedSize: CGSize
    { return CGSize(width: 94, height: 140).pscale(.iPhone6Plus) }
}

