//
//  ViewController.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/20/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import UIKit

class RGHome: UIViewController, RGHomeElementDirectorDelegate {
    @IBOutlet weak var homeSectionTableView: UITableView!
    
    var homeServiceProvider: RGHomeServiceProviding!
    var homeSectionDataProvider: (UITableViewDataSource & UITableViewDelegate & UITableViewDataSourcePrefetching)!
    var errorSection: RGErrorPresenter!
    var loaderSection: RGLoaderPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        commonInit()
        if ProcessInfo.processInfo.environment["UNIT_TEST_MODE"] == nil {
            requestFeeds(success: loadFeeds, fail: loadError)
        }
    }
    
    fileprivate func commonInit() {
        errorSection = RGErrorPresenter()
        loaderSection = RGLoaderPresenter()
        homeServiceProvider = RGHomeServiceProvider.createHomeServiceProvider()
        homeSectionDataProvider = RGHomeSectionDataProvider(homeSectionDirectorDelegate: self)
        homeSectionTableView.register(UINib(nibName: "RGErrorTableViewCell", bundle: nil), forCellReuseIdentifier: errorSection.id)
        homeSectionTableView.register(UINib(nibName: "RGLoaderTableViewCell", bundle: nil), forCellReuseIdentifier: loaderSection.id)
        homeSectionTableView.register(UINib(nibName: "RGFeedTableViewCell", bundle: nil), forCellReuseIdentifier:RGFeedPresenter.id)
        homeSectionTableView.dataSource = homeSectionDataProvider
        homeSectionTableView.delegate = homeSectionDataProvider
        homeSectionTableView.prefetchDataSource = homeSectionDataProvider
    }
}


extension RGHome {
    func loadNextBatch(delegate: UITableViewDataSource) {
       requestFeeds(success: loadFeeds, fail: loadError)
    }
    
    func requestFeeds(success: ((RGFeedContainer?) -> Void)?, fail:((Error?) -> Void)?){
        showLoader(home: self)
        homeServiceProvider.getHomeFeeds { (feeds, error) in
            guard error == nil else {
                if let fail = fail {
                    fail(error)
                }
                return
            }
            guard let feeds = feeds else {
                if let fail = fail {
                    fail(error)
                }
                return
            }
            if let success = success {
               success(feeds)
            }
        }
    }
    
    fileprivate func loadFeeds(feeds: RGFeedContainer?) {
        guard let dataProvider = homeSectionDataProvider as? RGHomeSectionDataProvider else {
            return
        }
        guard let feedsData = feeds?.data?.children else {
            return
        }
        
        dataProvider.homeElementSectionDirector.insertSections(sections: feedsData)
        let indexPaths = indexPath(for: feedsData)
        homeSectionTableView.beginUpdates()
        if let loaderIndex = removeLoader() {
            removeLoaderRow(indexPath: IndexPath(row: loaderIndex, section: 0))
        }
        insertFeedsRows(using: indexPaths)
        homeSectionTableView.endUpdates()
    }
    
    fileprivate func insertFeedsRows(using indexPaths: [IndexPath]) {
        homeSectionTableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    fileprivate func indexPath(for sections:[Any]) -> [IndexPath] {
        var rowIndex = homeSectionTableView.numberOfRows(inSection: 0) - 1
        var index = 0
        let count = sections.count
        var indexPaths: [IndexPath] = []
        while index < count {
            indexPaths.append(IndexPath(row: rowIndex, section: 0))
            index += 1
            rowIndex += 1
        }
        return indexPaths
    }
    
    fileprivate func loadError(error: Error?) {
        showErrorMessage(home: self)
    }
    
    fileprivate func showLoader(home: RGHome) {
        guard let dataProvider = home.homeSectionDataProvider as? RGHomeSectionDataProvider else {
            return
        }
        dataProvider.homeElementSectionDirector.insertSection(section: home.loaderSection)
        homeSectionTableView.insertRows(at: [IndexPath(row: dataProvider.homeElementSectionDirector.sectionsCount - 1, section: 0)], with: .fade)
    }
    
    @discardableResult fileprivate func removeLoader() -> Int? {
        guard let dataProvider = homeSectionDataProvider as? RGHomeSectionDataProvider else {
            return nil
        }
        let indexLoader = dataProvider.homeElementSectionDirector.index(of: loaderSection)
        dataProvider.homeElementSectionDirector.removeSection(section: loaderSection)
        return indexLoader
    }
    
    fileprivate func removeLoaderRow(indexPath: IndexPath) {
        homeSectionTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    fileprivate func showErrorMessage(home: RGHome) {
        guard let dataProvider = home.homeSectionDataProvider as? RGHomeSectionDataProvider else {
            return
        }
        if dataProvider.homeElementSectionDirector.sectionsCount <= 0 {
            dataProvider.homeElementSectionDirector.insertSection(section: home.errorSection)
            home.homeSectionTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        } else {
            let alert = RGBasicAlertFactory.createAlert(title: "Opps..!", message: "Something went wrong please try to refresh", actionTitle: "Ok", style: .default, handler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

