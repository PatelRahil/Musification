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
    
    static func getGenres(success: @escaping (_ genres: [Genre]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        let urlString = rootDbPath + storefront + "/genres"
        if let header = header {
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
    static func getSongs(genreID: String, limit: Int, success: @escaping (_ songs: [Song]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        let urlString = rootDbPath + storefront + "/charts?types=songs&genre=\(genreID)&limit=\(limit)"
        if let header = header {
            super.makeGetRequest(urlString: urlString, header: header, headerField: headerField, success: { (data) in
                processSongData(data: data, success: { (songs) in
                    success(songs)
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
    static func getArtist(artistName: String, success: @escaping (_ artist: Artist) -> Void, fail: @escaping (_ error: Error) -> Void) {
        let formattedArtistName = artistName.replacingOccurrences(of: " ", with: "+")
        let limit = 1
        let urlString = rootDbPath + storefront + "/search?term=\(formattedArtistName)&limit=\(limit)&types=artists"
        print("URL STRING:")
        print(urlString)
        if let header = header {
            super.makeGetRequest(urlString: urlString, header: header, headerField: headerField, success: { (data) in
                processArtistData(data: data, success: { (artist) in
                    success(artist)
                }, fail: { (error) in
                    fail(error)
                })
            }) { (error) in
                fail(error)
            }
        }
    }
    private static func processGenreData(data: [String:Any], success: @escaping (_ genres: [Genre]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        if let allGenreData = data["data"] as? [[String:Any]] {
            processArrayOf(arrData: allGenreData, example: Genre() , success: { (genres) in
                success(genres)
            }) { (error) in
                fail(error)
            }
        } else {
            fail(CustomError("The data does not have \"data\" or data is not an array of String:Any dictionaries"))
        }
    }
    private static func processSongData(data: [String:Any], success: @escaping (_ genres: [Song]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        if let results = data["results"] as? [String:Any] {
            if let songsWrapper = results["songs"] as? [[String:Any]] {
                if let songs = songsWrapper.first {
                    if let songsData = songs["data"] as? [[String:Any]] {
                        processArrayOf(arrData: songsData, example: Song(), success: { (songs) in
                            success(songs)
                        }) { (error) in
                            fail(error)
                        }
                    } else {
                        fail(CustomError("The songs does not have \"data\" or songsData is not an array of String:Any dictionaries."))
                    }
                } else {
                    fail(CustomError("The songs wrapper does not have any elements."))
                }
            } else {
                fail(CustomError("The results does not have \"songs\" or songsWrapper is not an array of String:Any dictionaries."))
            }
        } else {
            fail(CustomError("The data does not have \"results\" or results is not a dictionary of String:Any pairs."))
        }
    }
    private static func processArtistData(data: [String:Any], success: @escaping (_ artist: Artist) -> Void, fail: @escaping (_ error: Error) -> Void) {
        if let results = data["results"] as? [String:Any] {
            if let artists = results["artists"] as? [String:Any] {
                if let artistsData = artists["data"] as? [[String:Any]] {
                    if let artistData = artistsData.first {
                        let artist = Artist()
                        artist.parseData(data: artistData, success: { (artist) in
                            success(artist)
                        }) { (error) in
                            fail(error)
                        }
                    } else {
                        fail(CustomError("No artists were returned from search."))
                    }
                } else {
                    fail(CustomError("Artists does not have \"data\" or artistsData is not an array of String:Any dictionaries."))
                }
            } else {
                fail(CustomError("Results does not have \"artists\" or artists is not a dictionary of String:Any pairs."))
            }
        } else {
            fail(CustomError("Data does not have \"results\" or results is not a dictionary of String:Any pairs.\nData:\n\(data)"))
        }
    }
    
    private static func processArrayOf<T>(arrData: [[String:Any]], example: T, success: @escaping (_ result: [T]) -> Void, fail: @escaping (_ error: Error) -> Void) where T: DataParsable {
        var res:[T] = []
        for data in arrData {
            let obj = T()
            obj.parseData(data: data, success: { (result) in
                res.append(result)
            }) { (error) in
                fail(error)
            }
        }
        success(res)
    }
}
