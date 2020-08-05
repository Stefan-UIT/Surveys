//
//  SurveyDetailViewController.swift
//  Surveys
//
//  Created by Trung Vo on 7/25/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import UIKit

class SurveyDetailViewController: BaseViewController {
    var survey:Survey!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        titleLabel.text = survey.title
        descriptionLabel.text = survey.description
    }
}
