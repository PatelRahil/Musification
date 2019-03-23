//
//  Song.swift
//  Musification
//
//  Created by Rahil Patel on 3/23/19.
//  Copyright © 2019 RahilPatel. All rights reserved.
//

import Foundation

class Song: DataParsable {
    typealias Parsable = Song
    var name: String = ""
    var artist: String = ""
    
    required init() {}
    
    func parseData<Parsable>(data songData: [String : Any], success: @escaping (Parsable) -> Void, fail: @escaping (Error) -> Void) {
        if let songAttributes = songData["attributes"] as? [String:Any] {
            if let songName = songAttributes["name"] as? String {
                name = songName
            } else {
                fail(CustomError("Song attributes does not have a name or name is not a String"))
            }
            
            if let songArtist = songAttributes["artistName"] as? String {
                artist = songArtist
            } else {
                fail(CustomError("Song attributes does not have an artist or artist is not a String"))
            }
            
            success(self as! Parsable)
        } else {
            fail(CustomError("Song data does not have \"attributes\" or attributes is not a String:Any dictionary"))
        }
    }
}
