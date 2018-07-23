//
//  sdmAPI.swift
//  Comics
//
//  Created by Peter Spencer on 20/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


enum APIPath: String
{
    case comics = "v1/public/comics"
}

enum APISecurityKey: String
{
    case `private` = "private_key"
    case `public` = "public_key"
}

struct APIRequest
{
    let path: String
    let queryItems: [URLQueryItem]
    let cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData // Unsupported.
}

protocol APIRequestProvider
{
    static func apiRequest(queryItems: [URLQueryItem]) -> APIRequest
}

struct APIDataResponse<T>
{
    let objects: [T]
    let indexPaths: [IndexPath]
}

protocol APIFetchRequest
{
    associatedtype APIType
    
    func request(_ request: APIRequest,
                 completion: @escaping ([APIType]) -> Void)
}

class API
{
    // MARK: - Class Utility
    
    class func hash(_ ts: Double) -> String
    { return ts.description + APISecurityKey.private.rawValue + APISecurityKey.public.rawValue }
    
    
    // MARK: - Property(s)
    
    private(set) lazy var jsonAccess: JSONService =
    { [unowned self] in
        
        let configuration = URLSessionConfiguration.small("com.comics.cache.json")
        
        let anObject = JSONService()
        anObject.session = URLSession(configuration: configuration)
        return anObject
    }()
    
    
    // MARK: - Returning API Results Data
    
    func results(_ request: APIRequest,
                 completion: @escaping (JSONCollection) -> Void)
    {
        guard let urlRequest = URLRequest.resource(path: request.path,
                                                   queryItems: request.queryItems) else
        {
            completion([])
            return
        }
        
        self.jsonAccess.resource(urlRequest)
        { (jsonObject, error) in
            
            guard let jsonObject = jsonObject,
                let results = API.compile(jsonObject: jsonObject) as JSONCollection? else
            {
                completion([])
                return
            }
            completion(results)
        }
    }
}

// MARK: - JSONCompilable
extension API: JSONCompilable
{
    enum CompilableKeys: String
    {
        case data, results
    }
    
    static func compile(jsonObject: JSONObject) -> JSONCollection
    {
        guard let data = jsonObject[CompilableKeys.data.rawValue] as? JSONObject,
            let results = data[CompilableKeys.results.rawValue] as? [JSONObject] else
        { return [] }
        
        return results
    }
}

