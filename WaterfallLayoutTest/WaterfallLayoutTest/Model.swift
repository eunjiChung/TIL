//
//  Model.swift
//  WaterfallLayoutTest
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class Model: NSObject {
    
    var images : [UIImage] = []
    
    // Assemble an array of images to use for sample content for the collectionView
    func buildDataSource(){
        images = (1...9).map { UIImage(named: "image\($0)")! }
    }
}
