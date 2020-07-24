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
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    weak var delegate:SurveyTableViewCellDelegate?
    
    var overlay: UIView!
    var survey:Survey!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func addOverlayView() {
        if overlay == nil {
            initOverlay()
            backgroundImageView.addSubview(overlay)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func initOverlay() {
        overlay = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
    }
    
    func configureCell(survey:Survey) {
        self.survey = survey
        titleLabel.text = survey.title
        descriptionLabel.text = survey.description
        let urlString = survey.coverImageUrl + "l"
        backgroundImageView.load(urlString: urlString)
        addOverlayView()
    }
    
    
    @IBAction func onTakeTheSurveyTouchUp(_ sender: UIButton) {
        self.delegate?.didTouchUpTakeTheSurvey(self, survey: survey)
        
    }
    
}
