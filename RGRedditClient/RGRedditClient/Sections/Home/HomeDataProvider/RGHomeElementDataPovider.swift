//
//  HomeSectionDataPovider.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/26/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import Foundation
import UIKit

class RGHomeSectionDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    var homeElementSectionDirector: RGHomeElementDirecting
    weak var homePresenter: RGHomePresenter?
    override init() {
        homeElementSectionDirector = RGHomeElementDirector()
    }
    
    convenience init(homeSectionDirectorDelegate delegate: RGHomeElementDirectorDelegate, homePresenter: RGHomePresenter) {
        self.init()
        homeElementSectionDirector.delegate = delegate
        self.homePresenter = homePresenter
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeElementSectionDirector.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !homeElementSectionDirector.sectionsAreEmpty, indexPath.row < homeElementSectionDirector.sectionsCount else {
            return UITableViewCell()
        }
        guard let sectionElement = homeElementSectionDirector.elementSection(at: indexPath.row) else {
            return UITableViewCell()
        }
        guard let sectionId = sectionElement.sectionId  else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: sectionId, for: indexPath)
        if  let feedCell = cell as? RGFeedTableViewCell {
            if !isLoadingCell(for: indexPath) {
                    if let feedDataContainer = sectionElement.section as? RGFeedDataContainer, let feed = feedDataContainer.data {
                        feedCell.configure(with: feed)
                        feedCell.author.text?.append("row: \(indexPath.row)")
                        feedCell.feedCellAction = homePresenter
                    }
                }
        }
        
        if let loaderCell = cell as? RGLoaderTableViewCell {
            loaderCell.startAnimating()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let element = homeElementSectionDirector.elementSection(at: indexPath.row) else {
            return UITableView.automaticDimension
        }
        if element.section is RGLoaderPresenter {
            if homeElementSectionDirector.sectionsCount <= 1 {
                return tableView.bounds.size.height
            }
        }
        if element.section is RGErrorPresenter {
            return tableView.bounds.size.height
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell), let fetchInProgress = homeElementSectionDirector.delegate?.isFetchInProgress, !fetchInProgress {
            if let delegate = homeElementSectionDirector.delegate {
                delegate.loadNextBatch(delegate: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension RGHomeSectionDataProvider {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= homeElementSectionDirector.sectionsCount - 1
    }
}
