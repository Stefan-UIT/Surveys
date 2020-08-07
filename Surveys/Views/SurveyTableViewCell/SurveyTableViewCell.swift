//
//  SurveyTableViewCell.swift
//  Surveys
//
//  Created by Trung Vo on 7/24/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import UIKit
import SDWebImage

protocol SurveyTableViewCellDelegate: class {
    func didTouchUpTakeTheSurvey(_ cell: SurveyTableViewCell, survey: Survey)
}

class SurveyTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // MARK: - Variables
    private var overlay: UIView!
    var survey: Survey!
    weak var delegate: SurveyTableViewCellDelegate?
    
    // MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Methods
    func configureCell(survey: Survey) {
        self.survey = survey
        setupData(withSurvey: survey)
        addOverlayView()
    }
    
    func setupData(withSurvey survey: Survey) {
        titleLabel.text = survey.title
        descriptionLabel.text = survey.description
        loadBackgroundImage(urlString: survey.fullSizeCoverImageUrl)
    }
    
    private func loadBackgroundImage(urlString: String) {
        let imageURL = URL(string: urlString)
        backgroundImageView.sd_setImage(with: imageURL, placeholderImage: ImageObjects.Placeholder, options: .progressiveLoad)
    }
    
    private func addOverlayView() {
        if overlay == nil {
            initOverlay()
            backgroundImageView.addSubview(overlay)
        }
    }
    
    private func initOverlay() {
        overlay = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        overlay.backgroundColor = AppColor.Overlay
    }
    
    // MARK: - Actions
    @IBAction func onTakeTheSurveyTouchUp(_ sender: UIButton) {
        self.delegate?.didTouchUpTakeTheSurvey(self, survey: survey)
    }
}
