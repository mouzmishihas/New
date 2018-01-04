//
//  Marvell_Character_Listing_Cell.swift
//  MarvellApp
//
//  Created by Salama on 1/4/18.
//  Copyright © 2018 Salama. All rights reserved.
//

import UIKit

class Marvell_Character_Listing_Cell: UITableViewCell {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIViewContentMode)
    {
      
            URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
            }).resume()
    }
}
