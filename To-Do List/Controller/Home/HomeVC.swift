//
//  HomeVC.swift
//  To-Do List
//
//  Created by Awais Malik on 25/01/2023.
//
// MARK: - Navigation
import UIKit
import FirebaseAuth
class HomeVC: UIViewController {
    
    
    @IBOutlet weak var lblNoTask: UILabel!
    @IBOutlet weak var tblTask: UITableView!
    private var taskViewModel : TaskViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.lblNoTask.isHidden = true
        self.loadAllTask()
    }
    
    // Load all the tasks form firebase
    func loadAllTask(){
        self.taskViewModel = TaskViewModel()
        self.taskViewModel.bindTaskViewModelToController = { obj, message, isSuccess  in
            DispatchQueue.main.async {
                self.hideProgressView()
                if isSuccess{
                    if obj.count == 0{
                        self.lblNoTask.isHidden = false
                        self.tblTask.alpha = 0
                    }
                    self.tblTask.alpha = 1
                    
                }else{
                    self.lblNoTask.isHidden = false
                    self.showAlertMessage(message: message)
                }
                self.tblTask.reloadData()
            }
        }
        self.showProgressView(views: self.view)
        self.taskViewModel.loadTaskData()
    }
    
    
    @IBAction func addTaskAction(_ sender: UIButton){
        // Navigate to Task list screen
        let vc = NewTaskVC.instantiateFromStoryboard("Home")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func signOutAction(_ sender: UIButton){
        self.showAlertWithTwoButton("Log Out", message: "Are you sure you want to be log out?", buttonTitleOne: "Yes", buttonTitleTwo: "No") { action in
            self.logoutUser()
        } handlerTwo: { action2 in
        }

    }
    
    func logoutUser() {
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        navigationController?.popToRootViewController(animated: true)
    }
}

// TableView
extension HomeVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskViewModel.taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        cell.object = self.taskViewModel.taskArray[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")
            self.showAlertWithTwoButton("Remove Task", message: "Are you sure you want to remove this task?", buttonTitleOne: "Yes", buttonTitleTwo: "No") { action in
                self.removeTask(indexNumber: indexPath.row)
            }handlerTwo: { action2 in
            }
            completionHandler(true)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")
            let vc = NewTaskVC.instantiateFromStoryboard("Home")
            vc.isUpdateTask = true
            vc.taskObj = self.taskViewModel.taskArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            
            completionHandler(true)
        }
        edit.image = UIImage(named: "edit")!
        edit.image?.withAlignmentRectInsets(.zero)
        delete.image = UIImage(named: "trash")!
        delete.image?.withAlignmentRectInsets(.zero)
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete, edit])
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        return swipeActionConfig
    }
    
    
    // Delete task from database
    func removeTask(indexNumber: Int){
        self.showProgressView(views: self.view)
        self.taskViewModel.removeTask(indexNumber: indexNumber)
    }
}
