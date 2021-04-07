//
//  ViewController.swift
//  Prefetch
//
//  Created by Soul on 16/07/2018.
//  Copyright © 2018 Fluffy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
	
	@IBOutlet weak var postTableView: UITableView!
	@IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
	
	
	var postArray : [Post] = []
	
	let postCellIdentifier = "postCell"
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// Setup table view and cell
		postTableView.register(UINib(nibName: "PostTableViewCell", bundle: nil) , forCellReuseIdentifier: postCellIdentifier)
		postTableView.estimatedRowHeight = UITableViewAutomaticDimension
		postTableView.dataSource = self
		
		
		loadingActivityIndicator.isHidden = false
		loadingActivityIndicator.startAnimating()
		
		// Load all data at once
		URLSession(configuration: URLSessionConfiguration.default).dataTask(with: URL(string: "https://jsonplaceholder.typicode.com/posts")!) { data, response, error in
			// ensure there is data returned from this HTTP response
			guard let data = data else {
				print("No data")
				return
			}
			
			// Parse JSON into Post array struct using JSONDecoder
			guard let posts = try? JSONDecoder().decode([Post].self, from: data) else {
				print("Error: Couldn't decode data into post model")
				return
			}
			
			self.postArray = posts
			
			// Make sure to update UI in main thread
			DispatchQueue.main.async {
				self.loadingActivityIndicator.stopAnimating()
				self.loadingActivityIndicator.isHidden = true
				self.postTableView.reloadData()
			}
		}.resume()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Table View Data Source
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return postArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: postCellIdentifier , for: indexPath) as! PostTableViewCell
		
		// get the corresponding post object to show from the array
		let post = postArray[indexPath.row]
		cell.titleLabel.text = post.title
		cell.bodyLabel.text = post.body
		
		return cell
	}
}

