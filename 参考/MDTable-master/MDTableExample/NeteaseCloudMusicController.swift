//
//  ComplexController.swift
//  MDTableExample
//
//  Created by Leo on 2017/6/17.
//  Copyright © 2017年 Leo Huang. All rights reserved.
//

import Foundation
import MDTable

class NeteaseCloudMusicController: UITableViewController,NeteaseCloudMusicSortControllerDelegate {
    
    var sections: [SectionConvertable] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "网易云音乐"
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        let footer = NMFooterView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 85.0))
        footer.sortButton.addTarget(self, action: #selector(NeteaseCloudMusicController.showSortController(_:)), for: .touchUpInside)
        DispatchQueue.global(qos: .userInteractive).async {
            let menuSection = MenuSection.mockSection
            let recommendSection = RecommendSection.mockSection
            let exclusiveSection = ExclusiveSection.mockSection
            let mvSection = NMMVSection.mockSection
            let columnistSection = NeteaseColumnlistSection.mockSection
            let channelSection = ChannelSection.mockSection
            let latestMusicSection = LatestMusicSection.mockSection
            self.sections = [menuSection,recommendSection,exclusiveSection,mvSection,columnistSection,channelSection,latestMusicSection]
            DispatchQueue.main.async {
                self.tableView.manager = TableManager(sections: self.sections)
                self.tableView.tableFooterView = footer
            }
        }
    }
    
    func showSortController(_ sender: UIBarButtonItem){
        let sortableSections = sections.filter { $0 is SortableSection }.map{$0 as! SortableSection}
        let sortController = NeteaseCloudMusicSortController(sections: sortableSections)
        sortController.delegate = self
        let navController = BaseNavigationController(rootViewController: sortController)
        present(navController, animated: true, completion: nil)
    }
    func didFinishReorder(with sections: [SortableSection]) {
        self.sections.sort { (left, right) -> Bool in
            guard let _left = left as? SortableSection, let _right = right as? SortableSection else{
                return false
            }
            return _left.sequence < _right.sequence
        }
        tableView.manager?.sections = self.sections
        tableView.manager?.reloadData()
    }
}


