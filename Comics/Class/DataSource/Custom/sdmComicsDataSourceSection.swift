//
//  sdmComicsDataSourceSection.swift
//  Comics
//
//  Created by Peter Spencer on 22/07/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class ComicsDataSourceSection: DataSourceSection<Comic>
{
    enum Keys: String
    {
        case title
    }
}

extension ComicsDataSourceSection: Countable
{
    func numberOfObjects() -> Int
    { return self.objects.count }
}

extension ComicsDataSourceSection: DataSourceSectionRegister
{
    var cellClass: AnyClass
    { return ComicsCollectionViewCell.self }
}

extension ComicsDataSourceSection: DataSourceSectionPresenter
{
    func cell(_ cell: UIView, displayObjectAt index: Int)
    {
        guard let cell = cell as? ComicsCollectionViewCell else
        { return }
        
        cell.imageView.setImage(URL(string: self.objects[index].thumbnail),
                                placeholder: UIImage(named: "placeholder"))
    }
}

