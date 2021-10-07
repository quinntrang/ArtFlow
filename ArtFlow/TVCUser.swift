//
//  TVCUser.swift
//  ArtFlow
//
//  Created by Quinn on 4/11/21.
//

import UIKit

protocol TVCUserDelegate {
    func created(_ c:TVCUser, user:User, created:Bool)
}

class TVCUser : AFTVCMain {
    var delegate:TVCUserDelegate?
    @IBOutlet var tfFirstName: UITextField!
    @IBOutlet var tfLastName: UITextField!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = User(context: AFDataSupport.sharedInstance.context!)
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        self.user.firstName = self.tfFirstName.text
        self.user.lastName = self.tfLastName.text
        
        self.delegate?.created(self, user: self.user, created: AFDataSupport.sharedInstance.contextSave())
    }
}

extension TVCUser : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let finalText = textField.text
        
        switch textField.tag {
        case 0://first name
            self.saveButton.isEnabled = (finalText?.count ?? 0 > 0)
        break
        
        case 1://last name
        break

        default:break
        }
        
        return true
    }
}


