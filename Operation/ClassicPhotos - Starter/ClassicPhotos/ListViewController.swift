/// Copyright (c) 2018 Razeware LLC
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
import CoreImage

let dataSourceURL = URL(string:"http://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist")!

class ListViewController: UITableViewController {
    
    // 나타낼 photo 배열
    var photos: [PhotoRecord] = []
    // Operation&OperationQueue들을 관리하는 Class
    let pendingOperations = PendingOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Classic Photos"
        fetchPhotoDetails()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        // 셀 오른쪽 악세사리가 없으면 activity indicator 설정
        // 사용자에게 피드백을 준다
        if cell.accessoryView == nil {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            cell.accessoryView = indicator
        }
        let indicator = cell.accessoryView as! UIActivityIndicatorView
        
        // 2
        let photoDetails = photos[indexPath.row]
        
        // 3
        cell.textLabel?.text = photoDetails.name
        cell.imageView?.image = photoDetails.image
        
        // 4
        switch photoDetails.state {
        case .filtered:
            indicator.stopAnimating()
        case .failed:
            indicator.stopAnimating()
            cell.textLabel?.text = "Failed to load"
        case .new, .downloaded:
            indicator.startAnimating()
            // TableView가 scrolling하지 않을때만 이미지를 로딩한다 - UIScrollView의 property
            if !tableView.isDragging && !tableView.isDecelerating {
                startOperations(for: photoDetails, at: indexPath)
            }
        }
        
        return cell
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Operation 보류
        suspendAllOperations()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnScreenCells()
            resumeAllOperations()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnScreenCells()
        resumeAllOperations()
    }
    
    func suspendAllOperations() {
        // 모든 operation들을 suspend한다
        // 개별로 할 수 없음
        pendingOperations.downloadQueue.isSuspended = true
        pendingOperations.filterationQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
        pendingOperations.downloadQueue.isSuspended = false
        pendingOperations.filterationQueue.isSuspended = false
    }
    
    func loadImagesForOnScreenCells() {
        if let pathsArray = tableView.indexPathsForVisibleRows {
            
            // download와 filteration operation에 있는 모든 indexPath들을 모은다
            var allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            allPendingOperations.formUnion(pendingOperations.filterationsInProgress.keys)
            
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray)
            // toBeCancel될 paths 중 visiblePath들을 제외한다
            toBeCancelled.subtract(visiblePaths)
            
            var toBeStarted = visiblePaths
            // toBeStarted될 paths 중 allPendingOperations indexPath는 지운다???
            // 이미 pending 중인 operation을 지우는 것!
            toBeStarted.subtract(allPendingOperations)
            
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                
                if let pendingFilteration = pendingOperations.filterationsInProgress[indexPath] {
                    pendingFilteration.cancel()
                }
                pendingOperations.filterationsInProgress.removeValue(forKey: indexPath)
            }
            
            for indexPath in toBeStarted {
                let recordToProgress = photos[indexPath.row]
                startOperations(for: recordToProgress, at: indexPath)
            }
            
        }
    }
    
    
    func startOperations(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        switch photoRecord.state {
        case .new:
            startDownload(for: photoRecord, at: indexPath)
        case .downloaded:
            startFilteration(for: photoRecord, at: indexPath)
        default:
            print("Nothing...")
        }
    }
    
    func startDownload(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        // 1
        guard pendingOperations.downloadsInProgress[indexPath] == nil else {
            return
        }
        
        // 2
        let downloader = ImageDownloader(photoRecord)
        
        // 3
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        
        // 4
        pendingOperations.downloadsInProgress[indexPath] = downloader
        
        // 5
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func startFilteration(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        // filtering Operation Queue에 아무것도 없는 것을 확인
        guard pendingOperations.filterationsInProgress[indexPath] == nil else {
            return
        }
        
        // filter operation 생성
        let filterer = ImageFilteration(photoRecord)
        filterer.completionBlock = {
            if filterer.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperations.filterationsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        
        // Key : indexPath, Value : Filterer Operation - 딕셔너리로 매칭
        pendingOperations.filterationsInProgress[indexPath] = filterer
        // OperationQueue에 filterer operation 추가
        pendingOperations.filterationQueue.addOperation(filterer)
    }
    
    // MARK: - image processing
    func applySepiaFilter(_ image:UIImage) -> UIImage? {
        let inputImage = CIImage(data:UIImagePNGRepresentation(image)!)
        let context = CIContext(options:nil)
        let filter = CIFilter(name:"CISepiaTone")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter!.setValue(0.8, forKey: "inputIntensity")
        
        guard let outputImage = filter!.outputImage,
            let outImage = context.createCGImage(outputImage, from: outputImage.extent) else {
                return nil
        }
        return UIImage(cgImage: outImage)
    }
    
    
    func fetchPhotoDetails() {
        let request = URLRequest(url: dataSourceURL)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true //이게 모죠?
        
        // 1
        // URLSession은 image property list를 background thread에서 다운로드 한다
        let task = URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            // 2
            let alertController = UIAlertController(title: "Oops!", message: "There was an error fetching photo details.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            if let data = data {
                do {
                    //3
                    // property list여서 property list 타입으로 만들어주는 것!
                    let dataSourceDictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:String]
                    
                    //4
                    // array build
                    for (name, value) in dataSourceDictionary {
                        let url = URL(string: value)
                        if let url = url {
                            let photoRecord = PhotoRecord.init(name: name, url: url)
                            self.photos.append(photoRecord)
                        }
                    }
                    
                    //5
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.tableView.reloadData()
                    }
                    // 6
                } catch {
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            
            // 6
            if error != nil {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        // 7
        task.resume()
    }
    
    
}
