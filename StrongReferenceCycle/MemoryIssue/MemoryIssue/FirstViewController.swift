//
// 메모리 테스트는 항상 디바이스에서 실행하기
// 앱을 만들때 큰 앱이 아니면 한달이면 끝난대... -> 그러니까 일주일에 한번씩 메모리 테스트
// 대표적으로 발생하는 세 가지 메모리 문제에 대해 다룸
// 앱의 메모리가 150MB 이상 되면 죽는다 -> 따라서 메모리 누수를 막아야함 -> 혼자일때 메모리 테스트를 어떻게 해?
//

/*
 
 Stack은 실행되는 코드가 없어지면 자동 삭제되지만,
 Heap은 메모리가 자동 삭제되지 않는다
 
 Ownership Policy
 
 retain : owner가 메모리를 소유한다
 Reference Count : 메모리 소유자의 수
 
 ARC : Automatic Reference Counting
 이 방법으로 메모리 관리
 
 Memory Management
 강의 중에서 closure self list를 들으면 됨
 
 */



// 첫번째, 메모리 누수를 잡는 방법

import UIKit


class FirstViewController: UIViewController {
   
   class Person {
      var name = "John doe"
      var car: Car?
    
    // 소멸자
    // 클래스 인스턴스가 메모리에서 사라지기 전에 호출된다
    // 그러나 Strong Reference일 때, 실행해보면 얘가 호출되지 않는것으로 보아 메모리 누수가 발생되는 걸 알 수 있음
      deinit {
         print("Person is being deinitialized")
      }
   }
   
   class Car {
      var model = "Porsche 911"
    // 메모리 누수를 막기 위해 weak 지정 >> leak을 피하려면 클래스 내부 중 하나 '속성을 weak로 만든다'!!
    // weak를 붙이려면 형식은 Optional이 되어야 함
    // 만약 non-Optional일 경우, unowned reference(비소유 참조) : 참조 가능, count는 증가하지 않음.
      weak var owner: Person?
      
      deinit {
         print("Car is being deinitialized")
      }
   }

   
   
   
   var person: Person? = Person()
   var car: Car? = Car()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Do any additional setup after loading the view.      
      // 서로 Strong Reference, 그래서 여전히 남아있음
      person?.car = car
      car?.owner = person
   }
   
   
   deinit {
      print("\(self) is being deinitialized")
   }
   
}
