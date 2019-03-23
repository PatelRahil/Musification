//
//  MusicRequest.swift
//  Musification
//
//  Created by Rahil Patel on 3/21/19.
//  Copyright © 2019 RahilPatel. All rights reserved.
//

import Foundation

class MusicRequest : HttpRequest {
    private static let rootDbPath = "https://api.music.apple.com/v1/catalog/"
    // can add functionality later to change based on locality
    private static let storefront = "us"
    private static let headerField = "Authorization"
    private static var header: String? {
        if let key = APIKeys.appleMusicKey {
            return "Bearer " + key
        }
        return nil
    }
    static func getGenres(success: @escaping (_ data: [String]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        let urlString = rootDbPath + storefront + "/genres"
        if let header = header {
            let headerField = "Authorization"
            super.makeGetRequest(urlString: urlString, header: header, headerField: headerField, success: { (data) in
                processGenreData(data: data, success: { (genres) in
                    success(genres)
                }, fail: { (error) in
                    fail(error)
                })
            }) { (error) in
                fail(error)
            }
        } else {
            fail(CustomError("Apple music key is not available."))
        }
    }
    private static func processGenreData(data: [String:Any], success: @escaping (_ data: [String]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        if let allGenreData = data["data"] as? [[String:Any]] {
            var genres: [String] = []
            for genreData in allGenreData {
                if let genreAttribute = genreData["attributes"] as? [String:Any] {
                    if let genreName = genreAttribute["name"] as? String {
                        genres.append(genreName)
                    } else {
                        fail(CustomError("Genre attribute does not have a name or name is not a String."))
                    }
                } else {
                    fail(CustomError("Genre data does not have attributes or attributes is not a String:Any pair."))
                }
            }
            success(genres)
        } else {
            fail(CustomError("The data does not have \"data\" or data is not an array of String:Any pairs"))
        }
    }
}
