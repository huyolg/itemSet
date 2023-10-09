//
//  HDirectRoomViewModel.swift
//  Project
//
//  Created by 胡某人 on 2023/10/9.
//

import UIKit
import RxCocoa
import RxSwift

class HDirectRoomViewModel: NSObject {
    public var dataSource = PublishSubject<[String]>()
    
    func fetchList() {
        let path = Bundle.main.path(forResource: "Rooms", ofType: "json")
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path!))
            let rooms = try JSONSerialization.jsonObject(with: data)
            
            dataSource.onNext(rooms as! PublishSubject<[String]>.Element)
            dataSource.onCompleted()
            print(rooms)
        } catch {
            
        }
        
    }
}
