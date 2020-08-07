//
//  Log.swift
//  Surveys
//
//  Created by Trung Vo on 8/5/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static let subsystem = Bundle.main.bundleIdentifier!
    
    static let networking = OSLog(subsystem: subsystem, category: "networking")
    static let userFlows = OSLog(subsystem: subsystem, category: "userFlows")
    static let userInterface = OSLog(subsystem: subsystem, category: "userInterface")
    static let lifeCycle = OSLog(subsystem: subsystem, category: "lifeCycle")
    static let surveys = OSLog(subsystem: subsystem, category: "surveys")
    static let system = OSLog(subsystem: subsystem, category: "system")
}
