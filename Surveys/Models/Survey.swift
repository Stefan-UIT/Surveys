//
//  Survey.swift
//  Surveys
//
//  Created by Trung Vo on 7/23/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation

struct Survey:Decodable {
    let title: String
    let description: String
    let coverImageUrl: String
    var fullSizeCoverImageUrl:String {
        get {
            return coverImageUrl + "l"
        }
    }
}
