//
//  sdmComicsView.swift
//  Comics
//
//  Created by Peter Spencer on 18/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class ComicsView: UIView
{
    // MARK: - Property(s)
    
    private(set) lazy var collectionView: UICollectionView =
    { [unowned self] in
        
        let anObject = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        anObject.showsVerticalScrollIndicator = false
        anObject.isScrollEnabled = true
        anObject.bounces = true
        anObject.alwaysBounceVertical = true
        anObject.clipsToBounds = false
        anObject.backgroundColor = UIColor.clear
        anObject.contentInset = UIEdgeInsets(top: 12.0, left: 30, bottom: 24.0, right: 30) // TODO:Support geometry scaling ...
        
        self.insertSubview(anObject, aboveSubview: self.imageView)
        return anObject
    }()
    
    private(set) lazy var imageView: UIImageView =
    { [unowned self] in
        
        let anObject = UIImageView(image: UIImage(named: "space"))
        anObject.contentMode = .scaleAspectFill
        
        self.addSubview(anObject)
        return anObject
    }()
    
    
    // MARK: -
    
    fileprivate lazy var layout: UICollectionViewFlowLayout =
    { [unowned self] in
        
        let anObject = UICollectionViewFlowLayout()
        anObject.itemSize = ComicsCollectionViewCell.fixedSize
        anObject.scrollDirection = .vertical
        anObject.minimumInteritemSpacing = ComicsView.marginSize.height
        anObject.minimumLineSpacing = ComicsView.marginSize.width
        
        return anObject
    }()
    
    
    // MARK: - Creating a View Object
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.white
        self.layoutMargins = .zero
        self.updateLayout(nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - Laying out Subviews
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.imageView.frame = self.bounds
    }
}

// MARK: - Geometry Protocol
extension ComicsView: Geometry
{
    static var fixedSize: CGSize
    {
        let width: CGFloat = UIScreen.main.bounds.insetBy(dx: 12, dy: 0).width
        let height: CGFloat = UIScreen.main.bounds.height
        
        return CGSize(width: width, height: height).scale(.iPhone6Plus)
    }
}

// MARK: - GeometrySpacing Protocol
extension ComicsView: GeometrySpacing
{
    static var marginSize: CGSize
    {
        let dim: CGFloat = 18.0
        return CGSize(width: dim, height: 0).scale(.iPhone6Plus)
    }
}

// MARK: - GeometryLayout Protocol
extension ComicsView: GeometryLayout
{
    func updateLayout(_ container: UIView?)
    {
        let guide = self.layoutMarginsGuide
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 0).isActive = true
        self.collectionView.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: 0).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
}

