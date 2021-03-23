//
//  ViewController.swift
//  PreloadDemo
//
//  Created by shenjie on 2021/3/23.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    fileprivate var data:[Any]?
    fileprivate let threshold:CGFloat = 0.7
    fileprivate var currentPage:CGFloat = 0
    fileprivate let itemPerpage: CGFloat = 10
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell  = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
//        cell.backgroundColor = UIColor(red:  CGFloat(arc4random()%256)/256.0, green:  CGFloat(arc4random()%256)/256.0, blue:  CGFloat(arc4random()%256)/256.0, alpha: 1)
        cell.backgroundColor = .white
        cell.textLabel?.text = "\(indexPath.row) 行"
        cell.textLabel?.textColor = .black
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let current = scrollView.contentOffset.y + scrollView.frame.size.height
        print("current:\(current)")
        let total = scrollView.contentSize.height
        print("total:\(total)")
        let ratio = current / total
        print("ratio:\(ratio)")
        let needRead = itemPerpage * (threshold + currentPage)
        let totalItem = itemPerpage * (currentPage + 1)
        let newThreshold = needRead / totalItem
        print("newThreshold:\(newThreshold)")
        if ratio >= newThreshold {
            currentPage += 1
            print("Request page \(currentPage) from server.")
        }
    }
}

//extension ViewController: UIScrollViewDelegate

