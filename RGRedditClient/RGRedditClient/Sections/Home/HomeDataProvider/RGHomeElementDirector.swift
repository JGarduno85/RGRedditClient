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

protocol RGHomeElementDirecting {
    var homeSections: [RGElement] { get }
    func insertSection(section: RGElement)
    func removeSection(section: RGElement)
}

class RGHomeElementDirector: RGHomeElementDirecting {
    var homeSections:[RGElement] = []
    func insertSection(section: RGElement) {
        homeSections.append(section)
    }
    
    func removeSection(section: RGElement) {
        let sectionIndex = homeSections.firstIndex(where: { (localSection) -> Bool in
           return section.sectionId == localSection.sectionId
        })
        if let sectionElementIndex = sectionIndex {
            homeSections.remove(at: sectionElementIndex)
        }
    }
}
