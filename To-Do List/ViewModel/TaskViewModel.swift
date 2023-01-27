//
//  TaskViewModel.swift
//  To-Do List
//
//  Created by Awais Malik on 26/01/2023.
//

import Foundation
import UIKit


class TaskViewModel: NSObject {
    
    var isSuccess = false
    var errorString = ""
    let network = Network()

    private(set) var taskViewModel : [TaskModel]!{
        didSet {
            self.bindTaskViewModelToController(self.taskViewModel, errorString, isSuccess)
        }
    }
    var bindTaskViewModelToController : (([TaskModel], String, Bool) -> Void) = {_,_,_  in }
    
    var taskArray = [TaskModel]()
    
    override init() {
        super.init()
       
    }
    
    func loadTaskData(){
        network.loadTask { data, isTrue, msg in
            self.taskArray = data
            self.isSuccess = isTrue
            self.errorString = msg
            self.taskViewModel = self.taskArray
        }
    }
    
    func removeTask(indexNumber: Int){
        let taskId = self.taskArray[indexNumber].taskID
        network.removeTask(taskID: taskId) { isTrue, msg in
            self.isSuccess = isTrue
            self.errorString = msg
            if isTrue{
                self.taskArray.remove(at: indexNumber)
            }
            self.taskViewModel = self.taskArray
        }
    }
}
