//
//  SecondViewController.swift
//  MemoryIssue
//
//  Created by Keun young Kim on 2018. 3. 6..
//  Copyright © 2018년 Keun young Kim. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
   
   class Person {
      var name = "John doe"
    // Strong retain cycle 발생 가능, Debug memory graph를 통해 확인 가능
      var membership: Membership?
      
      deinit {
         print("Person is being deinitialized")
      }
   }
   
   class Membership {
    // unowned는 weak대신 사용 가능!!!!!!!!
      unowned var owner: Person
      
      init(owner: Person) {
         self.owner = owner
      }
      
      deinit {
         print("Membership is being deinitialized")
      }
   }
   
   var person: Person? = Person()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Do any additional setup after loading the view.
      
      person?.membership = Membership(owner: person!)
   }
   
   deinit {
      print("\(self) is being deinitialized")
   }
}
