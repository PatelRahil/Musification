//
//  Genre.swift
//  Musification
//
//  Created by Rahil Patel on 3/23/19.
//  Copyright © 2019 RahilPatel. All rights reserved.
//

import Foundation

class Genre: DataParsable {
    typealias Parsable = Genre
    var name: String = ""
    var id: String = "0"

    required init() {}
    
    func parseData<Parsable>(data genreData: [String : Any], success: @escaping (Parsable) -> Void, fail: @escaping (Error) -> Void) {
        if let genreAttribute = genreData["attributes"] as? [String:Any] {
            if let genreName = genreAttribute["name"] as? String {
                name = genreName
            } else {
                fail(CustomError("Genre attribute does not have a name or name is not a String."))
            }
        } else {
            fail(CustomError("Genre data does not have attributes or attributes is not a String:Any pair."))
        }
        if let genreID = genreData["id"] as? String {
            id = genreID
        } else {
            fail(CustomError("Genre data does not have an id or id is not a String"))
        }
 
        success(self as! Parsable)
    }
}
