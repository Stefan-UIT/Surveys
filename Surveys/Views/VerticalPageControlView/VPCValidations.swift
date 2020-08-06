//
//  VPCValidations.swift
//  Surveys
//
//  Created by Trung Vo on 7/29/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import UIKit

// MARK: - VPCValidationError
enum VPCValidationError:Error {
    case invalidNumberOfPage
    case invalidCurrentPage
    case currentPageIsTooLarge
    case activeImageShouldNotNil
    case inActiveImageShouldNotNil
    
    
    var errorDescription: String {
        switch self {
        case .invalidNumberOfPage:
            return Messages.InvalidNumberOfPages
        case .invalidCurrentPage:
            return Messages.InvalidCurrentPage
        case .currentPageIsTooLarge:
            return Messages.CurrentPageShouldLessThanOrEqualNumberOfPage
        case .activeImageShouldNotNil:
            return Messages.ActiveImageShouldNotBeNil
        case .inActiveImageShouldNotNil:
            return Messages.InactiveImageShouldNotBeNil
        }
        
    }
}

// MARK: - VPCValidationService
struct VPCValidationService {
    func validateNumberOfPages(_ numberOfPages:Int) throws {
        guard numberOfPages > 0 else { throw VPCValidationError.invalidNumberOfPage }
    }
    
    func validateCurrentPage(_ currentPage:Int, numberOfPages:Int) throws {
        guard currentPage > 0 else { throw VPCValidationError.invalidCurrentPage }
        guard currentPage <= numberOfPages else { throw VPCValidationError.currentPageIsTooLarge }
    }
    
    func validateActiveImage(_ activeImage:UIImage?) throws {
        guard activeImage != nil else { throw VPCValidationError.activeImageShouldNotNil }
    }
    
    func validateInactiveImage(_ inactiveImage:UIImage?) throws {
        guard inactiveImage != nil else { throw VPCValidationError.inActiveImageShouldNotNil }
    }
}

