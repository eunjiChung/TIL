//
//  ThirdViewController.swift
//  MemoryIssue
//
//  Created by Keun young Kim on 2018. 3. 6..
//  Copyright © 2018년 Keun young Kim. All rights reserved.
//

import UIKit

class Car {
   var totalDistance: Double = 0.0
   var totalGas: Double = 0.0
   
    // 지연 속성 -> Double 리턴하는 closure
    // closure 안에서 self를 빼면 안됨 (그냥 외우기)
    // 어쨋든 여기서도 retain cycle 발생 -> 왜인지는 너무 어려움
    // closure안에서 closure 바깥 속성에 접근할 때는 self를 쓴다 -> Strong retain cycle이 생기기마련 -> closure capture list : self를 unowned나 weak로 바꿔준다
    // closure에서 발생하는 retain cycle문제는 이걸 쓴다. >> weak는 nonOptional이기 때문에 self?로 호출해야 함. 아니면 unowned를 쓰면 optional 가능
   lazy var gasMileage: () -> Double = { [unowned self] in
      return self.totalDistance / self.totalGas
   }
   
   func drive() {
      self.totalDistance += Double(arc4random_uniform(1000) + 1000)
      self.totalGas += Double(arc4random_uniform(100) + 50)
   }
   
   deinit {
      print("Car is being deinitialized")
   }
}


class ThirdViewController: UIViewController {
   
   var myCar: Car? = Car()
   
   @IBAction func noLeak(_ sender: Any) {
      myCar?.drive()
   }
   
    // leak 발생 (그러나 memory graph에서는 발생하지 않는다 -> 만능이 아니다, 얘만으로는 충분히 알 수 없다 -> cmd + I로 profile의 leak보기)
    //
   @IBAction func leak(_ sender: Any) {
      myCar?.drive()
      print(myCar?.gasMileage() ?? 0.0)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Do any additional setup after loading the view.
   }
   
   
   deinit {
      print("\(self) is being deinitialized")
   }
}
