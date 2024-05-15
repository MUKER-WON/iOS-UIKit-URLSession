//
//  EndPointType.swift
//  iOS-UIKit-URLSession
//
//  Created by Muker on 5/15/24.
//

import Foundation

protocol EndPointType {
    var schme: Scheme { get }
    var host: String { get }
    var port: Int? { get }
    var path: String? { get }
    var query: [String: String] { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var body: [String: Any]? { get }
}

extension EndPointType {
    func configureURLRequest() -> URLRequest? {
        var urlComponent = URLComponents()
        urlComponent.scheme = schme.rawValue
        urlComponent.host = host
        urlComponent.port = port ?? nil
        urlComponent.path = path ?? ""
        urlComponent.queryItems = query.map {
            .init(name: $0, value: $1)
        }
        guard let urlString = urlComponent.url?
            .absoluteString.replacingOccurrences(of: "%25", with: "%"),
              let url = URL(string: urlString)
        else { return nil}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = header
        
        do {
            let bodyData = try JSONSerialization.data(withJSONObject: body ?? [:])
            urlRequest.httpBody = bodyData
        } catch {
            print(error.localizedDescription)
        }
        
        return urlRequest
    }
}

enum Scheme: String {
    case http
    case https
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case poset = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}


