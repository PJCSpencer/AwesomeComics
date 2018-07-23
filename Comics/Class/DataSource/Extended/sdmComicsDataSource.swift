//
//  sdmComicsDataSource.swift
//  Comics
//
//  Created by Peter Spencer on 19/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class ComicsDataSource: CollectionViewDataSource {}

// MARK: - UICollectionViewDelegate Protocol
extension ComicsDataSource
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        guard let section = self.section(at: indexPath.section) as? DataSourceSection<Comic> else
        { return }
        
        NotificationCenter.default.post(name: SDMDataSourceDidSelectNotification,
                                        object: section.objects[indexPath.row])
    }
}

