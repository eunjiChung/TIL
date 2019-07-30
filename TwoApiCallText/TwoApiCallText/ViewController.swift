//
//  ViewController.swift
//  TwoApiCallText
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 21/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var images: [ImageRecord] = []
    let queue = OperationQueue()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchData()
    }
    
    func fetchData() {
        
        let pendingOperations = PendingOperations()
        
        let imageRequester = ImageRequester.init("flower")
        
        imageRequester.completionBlock = {
            self.images = imageRequester.images
            print("Image Result: ", self.images)
            print("Image Count: ", self.images.count)
        }
        
        pendingOperations.queue.addOperation(imageRequester)
        
//        operation1.completionBlock = {
//            print("Image Records: ", self.images)
//            print("Image Count: ", self.images.count)
//        }
//
//        let operation2 = BlockOperation {
//            print("Update...")
//        }
//        operation2.completionBlock = {
//            print("Image 2: ", self.images)
//            print("Image 2: ", self.images.count)
//        }
//
//        operation2.addDependency(operation1)
//        queue.addOperation(operation1)
//        queue.addOperation(operation2)
    }

}

