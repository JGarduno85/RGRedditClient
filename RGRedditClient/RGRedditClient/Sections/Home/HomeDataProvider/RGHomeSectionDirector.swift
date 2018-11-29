//
//  RGHomeSectionDirector.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/27/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import Foundation
import UIKit

struct RGBasicAlertFactory {
    static func createAlert(title: String, message: String, actionTitle: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: style, handler: handler)
        alert.addAction(alertAction)
        return alert
    }
}

protocol RGHomeSectionDirecting {
    var homeSections: [RGSection] { get }
    func insertSection(section: RGSection)
    func removeSection(section: RGSection)
}

class RGHomeSectionDirector: RGHomeSectionDirecting {
    var homeSections:[RGSection] = []
    func insertSection(section: RGSection) {
        homeSections.append(section)
    }
    
    func removeSection(section: RGSection) {
        let sectionIndex = homeSections.firstIndex(where: { (localSection) -> Bool in
           return section.sectionId == localSection.sectionId
        })
        if let sectionElementIndex = sectionIndex {
            homeSections.remove(at: sectionElementIndex)
        }
    }
}
