//
//  Survey.swift
//  Surveys
//
//  Created by Trung Vo on 7/23/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation

struct Survey: Decodable {
    var title: String = ""
    var description: String = ""
    var coverImageUrl: String = ""
    
    var fullSizeCoverImageUrl: String {
        return coverImageUrl + "l"
    }
}
