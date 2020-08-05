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
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
