//
//  TaskList.swift
//  Todo
//
//  Created by Ans Riaz on 11/11/2016.
//  Copyright © 2016 Ans Riaz. All rights reserved.
//

import Foundation
import RealmSwift

class TodoList: Object {
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    let todoList = List<TodoItem>()
}
