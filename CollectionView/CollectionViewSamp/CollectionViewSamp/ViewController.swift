//
//  ViewController.swift
//  CollectionViewSamp
//
//  Created by CHUNGEUNJI on 2018. 1. 29..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) // 얘는 강제추출 안함
        
        if let imgView = cell.viewWithTag(100) as? UIImageView {
            let imgName = "img\(indexPath.item % 4)"
            imgView.image = UIImage(named: imgName)
        }
        
        return cell
    }
    
    
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    // cell의 크기를 계산해서 되돌려줌
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        var cellSize = CGSize.zero
        // collectionView의 현재크기를 전달
        cellSize.width = (collectionView.bounds.width - layout.minimumInteritemSpacing) / 2.0
        cellSize.height = (collectionView.bounds.width - 10.0) / 2.0
        
        return cellSize
    }
}















