//
//  ViewController.swift
//  Todo
//
//  Created by Ans Riaz on 11/11/2016.
//  Copyright © 2016 Ans Riaz. All rights reserved.
//

import UIKit
import RealmSwift


class TaskListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var lists : Results<TodoList>!
    
    var isEditingMode = false
    
    var currentCreateAction:UIAlertAction!
    @IBOutlet weak var taskListsTableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        readTodosAndUpdateUI()
    }
    
    func readTodosAndUpdateUI(){
        
        lists = realm.objects(TodoList.self)
        self.taskListsTableView.setEditing(false, animated: true)
        self.taskListsTableView.reloadData()
    }
    
    @IBAction func didSelectSortCriteria(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            
            // A-Z
            self.lists = self.lists.sorted(byProperty: "name")
        }
        else{
            // date
            self.lists = self.lists.sorted(byProperty: "createdAt", ascending:false)
        }
        self.taskListsTableView.reloadData()
    }
    
    @IBAction func didClickOnEditButton(_ sender: UIBarButtonItem) {
        isEditingMode = !isEditingMode
        self.taskListsTableView.setEditing(isEditingMode, animated: true)
    }
    
    @IBAction func didClickOnAddButton(_ sender: UIBarButtonItem) {
        
        displayAlertToAddTodoList(nil)
    }
    
    func listNameFieldDidChange(_ textField:UITextField){
        self.currentCreateAction.isEnabled = (textField.text?.characters.count)! > 0
    }
    
    func displayAlertToAddTodoList(_ updatedList:TodoList!){
        
        var title = "New Todo List"
        var doneTitle = "Create"
        if updatedList != nil{
            title = "Update Todo List"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Write the name of your todo list.", preferredStyle: UIAlertControllerStyle.alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.default) { (action) -> Void in
            
            let listName = alertController.textFields?.first?.text
            
            if updatedList != nil{
                // update mode
                try! realm.write{
                    updatedList.name = listName!
                    self.readTodosAndUpdateUI()
                }
            }
            else{
                
                let newTodoList = TodoList()
                newTodoList.name = listName!
                
                try! realm.write{
                    
                    realm.add(newTodoList)
                    self.readTodosAndUpdateUI()
                }
            }
            
            print(listName ?? "Ans")
        }
        
        alertController.addAction(createAction)
        createAction.isEnabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Todo List Name"
            textField.addTarget(self, action: #selector(TaskListsViewController.listNameFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            if updatedList != nil{
                textField.text = updatedList.name
            }
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let listsTodos = lists{
            return listsTodos.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell")
        
        let list = lists[indexPath.row]
        
        cell?.textLabel?.text = list.name
        cell?.detailTextLabel?.text = "\(list.todoList.count) Todos"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            let listToBeDeleted = self.lists[indexPath.row]
            try! realm.write{
                
                realm.delete(listToBeDeleted)
                self.readTodosAndUpdateUI()
            }
        }
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit") { (editAction, indexPath) -> Void in
            
            let listToBeUpdated = self.lists[indexPath.row]
            self.displayAlertToAddTodoList(listToBeUpdated)
            
        }
        return [deleteAction, editAction]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "openTasks", sender: self.lists[indexPath.row])
    }
    
    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let tasksViewController = segue.destination as! TasksViewController
        tasksViewController.selectedList = sender as! TodoList
    }
    
}
