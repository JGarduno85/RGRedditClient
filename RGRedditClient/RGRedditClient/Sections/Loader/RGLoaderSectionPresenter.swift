//
//  RGLoaderSectionPresenter.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/28/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import Foundation
import  UIKit

class RGLoaderSectionPresenter: RGElement {
    var presenter: UINib
    var sectionId: String {
        return "RGLoaderSection"
    }
    
    init(nib: UINib) {
        self.presenter = nib
    }
}
