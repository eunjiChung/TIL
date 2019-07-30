//
//  Library.swift
//  TwoApiCallText
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 21/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import Foundation
import UIKit

typealias HTTPHeaders = [String:String]
typealias JSONDictionary = [String: Any]
typealias SuccessHandler = (Any) -> ()
typealias FailureHandler = (Error) -> ()

class Library: NSObject {
    
    var imagePath = "https://dapi.kakao.com/v2/search/image"
    var vclipPath = "https://dapi.kakao.com/v2/search/vclip"
    
    static let shared = Library()
    let apiService = APIService()
    
    func requestPhoto(keyword: String,
                      success: @escaping SuccessHandler,
                      failure: @escaping FailureHandler) {
        apiService.GETRequest(path: imagePath,
                                       query: keyword,
                                       success: success,
                                       failure: failure)
    }
    
    func requestVclip(keyword: String,
                      success: @escaping SuccessHandler,
                      failure: @escaping FailureHandler) {
        apiService.GETRequest(path: vclipPath,
                                       query: keyword,
                                       success: success,
                                       failure: failure)
    }
}
