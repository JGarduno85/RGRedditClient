//
//  ViewController.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/20/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import UIKit

class RGHome: UIViewController {

    @IBOutlet weak var homeSectionTableView: UITableView!
    
    var homeServiceProvider: RGHomeServiceProviding!
    var errorSection: RGElement!
    var homeSectionDataProvider: (UITableViewDataSource & UITableViewDelegate)!
    var loaderSection: RGElement!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        commonInit()
        requestFeeds(success: loadFeeds, fail: loadError)
    }
    
    fileprivate func commonInit() {
        homeServiceProvider = RGHomeServiceProvider.createHomeServiceProvider()
        errorSection = RGErrorSectionPresenter(nib: UINib(nibName: "RGErrorTableViewCell", bundle: nil))
        loaderSection = RGLoaderSectionPresenter(nib: UINib(nibName: "RGLoaderTableViewCell", bundle: nil))
        homeSectionDataProvider = RGHomeSectionDataProvider()
        homeSectionTableView.register(errorSection.presenter, forCellReuseIdentifier: errorSection.sectionId)
        homeSectionTableView.register(loaderSection.presenter, forCellReuseIdentifier: loaderSection.sectionId)
        homeSectionTableView.dataSource = homeSectionDataProvider
        homeSectionTableView.delegate = homeSectionDataProvider
    }
}


extension RGHome {
    func requestFeeds(success: ((RGFeedContainer?) -> Void)?, fail:((Error?) -> Void)?){
        showLoader(home: self)
        homeServiceProvider.getHomeFeeds { [weak self] (feeds, error) in
            guard let strongSelf = self else {
                return
            }
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
            strongSelf.removeLoader(home: strongSelf)
        }
    }
    
    fileprivate func loadFeeds(feeds: RGFeedContainer?) {
        
    }
    
    fileprivate func loadError(error: Error?) {
        showErrorMessage(home: self)
    }
    
    fileprivate func showLoader(home: RGHome) {
        guard let dataProvider = home.homeSectionDataProvider as? RGHomeSectionDataProvider else {
            return
        }
        dataProvider.homeSectionDirector.insertSection(section: home.loaderSection)
        homeSectionTableView.insertRows(at: [IndexPath(row: dataProvider.homeSectionDirector.homeSections.count - 1, section: 0)], with: .fade)
    }
    
    fileprivate func removeLoader(home: RGHome) {
        guard let dataProvider = home.homeSectionDataProvider as? RGHomeSectionDataProvider else {
            return
        }
        dataProvider.homeSectionDirector.removeSection(section: loaderSection)
        let numberRows = homeSectionTableView.numberOfRows(inSection: 0)
        home.homeSectionTableView.deleteRows(at: [IndexPath(row: numberRows - 1, section: 0)], with: .fade)
    }
    
    fileprivate func showErrorMessage(home: RGHome) {
        guard let dataProvider = home.homeSectionDataProvider as? RGHomeSectionDataProvider else {
            return
        }
        if dataProvider.homeSectionDirector.homeSections.count <= 0 {
            dataProvider.homeSectionDirector.insertSection(section: home.errorSection)
            home.homeSectionTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        } else {
            let alert = RGBasicAlertFactory.createAlert(title: "Opps..!", message: "Something went wrong please try to refresh", actionTitle: "Ok", style: .default, handler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

