//
//  NewTaskVC.swift
//  To-Do List
//
//  Created by Awais Malik on 25/01/2023.
//

import UIKit

class NewTaskVC: UIViewController {
    
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescrition: UITextView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    @IBOutlet weak var btnCreateTask: UIButton!
    
    let network = Network()
    var isUpdateTask: Bool?
    var taskObj: TaskModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        if isUpdateTask ?? false{
            self.setUIForUpdateTask()
        }
       
    }
    
    // Set User interface for udate exisiting task
    func setUIForUpdateTask(){
        self.lblScreenTitle.text = "Edit Task"
        self.btnCreateTask.setTitle("Update Task", for: .normal)
        self.txtTitle.text = self.taskObj?.title ?? ""
        self.txtDescrition.text = self.taskObj?.description ?? ""
        self.datePickerView.setDate((self.taskObj?.dueDate ?? "").formateStringToDate(), animated: true)
    }
    
    
    // create new or update existing task
    @IBAction func createNewTaskAction(_ sender: UIButton){
        
        if !self.isAllRequiredFieldFilled(){
            return
        }
        let title = txtTitle.text ?? ""
        let desc = txtDescrition.text ?? ""
        let dueDate = datePickerView.date.formateDate()
        self.showProgressView(views: self.view)
        network.saveTaskToFirbase(taskIdforUpdate: self.taskObj?.taskID, title: title, description: desc, dueDate: dueDate, date: self.datePickerView.date) { msg, isSuccess in
            self.hideProgressView()
            if isSuccess{
                var titleAlert = "Task Created"
                var messageAlert = "New task created with title of \(title)"
                if self.isUpdateTask ?? false{
                    titleAlert = "Task Updated"
                     messageAlert = "New task updated with title of \(title)"
                }
                self.showAlertWithOneButton(titleAlert, message: messageAlert, buttonTitle: "Ok") { action in
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                self.showAlertMessage(message: msg)
            }
        }
    
        
    }
    
    // validate fields are not empty
    func isAllRequiredFieldFilled()-> Bool{
        if self.txtTitle.text ?? "" == "" || self.txtDescrition.text ?? "" == ""{
            self.showAlertMessage(message: "Please provide title and description of the task")
            return false
        }
        return true
    }
}
