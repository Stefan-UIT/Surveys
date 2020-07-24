//
//  VerticalPageControlView.swift
//  Surveys
//
//  Created by Trung Vo on 7/24/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import UIKit

protocol VerticalPageControlViewDelegate:class {
    func verticalPageControlView(_ view: VerticalPageControlView?, currentPage: Int)
}

class VerticalPageControlView: UIView {
    private var activeImage: UIImage?
    private var inactiveImage: UIImage?
    private var numberOfPages = 0
    private var currentPage = 1
    private let marginSpace:Double = 5.0
    
    private var activeSize:CGSize {
        get {
            return activeImage?.size ?? CGSize.zero
        }
    }

    weak var delegate: VerticalPageControlViewDelegate?

    func setImageActiveState(_ active: UIImage?, inActiveState inactive: UIImage?) {
        activeImage = active
        inactiveImage = inactive
    }

    func setNumberOfPages(_ pages: Int) {
        numberOfPages = pages
    }

    func setCurrentPage(_ current: Int) {
        currentPage = current
    }

    func show() {
        if numberOfPages != 0 && numberOfPages > 0 && currentPage <= numberOfPages {
            if activeImage != nil && inactiveImage != nil {
                addStatesVertically()
                updateState(forPageNumber: currentPage)
            }
        }
    }

    func updateState(forPageNumber page: Int) {
        if page <= numberOfPages && numberOfPages != 0 && page != currentPage {
            let pageNeedToUpdate = (page     == 0) ? 1 : page
            changeButtonState(forTag: pageNeedToUpdate)
        }
    }


// MARK: - Run time calculation / States Frame


    func stateVerticalFrameWith(x: CGFloat, y: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: activeSize.width, height: CGFloat(Double(activeSize.height) + marginSpace))
    }

    func getY() -> CGFloat {
        let dotHeight = CGFloat(Double(activeSize.height) + marginSpace)
        let viewHeight = frame.height
        return (viewHeight - (CGFloat(numberOfPages) * dotHeight)) / 2.0
    }

// MARK: - User tap / Delegate Call
    func callDelegate(forPageChange page: Int) {
        updateState(forPageNumber: page)
        if currentPage > 0 {
            self.delegate?.verticalPageControlView(self, currentPage: currentPage - 1)
        }
    }

    @objc func userTap(_ btnState: UIButton?) {
        callDelegate(forPageChange: btnState?.tag ?? 0)
    }

// MARK: - Add States
    
    func removeAllSubViews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }

    func addStatesVertically() {
        removeAllSubViews()
        var y = getY()
        for index in 1...numberOfPages {
            let btnState = UIButton(type: .custom)
            btnState.addTarget(self, action: #selector(userTap(_:)), for: .touchUpInside)
            btnState.tag = index
            btnState.setImage(inactiveImage, for: .normal)
            btnState.setImage(activeImage, for: .selected)
            if index == currentPage {
                btnState.isSelected = true
            }
            btnState.frame = stateVerticalFrameWith(x: 0.0, y: y)
            addSubview(btnState)
            btnState.center = CGPoint(x: frame.width / 2.0, y: btnState.center.y)
            y += btnState.frame.size.height
        }
    }

// MARK: - Update States For State Change Event
    func changeButtonState(forTag tag: Int) {
        for index in 1...numberOfPages {
            let btnState = viewWithTag(index) as? UIButton
            btnState?.isSelected = false
            if index == tag {
                currentPage = index
                btnState?.isSelected = true
            }
        }
    }
}

