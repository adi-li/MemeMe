//
//  UIImage+InitWithView.swift
//  MemeMe
//
//  Created by Adi Li on 6/9/15.
//  Copyright (c) 2015 Adi Li. All rights reserved.
//

import UIKit

extension UIImage {
    class func fromView(view: UIView, afterScreenUpdates: Bool) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, UIScreen.mainScreen().scale)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: afterScreenUpdates)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return image
    }
}
