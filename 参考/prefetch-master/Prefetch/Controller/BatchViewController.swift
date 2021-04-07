//
//  BatchViewController.swift
//  Prefetch
//
//  Created by Soul on 17/07/2018.
//  Copyright © 2018 Fluffy. All rights reserved.
//

import UIKit

class BatchViewController: UIViewController, UITableViewDataSource{

	@IBOutlet weak var coinTableView: UITableView!
	
	var coinArray : [Coin] = []
	
	let coinCellIdentifier = "coinCell"
	let loadingCellIdentifier = "loadingCell"
	let baseURL = "https://api.coinmarketcap.com/v2/ticker/?"
	
	// fetch 15 items for each batch
	let itemsPerBatch = 15
	
	// current row from database
	var currentRow : Int = 1
	
	// URL computed by current row
	var url : URL {
		return URL(string: "\(baseURL)start=\(currentRow)&limit=\(itemsPerBatch)")!
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		// Setup table view and cell
		coinTableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: loadingCellIdentifier)
		coinTableView.register(UINib(nibName: "CoinTableViewCell", bundle: nil) , forCellReuseIdentifier: coinCellIdentifier)
		coinTableView.estimatedRowHeight = UITableViewAutomaticDimension
		coinTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	// MARK : - Tableview data source
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// +1 to show the loading cell at the last row
		return self.coinArray.count + 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// if reached last row
		if indexPath.row == self.coinArray.count {
			let cell = tableView.dequeueReusableCell(withIdentifier: loadingCellIdentifier, for: indexPath) as! LoadingTableViewCell
			cell.activityIndicator.startAnimating()
			loadNextBatch()
			
			return cell
		}
		
		let cell = tableView.dequeueReusableCell(withIdentifier: coinCellIdentifier , for: indexPath) as! CoinTableViewCell
		
		// get the corresponding coin object to show from the array
		let coin = coinArray[indexPath.row]
		cell.configureCell(with: coin)
		
		return cell
	}
	
	// MARK : - Batch
	func loadNextBatch() {
		URLSession(configuration: URLSessionConfiguration.default).dataTask(with: url) { data, response, error in
			// ensure there is data returned from this HTTP response
			guard let data = data else {
				print("No data")
				return
			}
			
			// Parse JSON into CoinList struct using JSONDecoder
			guard let coinList = try? JSONDecoder().decode(CoinList.self, from: data) else {
				print("Error: Couldn't decode data into coin list")
				return
			}
			
			// contain array of tuples, ie. [(key : ID, value : Coin)]
			let coinTupleArray = coinList.data.sorted {$0.value.rank < $1.value.rank}
			for coinTuple in coinTupleArray {
				self.coinArray.append(coinTuple.value)
			}
			
			// increment current row
			self.currentRow += self.itemsPerBatch
			
			// Make sure to update UI in main thread
			DispatchQueue.main.async {
				self.coinTableView.reloadData()
			}
			
		}.resume()
	}

}
