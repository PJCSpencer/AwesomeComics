//
//  sdmSessionSupport.swift
//  Comics
//
//  Created by Peter Spencer on 22/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


enum SessionServiceError: Error
{
    case failed, unkown, badResponse, unkownData
    
    // 200.
    case success
    
    // 300.
    case redirection
    
    // 400.
    case clientError
    case badRequest, unauthorized, forbidden, notFound, requestTimeout
    
    // 500.
    case serverError
    case internalServerError, notImplemented, serviceUnavailable
    case permissionDenied
    
    static func status(_ statusCode: Int) -> SessionServiceError
    {
        switch statusCode
        {
        case 200...208:
            return .success
        case 300...308:
            return .redirection
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 405...407:
            return .clientError
        case 408:
            return .requestTimeout
        case 409...451:
            return .clientError
        case 500:
            return .internalServerError
        case 501:
            return .notImplemented
        case 502:
            return .serverError
        case 503:
            return .serviceUnavailable
        case 504...511:
            return .serverError
        case 550:
            return .permissionDenied
        default:
            return .failed
        }
    }
}

enum HTTPScheme: String
{
    case http       = "http"
    case https      = "https"
}

enum HTTPMethod: String
{
    case options    = "OPTIONS"
    case get        = "GET"
    case post       = "POST"
}

enum HTTPKeys: String
{
    case contentType = "Content-Type"
}

enum ContentType
{
    case unkown
    case textHtml, textPlain
    case imageJpeg, imagePng
    case applicationJson
    case urlencoded
    
    static let text: [ContentType]          = [.textHtml, .textPlain]
    static let image: [ContentType]         = [.imageJpeg, .imagePng]
    
    static let support: [String:ContentType] =
    [
        "text/plain"                        : .textPlain,
        "text/html"                         : .textHtml,
        "image/jpeg"                        : .imageJpeg,
        "image/png"                         : .imagePng,
        "application/json"                  : .applicationJson,
        "application/x-www-form-urlencoded" : .urlencoded
    ]
    
    static func mediaType(from string: String?) -> ContentType
    {
        guard let string = string else
        { return .unkown }
        
        var mediaType = string.trimmingCharacters(in: .whitespaces)
        if let leading = string.split(separator: ";").first
        { mediaType = String(leading) }
        
        guard let result = ContentType.support[mediaType] else
        { return .unkown }
        
        return result
    }
}

struct TaskData
{
    let data: Data?
    let type: ContentType
}

