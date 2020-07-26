//
//  SurveyTableViewCell.swift
//  Surveys
//
//  Created by Trung Vo on 7/24/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import UIKit

protocol SurveyTableViewCellDelegate:class {
    func didTouchUpTakeTheSurvey(_ cell:SurveyTableViewCell, survey:Survey)
}

class SurveyTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // MARK: - Variables
    var overlay: UIView!
    var survey:Survey!
    weak var delegate:SurveyTableViewCellDelegate?
    
    // MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Methods
    private func addOverlayView() {
        if overlay == nil {
            initOverlay()
            backgroundImageView.addSubview(overlay)
        }
    }
    
    private func initOverlay() {
        overlay = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
    }
    
    func configureCell(survey:Survey) {
        self.survey = survey
        titleLabel.text = survey.title
        descriptionLabel.text = survey.description
        backgroundImageView.load(urlString: survey.fullSizeCoverImageUrl)
        addOverlayView()
    }
    
    // MARK: - Actions
    @IBAction func onTakeTheSurveyTouchUp(_ sender: UIButton) {
        self.delegate?.didTouchUpTakeTheSurvey(self, survey: survey)
    }
}
