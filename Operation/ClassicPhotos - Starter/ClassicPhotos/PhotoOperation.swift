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

enum PhotoRecordState {
    case new, downloaded, filtered, failed
}

class PhotoRecord {
    let name: String
    let url: URL
    var state = PhotoRecordState.new
    var image = UIImage(named: "placeholder")
    
    init(name:String, url:URL) {
        self.name = name
        self.url = url
    }
}

// Operation Status Tracking Class
class PendingOperations {
    
    // 테이블 IndextPath에 대한 Operation을 추적하기 위한 variable
    // Download operations와 filteration operation들을 관리하기 위한 Queue를 두 개 둔다
    // lazy : 불리기 전까지는 초기화되지 않는다, 앱의 performance를 향상시킴
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download Queue"
        // 한번의 하나의 operation만 수행하기 위해
        // 여러개를 해도 됨
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    lazy var filterationsInProgress: [IndexPath: Operation] = [:]
    lazy var filterationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Image Filteration queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}


// Operation은 abstract class로 이렇게 상속받기 위해서만 쓰인다
// Operation을 상속받은 class는 하나의 Task를 수행한다
class ImageDownloader: Operation {
    // 1
    // Operation과 관련된 PhotoRecord 클래스 추가
    let photoRecord: PhotoRecord
    
    // 2
    // PhotoRecord가 전달될 수 있는 생성자
    init(_ photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    // 갑자기 왠 main...?
    // 3
    // 작업을 수행하기 위한 메소드
    // Operation의 main()을 오버라이딩한다
    override func main() {
        
        // 4
        // 작업 시작 전에 cancelled 확인 : 긴 작업을 하기 전엔 항상 체크해주어야 한다
        if isCancelled {
            return
        }
        
        // 5
        // 이미지 다운로드
        guard let imageData = try? Data(contentsOf: photoRecord.url) else { return }
        
        // 6
        if isCancelled {
            return
        }
        
        // 7
        if !imageData.isEmpty {
            photoRecord.image = UIImage(data: imageData)
            photoRecord.state = .downloaded
        } else {
            photoRecord.state = .failed
            photoRecord.image = UIImage(named: "Failed")
        }
    }
}


class ImageFilteration: Operation {
    let photoRecord: PhotoRecord
    
    init(_ photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        guard self.photoRecord.state == .downloaded else {
            return
        }
        
        if let image = photoRecord.image,
            let filteredImage = applySepiaFilter(image) {
            photoRecord.image = filteredImage
            photoRecord.state = .filtered
        }
    }
    
    func applySepiaFilter(_ image: UIImage) -> UIImage? {
        guard let data = UIImagePNGRepresentation(image) else { return nil }
        let inputImage = CIImage(data: data)
        
        if isCancelled {
            return nil
        }
        
        let context = CIContext(options: nil)
        
        guard let filter = CIFilter(name: "CISepiaTone") else { return nil }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(0.8, forKey: "inputIntensity")
        
        if isCancelled {
            return nil
        }
        
        guard
            let outputImage = filter.outputImage,
            let outImage = context.createCGImage(outputImage, from: outputImage.extent)
            else {
                return nil
        }
        
        return UIImage(cgImage: outImage)
    }
}































