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
    case InvalidNumberOfPage
    case InvalidCurrentPage
    case CurrentPageIsTooLarge
    case ActiveImageShouldNotNil
    case InActiveImageShouldNotNil
    
    
    var errorDescription: String {
        switch self {
        case .InvalidNumberOfPage:
            return Messages.InvalidNumberOfPages
        case .InvalidCurrentPage:
            return Messages.InvalidCurrentPage
        case .CurrentPageIsTooLarge:
            return Messages.CurrentPageShouldLessThanOrEqualNumberOfPage
        case .ActiveImageShouldNotNil:
            return Messages.ActiveImageShouldNotBeNil
        case .InActiveImageShouldNotNil:
            return Messages.InactiveImageShouldNotBeNil
        }
        
    }
}

// MARK: - VPCValidationService
struct VPCValidationService {
    func validateNumberOfPages(_ numberOfPages:Int) throws {
        guard numberOfPages > 0 else { throw VPCValidationError.InvalidNumberOfPage }
    }
    
    func validateCurrentPage(_ currentPage:Int, numberOfPages:Int) throws {
        guard currentPage > 0 else { throw VPCValidationError.InvalidCurrentPage }
        guard currentPage <= numberOfPages else { throw VPCValidationError.CurrentPageIsTooLarge }
    }
    
    func validateActiveImage(_ activeImage:UIImage?) throws {
        guard activeImage != nil else { throw VPCValidationError.ActiveImageShouldNotNil }
    }
    
    func validateInactiveImage(_ inactiveImage:UIImage?) throws {
        guard inactiveImage != nil else { throw VPCValidationError.InActiveImageShouldNotNil }
    }
}

