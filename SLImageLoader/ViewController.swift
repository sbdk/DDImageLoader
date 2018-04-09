//
//  ViewController.swift
//  SLImageLoader
//
//  Created by Li Yin on 4/7/18.
//  Copyright © 2018 Li Yin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  
  
  let dataSource = [
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/FourSeaRestaurant/FourSea1.jpg",
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/Fukada/Fukada1.jpg",
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/FourSeaRestaurant/FourSea2.jpg",
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/Fukada/Fukada2.jpg",
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/FourSeaRestaurant/FourSea3.jpg",
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/Fukada/Fukada3.jpg",
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/FourSeaRestaurant/FourSea4.jpg",
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/Fukada/Fukada4.jpg",
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/FourSeaRestaurant/FourSea5.jpg",
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/Fukada/Fukada5.jpg",
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/FourSeaRestaurant/FourSea6.jpg",
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/Fukada/Fukada6.jpg",
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/FourSeaRestaurant/FourSea7.jpg",
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/Fukada/Fukada7.jpg",
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/FourSeaRestaurant/riceRoll.jpg",
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/FourSeaRestaurant/soyMilk.jpg",
    "https://s3-us-west-1.amazonaws.com/plummy/placeImages/FourSeaRestaurant/zongZi.jpg"
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableCell", for: indexPath) as! ImageTableViewCell
    let urlString = dataSource[indexPath.row]
    cell.coverImageView?.loadImageWithUrlString(urlString: urlString, cacheRule: .memoryAndDisk, completion: { (finished) in
      if finished {
      }
    })
    return cell
  }
  
  

}

