//
//  HttpRequest.swift
//  Musification
//
//  Created by Rahil Patel on 3/21/19.
//  Copyright © 2019 RahilPatel. All rights reserved.
//

import Foundation

class HttpRequest {
    static func makeGetRequest(urlString: String, header: String, headerField: String, success: @escaping (_ data: [String:Any]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        if let dbURL = URL(string: urlString) {
            var dbRequest = URLRequest(url: dbURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            dbRequest.httpMethod = "GET"
            dbRequest.addValue(header, forHTTPHeaderField: headerField)
            let task = URLSession.shared.dataTask(with: dbRequest) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                        if let data = json as? [String:Any] {
                            success(data)
                        } else {
                            fail(CustomError("JSON data from HTTP request was not an dictionary of [String:Any]"))
                        }
                    } catch {
                        fail(error)
                    }
                } else {
                    fail(CustomError("Data from HTTP request is null."))
                }
            }
            task.resume()
        } else {
            fail(CustomError("Bad URL string"))
        }
    }
}

struct CustomError : LocalizedError {
    var errorDescription: String? { return mMsg }
    var failureReason: String? { return mMsg }
    var recoverySuggestion: String? { return "" }
    var helpAnchor: String? { return "" }
    
    private var mMsg : String
    
    init(_ description: String)
    {
        mMsg = description
    }
}
