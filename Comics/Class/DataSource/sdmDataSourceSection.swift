//
//  sdmDataSourceSection.swift
//  Comics
//
//  Created by Peter Spencer on 19/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


let CollapsedCellHeight: CGFloat = -1.0

typealias DataSourceSectionType = DataSourceSectionRegister & Countable & DataSourceSectionPresenter

// MARK: - Creating and Indentifing Cell(s)
protocol DataSourceSectionRegister
{
    var cellClass: AnyClass { get }
    
    var reuseIdentifier: String { get }
}

extension DataSourceSectionRegister
{
    var reuseIdentifier: String
    { return String(describing: type(of: self)) }
}

// MARK: - Presenting Cell(s)
protocol DataSourceSectionPresenter
{
    func cell(_ cell: UIView, displayObjectAt index: Int)
    
    func cellSize(forObjectAt index: Int) -> CGSize
}

extension DataSourceSectionPresenter
{
    func cellSize(forObjectAt index: Int) -> CGSize
    { return CGSize.zero }
}

// MARK: - Counting Utility
protocol Countable
{
    func numberOfObjects() -> Int
}

class DataSourceSection<T>
{
    var tag: Int?
    
    var title: String?
    
    var objects: [T] = []
}

