//
//  TaskModel.swift
//  To-Do List
//
//  Created by Awais Malik on 26/01/2023.
//

import Foundation

struct TaskModel: Codable{
    let title: String
    let description: String
    let dueDate: String
    let taskID: String
}
