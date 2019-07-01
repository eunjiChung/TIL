//
//  DataManager.swift
//  MemoApp5
//
//  Created by CHUNGEUNJI on 2018. 3. 26..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import Foundation
import CoreData


// 새로운 Notification 추가
extension Notification.Name {
    static let NewDataDidFetch = Notification.Name("NewDataDidFetchNotification")
    static let NewDataDidInsert = Notification.Name("NewDataDidInsertNotification")
    static let DataDidDelete = Notification.Name("DataDidDeleteNotification")
}



class DataManager {
    
    // *
    static let shared = DataManager()
    
    let memoEntityName = "Memo"
    
    var list = [MemoEntity]()
    
    var context : NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // *
    lazy var persistentContainer : NSPersistentContainer = {
        // 이름을 넣어준다
        let container = NSPersistentContainer(name: "MemoApp5")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as Error? {
                fatalError()
            }
        })
        return container
    }()
    
    
    private init() {
        
    }
    
    
    // 기능 4가지 포함
    
    // Save
    func save() {
        do {
            try context.save()
            print("============= Saved ============")
        } catch {
            print(error)
        }
    }
    
    
    // Create
    func create(with title: String, content: String) {
        let newMemo = NSEntityDescription.insertNewObject(forEntityName: memoEntityName, into: context) as! MemoEntity
        newMemo.title = title
        newMemo.content = content
        newMemo.insertDate = Date()
        
        save()
        
        list.append(newMemo)
        NotificationCenter.default.post(name: NSNotification.Name.NewDataDidInsert, object: nil)
    }
    
    // Read
    func read() {
        let request = NSFetchRequest<MemoEntity>(entityName: memoEntityName)
        
        do {
            list.removeAll(keepingCapacity: true) //???
            list = try context.fetch(request)
        } catch {
            print(error)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name.NewDataDidFetch, object: nil)
    }
    
    // Delete
    func delete(memo: MemoEntity) {
        context.delete(memo)
        save()
        
        if let index = list.index(of: memo) {
            list.remove(at: index)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name.DataDidDelete, object: nil)
    }
}































