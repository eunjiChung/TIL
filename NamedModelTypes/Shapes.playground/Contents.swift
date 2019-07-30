

import Foundation


// type을 String으로 지정
enum ColorName: String, CaseIterable {
    // Case별로 나눠줘도 되고, 한 줄에 쭈루룩 써도 된다!
    // CaseIterable: 선언하면 자동적으로 allCases라는 Collection을 쓴 순서대로 생성
    case black, silver, gray, white, maroon, red, purple, fuchsia, green, lime, olive, yellow, navy, blue, teal, aqua
}

let fill = ColorName.gray

//for color in ColorName.allCases {
//    print("I love the color \(color)")
//}


// Associated Values
enum CSSColor {
    case named(name: ColorName)                      // ColorName value랑 관련된 data
    case rgb(red: UInt8, green: UInt8, blue: UInt8)  // 세 가지 UInt8 (0-255)와 관련된 data
}


extension CSSColor: CustomStringConvertible {
    var description: String {
        switch self {
        case .named(let colorName):
            return colorName.rawValue
        case .rgb(let red, let green, let blue):
            return String(format: "#%02X%02X%02X", red, green, blue)
        }
    }
}

//let color1 = CSSColor.named(name: .red)
//print("\(color1)")
//let color2 = CSSColor.rgb(red: 0xAA, green: 0xAA, blue: 0xAA)
//print("\(color2)")


extension CSSColor {
    init(gray: UInt8) {
        self = .rgb(red: gray, green: gray, blue: gray)
    }
}

//let color3 = CSSColor(gray: 0xaa)
//print(color3)


extension CSSColor {
    enum ColorName: String, CaseIterable {
        case black, silver, gray, white, maroon, red, purple, fuchsia, green, lime, olive, yellow, navy, blue, teal, aqua
    }
}



///////////////////////// Struct ///////////////////////////////////////////


// DrawingContext라는 것을 그리기 위한 draw method 가짐
protocol Drawable {
    func draw(with context: DrawingContext)
}

// Circle, Rectangle 등 순수한 geometric type들을 어떻게 그리는 지 안다
// 실제로 그리는 법은 SVG, HTML 5 Canvas, Core Graphics, OpenGL, Metal, etc.를 이용하여 구현
protocol DrawingContext {
    func draw(_ circle: Circle)
    func draw(_ rectangle: Rectangle)
}

struct Rectangle: Drawable {
    var strokeWidth = 5
    var strokeColor = CSSColor.named(name: .teal)
    var fillColor = CSSColor.named(name: .aqua)
    var origin = (x: 110.0, y: 10.0)
    var size = (width: 100.0, height: 130.0)
    
    func draw(with context: DrawingContext) {
        context.draw(self)
    }
}

@dynamicMemberLookup // struct의 property에 접근할 때 얘가 subscript method를 호출한다
struct Circle: Drawable {
    var strokeWidth = 5
    var strokeColor = CSSColor.named(name: .red)
    var fillColor = CSSColor.named(name: .yellow)
    var center = (x: 80.0, y: 160.0)
    var radius = 60.0
    
    func draw(with context: DrawingContext) {
        // 이제 DrawingContext는 self 덕분에 Circle을 그릴 줄 안다!!
        context.draw(self)
    }
    
    subscript(dynamicMember member: String) -> String {
        let properties = ["name": "Mr Circle"]
        return properties[member, default: ""]
    }
}


////////////////////////// Class /////////////////////////////////////

// method들을 적절한 XML로 렌더링하도록 만든다
// final : 얘를 표시해서 override로부터 메소드, 속성 또는 subscript를 막을 수 있다 (??)
final class SVGContext: DrawingContext {
    private var commands: [String] = []
    
    var width = 250
    var height = 250
    
    // 1
    // conform protocol
    func draw(_ circle: Circle) {
        let command = """
        <circle cx='\(circle.center.x)' cy='\(circle.center.y)\' r='\(circle.radius)' \
        stroke='\(circle.strokeColor)' fill='\(circle.fillColor)' \
        stroke-width='\(circle.strokeWidth)' />
        """
        commands.append(command)
    }
    
    // 2
    func draw(_ rectangle: Rectangle) {
        let command = """
        <rect x='\(rectangle.origin.x)' y='\(rectangle.origin.y)' \
        width='\(rectangle.size.width)' height='\(rectangle.size.height)' \
        stroke='\(rectangle.strokeColor)' fill='\(rectangle.fillColor)' \
        stroke-width='\(rectangle.strokeWidth)' />
        """
        
        commands.append(command)
    }
    
    var svgString: String {
        var output = "<svg width='\(width)' height='\(height)'>"
        
        for command in commands {
            output += command
        }
        output += "</svg>"
        return output
    }
    
    var htmlString: String {
        return "<!DOCTYPE html><html><body>" + svgString + "</body></html>"
    }
}


// Drawable 객체를 많이 포함하는 Document type
struct SVGDocument {
    var drawables: [Drawable] = []
    
    // Computed Property로
    // SVGContext를 생성하고 그 context의 string HTML을 리턴
    var htmlString: String {
        let context = SVGContext()
        for drawable in drawables {
            drawable.draw(with: context)
        }
        return context.htmlString
    }
    
    // mutating : 구조체 내부에서 데이터를 수정할때 선언
    // 이 선언에 따라 원래 구조체 내부 값을 변경하는건지 아닌지 유추
    mutating func append(_ drawable: Drawable) {
        drawables.append(drawable)
    }
}


var document = SVGDocument()

let rectangle = Rectangle()
document.append(rectangle)

let circle = Circle()
document.append(circle)

let htmlString = document.htmlString
print(htmlString)


import WebKit
import PlaygroundSupport

let view = WKWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
view.loadHTMLString(htmlString, baseURL: nil)
PlaygroundPage.current.liveView = view



extension Circle {
    // 원래는 get-set 둘다 필요하면
    // 둘 다 써주지만
    var diameter: Double {
        get {
            return radius * 2
        }
        set {
            radius = newValue / 2
        }
    }
    
    // 특별히 getter만 쓰고 싶을 때 get{} 블록을 쓸 필요 없이 그냥 쓰면 된다!!
    // 이것이 computed property!!!!!!!
    var area: Double {
        return radius * radius * Double.pi
    }
    var perimeter: Double {
        return 2 * radius * Double.pi
    }
    
    // mutating...
    mutating func shift(x: Double, y: Double) {
        center.x += x
        center.y += y
    }
}


extension Rectangle {
    var area: Double {
        return size.width * size.height
    }
    
    var perimeter: Double {
        return 2 * (size.width + size.height)
    }
}

protocol ClosedShape {
    var area: Double { get }
    var perimeter: Double { get }
}

extension Circle: ClosedShape {}
extension Rectangle: ClosedShape {}

func totalPerimeter(shapes: [ClosedShape]) -> Double {
    return shapes.reduce(0) { $0 + $1.perimeter }
}

totalPerimeter(shapes: [circle, rectangle])







