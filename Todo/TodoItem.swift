//
//  Task.swift
//  Todo
//
//  Created by Ans Riaz on 11/11/2016.
//  Copyright © 2016 Ans Riaz. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    dynamic var notes = ""
    dynamic var isCompleted = false
    
}
