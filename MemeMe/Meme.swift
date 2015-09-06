//
//  Meme.swift
//  MemeMe
//
//  Created by Adi Li on 6/9/15.
//  Copyright (c) 2015 Adi Li. All rights reserved.
//

import UIKit

class Meme {
    var topText: String = ""
    var bottomText: String = ""
    var image: UIImage
    var memedImage: UIImage

    init(image: UIImage, memedImage: UIImage, topText: String = "", bottomText: String = "") {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}