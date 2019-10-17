//
//  ChatModel.swift
//  HowlTalk
//
//  Created by eunji on 17/10/2019.
//  Copyright © 2019 CHUNGEUNJI. All rights reserved.
//

// json을 Object로 만들어주는 Mapper
import ObjectMapper

class ChatModel: Mappable {

    // 1대다 채팅모델 도입
    public var users: Dictionary<String, Bool> = [:] // 채팅방에 참여한 사람들
    public var comments: Dictionary<String, Comment> = [:] // 채팅방의 대화내용
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        users <- map["users"]
        comments <- map["comments"]
    }
    
    public class Comment: Mappable {
        public var uid: String?
        public var message: String?
        
        public required init?(map: Map) {
            
        }
        
        public func mapping(map: Map) {
            uid <- map["uid"]
            message <- map["message"]
        }
    }
}
