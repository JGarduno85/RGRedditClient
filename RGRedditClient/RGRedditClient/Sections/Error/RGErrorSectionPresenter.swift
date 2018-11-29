//
//  RGErrorSectionViewModel.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/27/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import Foundation
import  UIKit

class RGErrorSectionPresenter: RGSection {
    var presenter: UINib
    var sectionId: String {
        return "RGErrorSection"
    }
    
    init(nib: UINib) {
        self.presenter = nib
    }
}
