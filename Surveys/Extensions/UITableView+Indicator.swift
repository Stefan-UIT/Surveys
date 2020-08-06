//
//  UITableView+Indicator.swift
//  Surveys
//
//  Created by Trung Vo on 8/6/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    private var footerActivityIndicatorView: UIActivityIndicatorView {
        let indicator = setupActivityIndicator()
        tableFooterView = indicator
        return indicator
    }
    
    func addFooterLoading() {
        footerActivityIndicatorView.startAnimating()
    }
    
    func stopFooterLoading() {
        footerActivityIndicatorView.stopAnimating()
        tableFooterView = nil
    }
    
    private func setupActivityIndicator() -> UIActivityIndicatorView {
        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: 45)
        let activityIndicatorView = UIActivityIndicatorView(frame: frame)
        activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        return activityIndicatorView
    }
}
