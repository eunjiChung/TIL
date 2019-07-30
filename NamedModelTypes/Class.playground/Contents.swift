//
//
//import Foundation
//
//class Shape {
//    var strokeWidth = 1
//    var strokeColor = CSSColor.named(name: .black)
//    var fillColor = CSSColor.named(name: .black)
//    var origin = (x: 0.0, y: 0.0)
//    func draw(with context: DrawingContext) { fatalError("not implemented") }
//}
//
//class Circle: Shape {
//    override init() {
//        super.init()
//        strokeWidth = 5
//        strokeColor = CSSColor.named(name: .red)
//        fillColor = CSSColor.named(name: .yellow)
//        origin = (x: 80.0, y: 80.0)
//    }
//
//    var radius = 60.0
//    override func draw(with context: DrawingContext) {
//        context.draw(self)
//    }
//}
//
//
//class Rectangle: Shape {
//    override init() {
//        super.init()
//        strokeWidth = 5
//        strokeColor = CSSColor.named(name: .teal)
//        fillColor = CSSColor.named(name: .aqua)
//        origin = (x: 110.0, y: 10.0)
//    }
//
//    var size = (width: 100.0, height: 130.0)
//    override func draw(with context: DrawingContext) {
//        context.draw(self)
//    }
//}
//
