//
//  RGSectionsProvider.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/26/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import Foundation
import UIKit

protocol RGElement {
    var sectionId: String { get }
    var presenter: UINib  { get }
}

