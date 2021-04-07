//
//  PrefetchViewController.swift
//  Prefetch
//
//  Created by Soul on 17/07/2018.
//  Copyright © 2018 Fluffy. All rights reserved.
//

import UIKit

class PrefetchViewController: UIViewController {

	@IBOutlet weak var newsTableView: UITableView!
	
	// this is the data source for table view
	// fill the array with 100 nil first, then replace the nil with the loaded news object at its corresponding index/position
	var newsArray : [News?] = [News?](repeating: nil, count: 100)
	
	// store task (calling API) of getting each news
	var dataTasks : [URLSessionDataTask] = []

	let newsCellIdentifier = "newsCell"
	let newsIDs = [17550600, 17549050, 17550761, 17550837, 17549099, 17548768, 17550808, 17550315, 17551012, 17546915,
				   17546491, 17534858, 17544666, 17550754, 17540464, 17540205, 17544687, 17548807, 17542051, 17550532,
				   17540321, 17548270, 17549927, 17550199, 17550823, 17548623, 17539726, 17547817, 17548731, 17539765,
				   17548676, 17549325, 17539465, 17548285, 17546207, 17550987, 17549797, 17548198, 17548764, 17546876,
				   17541045, 17549293, 17544250, 17546731, 17546835, 17550698, 17541600, 17546875, 17540401, 17543323,
				   17539548, 17544689, 17550420, 17546979, 17540200, 17544281, 17538390, 17534817, 17543357, 17548103,
				   17544300, 17545529, 17545518, 17539969, 17544161, 17536441, 17540383, 17549934, 17547562, 17539361,
				   17538322, 17540313, 17535995, 17542949, 17546409, 17537512, 17546006, 17542803, 17540712, 17546832,
				   17532682, 17540263, 17536291, 17534950, 17522362, 17539286, 17538697, 17541065, 17538453, 17542864,
				   17542556, 17539595, 17538770, 17537250, 17547092, 17541092, 17535909, 17534923, 17543925, 17538261]
	
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		newsTableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: newsCellIdentifier)
		newsTableView.estimatedRowHeight = 80.0
		newsTableView.rowHeight = UITableViewAutomaticDimension
		newsTableView.dataSource = self
		newsTableView.prefetchDataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	// MARK : Networking
	func fetchNews(ofIndex index: Int) {
		let newsID = newsIDs[index]
		let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(newsID).json")!
		
		// if there is already existing data task for the specific news, it means we already loaded it previously / currently loading it
		// stop re-downloading it by returning this function
		if dataTasks.index(where: { task in
			task.originalRequest?.url == url
		}) != nil {
			return
		}
		
		let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data else {
				print("No data")
				return
			}
			
			// Parse JSON into array of Car struct using JSONDecoder
			guard let news = try? JSONDecoder().decode(News.self, from: data) else {
				print("Error: Couldn't decode data into news")
				return
			}
			
			// replace the initial 'nil' value with the loaded news
			// to indicate that the news have been loaded for the table view
			self.newsArray[index] = news
			
			// Update UI on main thread
			DispatchQueue.main.async {
				let indexPath = IndexPath(row: index, section: 0)
				// check if the row of news which we are calling API to retrieve is in the visible rows area in screen
				// the 'indexPathsForVisibleRows?' is because indexPathsForVisibleRows might return nil when there is no rows in visible area/screen
				// if the indexPathsForVisibleRows is nil, '?? false' will make it become false
				if self.newsTableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
					// if the row is visible (means it is currently empty on screen, refresh it with the loaded data with fade animation
					self.newsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
				}
			}
			
			
		}
		
		// run the task of fetching news, and append it to the dataTasks array
		dataTask.resume()
		dataTasks.append(dataTask)
	}
	
	func cancelFetchNews(ofIndex index: Int) {
		let newsID = newsIDs[index]
		let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(newsID).json")!
		
		// get the index of the dataTask which load this specific news
		// if there is no existing data task for the specific news, no need to cancel it
		guard let dataTaskIndex = dataTasks.index(where: { task in
			task.originalRequest?.url == url
		}) else {
			return
		}
		
		let dataTask =  dataTasks[dataTaskIndex]
		
		// cancel and remove the dataTask
		dataTask.cancel()
		dataTasks.remove(at: dataTaskIndex)
	}
}

extension PrefetchViewController : UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return newsArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: newsCellIdentifier, for: indexPath) as! NewsTableViewCell
		
		// get the corresponding news object to show from the array
		if let news = newsArray[indexPath.row] {
			cell.configureCell(with: news)
		} else {
			// if the news havent loaded (nil havent got replaced), reset all the label
			cell.truncateCell()
			
			// fetch the news from API
			self.fetchNews(ofIndex: indexPath.row)
		}
		
		return cell
	}
}

extension PrefetchViewController : UITableViewDataSourcePrefetching {
	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		
		// fetch News from API for those rows that are being prefetched (near to visible area)
		for indexPath in indexPaths {
			self.fetchNews(ofIndex: indexPath.row)
		}
	}
	
	func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
		
		// cancel the task of fetching news from API when user scroll away from them
		for indexPath in indexPaths {
			self.cancelFetchNews(ofIndex: indexPath.row)
		}
	}
}
