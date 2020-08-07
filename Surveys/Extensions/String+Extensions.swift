//
//  String+Extensions.swift
//  Surveys
//
//  Created by Trung Vo on 8/7/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation

extension String {
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
