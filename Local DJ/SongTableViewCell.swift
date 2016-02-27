//
//  SongTableViewCell.swift
//  Local DJ
//
//  Created by Kirill Kudaev, Jami Wissman on 1/26/16.
//  Copyright © 2016 Kirill Kudaev, Jami Wissman. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songAlbumCoverImageView: UIImageView!
    @IBOutlet weak var songArtistLabel: UILabel!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!

//    @IBAction func upPressed(sender: AnyObject) {
//        print("UP was pressed")
//    }
//    
//    @IBAction func downPressed(sender: AnyObject) {
//        print("DOWN was dressed")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
