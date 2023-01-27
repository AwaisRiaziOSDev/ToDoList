//
//  Network.swift
//  To-Do List
//
//  Created by Awais Malik on 25/01/2023.
//

import Foundation
import FirebaseAuth
import Firebase
class Network{
    
    // Register new user
    func signUpUser(email: String, password: String, completionBlock: @escaping (_ success: Bool, _ message: String) -> Void) {
        if !Connectivity.isConnectedToInternet() {
            completionBlock(false, "Please connect with internet first")
         }
            Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
                if let user = authResult?.user {
                    print(user)
                    completionBlock(true, "")
                } else {
                    completionBlock(false, error?.localizedDescription ?? "")
                }
            }
        }
    
    // login user
    func signInUser(email: String, pass: String, completionBlock: @escaping (_ success: Bool, _ message: String) -> Void) {
        
        if !Connectivity.isConnectedToInternet() {
            completionBlock(false, "Please connect with internet first")
         }
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if error != nil{
                completionBlock(false, error?.localizedDescription ?? "")
            } else {
                completionBlock(true, "")
            }
        }
    }
    
    // save new or update task
    func saveTaskToFirbase(taskIdforUpdate: String?, title: String, description: String, dueDate: String, date: Date, completionHandler:@escaping(String, Bool) -> Void){

        var ref = Database.database().reference()
        var taskID = ref.childByAutoId().key ?? ""
        if let updatetaskid = taskIdforUpdate{
            taskID = updatetaskid
        }
        let BodyDic = ["title":title, "description": description, "dueDate": dueDate, "taskID": taskID] as [String : Any]
        ref = ref.child(Auth.auth().currentUser?.uid ?? "").child("Tasks").child(taskID)
        if !Connectivity.isConnectedToInternet() {
            completionHandler("Please connect with internet first", false)
         }
        ref.updateChildValues(BodyDic){(error:Error?, ref: DatabaseReference) in
            DispatchQueue.main.async {
                if let error = error{
                    
                    completionHandler(error.localizedDescription, false)
                }
                else{
                    LocalNotification.init().schecduleNotificaion(identifier: taskID, title: title, body: description, dateTime: date)
                    completionHandler("Task Created", true)
                }
            }

        }
    }
    
    
    
    // get all tasks fro database
    func loadTask(completionHAndler:@escaping([TaskModel], Bool, String)->Void){
        let userId = Auth.auth().currentUser?.uid ?? ""
        var taskArray = [TaskModel]()
        let ref = Database.database().reference()
        if !Connectivity.isConnectedToInternet() {
            completionHAndler(taskArray, false, "Please connect with internet first")
         }
        ref.child(userId).child("Tasks").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
             if let objectDic = snapshot.value as? NSDictionary{
                 for obj in objectDic{
                     
                     if let taskObj = obj.value as? NSDictionary {
                        let title = taskObj["title"] as? String ?? ""
                        let description = taskObj["description"] as? String ?? ""
                        let dueDate = taskObj["dueDate"] as? String ?? ""
                        let taskID = taskObj["taskID"] as? String ?? ""
                        
                        let modelObj = TaskModel(title: title, description: description, dueDate: dueDate, taskID: taskID)
                         taskArray.append(modelObj)
                     }
                 }
                 completionHAndler(taskArray, true, "tasks found")
            }else{
                completionHAndler(taskArray, false, "No Task found")
            }

        })
        }
    
    // delete task from database
    func removeTask(taskID: String, completionHAndler:@escaping(Bool, String)->Void){
        if !Connectivity.isConnectedToInternet() {
            completionHAndler(false, "Please connect with internet first")
        }
        var ref = Database.database().reference()
        ref = ref.child(Auth.auth().currentUser?.uid ?? "").child("Tasks").child(taskID)
        ref.removeValue { error,db  in
        if error != nil {
            completionHAndler(false, error?.localizedDescription ?? "")
        }else{
            LocalNotification.init().removeNotification(identifier: taskID)
            completionHAndler(true, "Task deleted")
        }
      }
     
    }
    
}
