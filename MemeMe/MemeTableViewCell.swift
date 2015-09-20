//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Adi Li on 20/9/15.
//  Copyright © 2015 Adi Li. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeLabel: UILabel!
    
    var meme: Meme? {
        didSet {
            updateViewForMeme(meme)
        }
    }
    
    func updateViewForMeme(meme: Meme?) {
        memeImageView.image = meme?.memedImage
        memeLabel.text = meme?.text
    }
    
}
