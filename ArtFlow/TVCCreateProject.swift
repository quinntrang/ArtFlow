//
//  VCCreateProject.swift
//  ArtFlow
//
//  Created by Quinn on 4/10/21.
//

import UIKit
import RPTTextView
import CoreData

protocol TVCCreateProjectDelegate {
    func create(project:Project, completed:Bool, isCurrent:Bool)
}

class TVCCreateProject : AFTVCMain {
    var delegate:TVCCreateProjectDelegate?
    @IBOutlet var tfTitle: UITextField!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var rtvDescription: UITextView!
    var isCurrentProject : Bool = true
    var project:Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveButton.isEnabled = false
        
        if self.project == nil {
            self.project = Project(context: AFDataSupport.sharedInstance.context!)
        }
        
        //
        self.tfTitle.delegate = self
        
        rtvDescription.textContainerInset = UIEdgeInsets(top: 16, left: 8, bottom: 12, right: 8)

    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        self.project.title = self.tfTitle.text
        self.project.detail = self.rtvDescription.text
        self.delegate?.create(project: self.project, completed: AFDataSupport.sharedInstance.contextSave(), isCurrent: isCurrentProject)
    }
    
}

//MARK:-
extension TVCCreateProject : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        self.project.title = newText
        if let t = project.title, t.count > 0 {
            self.saveButton.isEnabled = true
        }else {
            self.saveButton.isEnabled = false
        }
        return true
    }
}


//UITable Delegate and Data Sources
extension TVCCreateProject {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = super.tableView(tableView, cellForRowAt:indexPath)
        if indexPath.section == 0 && indexPath.row == 1 {
            c.tintColor = (isCurrentProject) ? #colorLiteral(red: 0.7450980392, green: 0.662745098, blue: 1, alpha: 1) : #colorLiteral(red: 0.9057930112, green: 0.905945003, blue: 0.9057729244, alpha: 1)
        }
        return c
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            isCurrentProject = !isCurrentProject
            let c = tableView.cellForRow(at: indexPath)
            c?.tintColor = (isCurrentProject) ?#colorLiteral(red: 0.7450980392, green: 0.662745098, blue: 1, alpha: 1) : #colorLiteral(red: 0.9057930112, green: 0.905945003, blue: 0.9057729244, alpha: 1)
        }
    }
}


//
class TVCEditProject : TVCCreateProject {
    //var isCurrentProject : Bool = true
    override var project:Project! {
        didSet {
            super.project = self.project
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI(project: self.project)
    }
    
    func setupUI(project p:Project) {
        self.tfTitle.text = p.title
        self.rtvDescription.text = p.detail
    }
}
