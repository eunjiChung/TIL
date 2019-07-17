/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import RxSwift
import RxCocoa

class ChocolatesOfTheWorldViewController: UIViewController {
  @IBOutlet private var cartButton: UIBarButtonItem!
  @IBOutlet private var tableView: UITableView!
  
  // just(_:) : 값에 아무런 변화도 없지만, Observable 값으로 접근하고 싶다
  let europeanChocolates = Observable.just(Chocolate.ofEurope)
  private let disposeBag = DisposeBag()
}

//MARK: View Lifecycle
extension ChocolatesOfTheWorldViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Chocolate!!!"
    
    setupCartObserver()
    setupCellConfiguration()
    setupCellTapHandling()
  }
}

//MARK: - Rx Setup
private extension ChocolatesOfTheWorldViewController {
  // Observer를 추가하여 ShoppingCart를 자동으로 업데이트 해준다
  // RxSwift는 chained function을 잘 쓴다
  // 각 function은 이전 function의 결과를 반영한다
  func setupCartObserver() {
    // 쇼핑 카트의 초콜릿 값들을 Observable로 만든다....?
    ShoppingCart.sharedCart.chocolates.asObservable()
      // subscribe(onNext:)로 Observable이 값의 변화를 감지하게 한다
      // subscribe의 closure는 값의 변화를 반영한다
      // dispose할 때까지 계속 notification을 받는다
      .subscribe(onNext: { [unowned self] chocolates in
        self.cartButton.title = "\(chocolates.count) "
      })
      .disposed(by: disposeBag)
  }
  
  // TableView의 셀을 만든다
  // 셀은 React하다...?
  func setupCellConfiguration() {
    
    // europeanChocolates을 Tableview의 각 row에 observable하게 만든다
    europeanChocolates
      .bind(to: tableView
        .rx // 이걸 선언하여 UITableView의 RxCocoa extension에 접근 가능
        .items(cellIdentifier: ChocolateCell.Identifier, cellType: ChocolateCell.self)) {
          // items(cellIdentifier:cellType:) 메소드를 이용하여 cell을 바인딩해준다
          row, chocolate, cell in
          // 새로운 아이템 바인딩
          // tableView(_:cellForRowAt:), tableView(_:numberOfRowsInSection:), numberOfSections(in:)은 자동적으로 관찰하는 데이터에 따라 계산된다
          cell.configureWithChocolate(chocolate: chocolate)
      }
      .disposed(by: disposeBag)
  }
  
  func setupCellTapHandling() {
    tableView
      .rx
    .modelSelected(Chocolate.self)  // tableView의 reactive extension, 어떤 아이템 타입을 받을 건지 Chocolate이라고 정해준다, 이것은 Observable을 리턴해준다
      .subscribe(onNext: { [unowned self] chocolate in    // 모델이 선택되면 언제 어떻게 동작될지 서술
        let newValue = ShoppingCart.sharedCart.chocolates.value + [chocolate]
        ShoppingCart.sharedCart.chocolates.accept(newValue)
        
        if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
          self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)  // 탭한 row를 deselect해준다
        }
      }, onError: nil, onCompleted: nil, onDisposed: nil) // subscribe는 Disposable을 리턴하므로
    .disposed(by: disposeBag) // 마지막에 disposeBag해준다...
  }
}

//MARK: - Imperative methods
private extension ChocolatesOfTheWorldViewController {
}

// MARK: - SegueHandler
extension ChocolatesOfTheWorldViewController: SegueHandler {
  enum SegueIdentifier: String {
    case goToCart
  }
}
