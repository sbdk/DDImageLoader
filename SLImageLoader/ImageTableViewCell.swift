//
//  ImageTableViewCell.swift
//  SLImageLoader
//
//  Created by Li Yin on 4/7/18.
//  Copyright © 2018 Li Yin. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

  @IBOutlet weak var coverImageView: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    coverImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  
    
 
}


