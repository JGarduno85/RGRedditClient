//
//  HomeSectionDataPovider.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/26/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import Foundation
import UIKit

class RGHomeSectionDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {

    var homeSectionDirector: RGHomeSectionDirecting
    override init() {
        homeSectionDirector = RGHomeSectionDirector()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeSectionDirector.homeSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !homeSectionDirector.homeSections.isEmpty, indexPath.row < homeSectionDirector.homeSections.count else {
            return UITableViewCell()
        }
        let section = homeSectionDirector.homeSections[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: section.sectionId, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = homeSectionDirector.homeSections.first else {
            return UITableView.automaticDimension
        }
        if section is RGErrorSectionPresenter {
            return tableView.bounds.size.height
        }
        return UITableView.automaticDimension
    }
}
