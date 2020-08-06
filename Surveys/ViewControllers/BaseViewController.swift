//
//  BaseViewController.swift
//  Surveys
//
//  Created by Trung Vo on 8/5/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import UIKit
import os.log

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let identifier = String(describing: self)
        os_log(LogMessages.ViewControllerIsLoaded, log: .lifeCycle, type: .info, identifier)
    }
}
