//
//  DataParsable.swift
//  Musification
//
//  Created by Rahil Patel on 3/23/19.
//  Copyright © 2019 RahilPatel. All rights reserved.
//

import Foundation
protocol DataParsable {
    associatedtype Parsable: DataParsable
    func parseData<Parsable>(data genreData: [String:Any], success: @escaping (_ result: Parsable) -> Void, fail: @escaping (_ error: Error) -> Void)
    init()
}
