//
//  sdmComic.swift
//  Comics
//
//  Created by Peter Spencer on 23/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


struct Comic
{
    enum Keys: String
    {
        case offset
    }
    
    let id: Int64
    let thumbnail: String
    let cover: String
}

extension Comic: JSONCompilable
{
    enum CompilableKeys: String
    {
        case id
        case thumbnail, cover
        case path, `extension`
    }
    
    static func compile(jsonObject: JSONObject) -> Comic?
    {
        guard let id = jsonObject[CompilableKeys.id.rawValue] as? Int64,
            let thumbnail = jsonObject[CompilableKeys.thumbnail.rawValue] as? JSONObject,
            let path = thumbnail[CompilableKeys.path.rawValue] as? String,
            let ext = thumbnail[CompilableKeys.extension.rawValue] as? String else
         { return nil }
        
        return Comic(id: id,
                     thumbnail: path + "/portrait_medium." + ext,
                     cover: path + "." + ext)
    }
}

// MARK: - APIRequestProvider
extension Comic: APIRequestProvider
{
    static func apiRequest(queryItems: [URLQueryItem]) -> APIRequest
    {
        var buffer: [URLQueryItem] = []
        
        if let path = Bundle.main.path(forResource: "comics", ofType: "json"),
            let jsonObject = URLQueryItem.load(contentsOfFile: path)
        {
            buffer = URLQueryItem.compile(jsonObject: jsonObject)
        }
        
        // https://github.com/apple/swift-evolution/blob/master/proposals/0056-trailing-closures-in-guard.md
        if let offset = queryItems.filter({ $0.name == Comic.Keys.offset.rawValue }).first
        { buffer.append(offset) }
        
        return APIRequest(path: "/\(APIPath.comics.rawValue)",
            queryItems: buffer)
    }
}

