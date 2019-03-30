//
//  Artist.swift
//  Musification
//
//  Created by Rahil Patel on 3/23/19.
//  Copyright © 2019 RahilPatel. All rights reserved.
//

import Foundation
import SafariServices

class Artist: DataParsable {
    typealias Parsable = Artist
    var name: String = ""
    var id: String = ""
    var appleMusicUrlString: String = ""
    required init() {}
    func parseData<Parsable>(data artistData: [String:Any], success: @escaping (_ result: Parsable) -> Void, fail: @escaping (_ error: Error) -> Void) {
        if let id = artistData["id"] as? String {
            self.id = id
        } else {
            fail(CustomError("artist data does not have an id or id is not a String."))
        }
        if let attributes = artistData["attributes"] as? [String:Any] {
            if let name = attributes["name"] as? String {
                self.name = name
            } else {
                fail(CustomError("artist attributes does not have a name or name is not a String."))
            }
            if let urlString = attributes["url"] as? String {
                self.urlString = urlString
            } else {
                fail(CustomError("artist attributes does not have a url or url is not a String."))
            }
        } else {
            fail(CustomError("artist data does not have attributes or attributes is not a dictionary of String:Any pairs."))
        }
        success(self as! Parsable)
    }
    func openURL(controller: UIViewController) {
        if let url = URL(string: appleMusicUrlString) {
            let svc = SFSafariViewController(url: url)
            controller.present(svc, animated: true, completion: nil)
        }
        
    }
}
