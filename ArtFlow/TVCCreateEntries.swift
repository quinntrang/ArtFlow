//
//  VCCreateEntries.swift
//  ArtFlow
//
//  Created by Quinn on 4/10/21.
//

import UIKit
import CoreData

protocol TVCCreateEntriesDelegate {
    func create (_ c:TVCCreateEntries, entry: Entry, completed:Bool)
}

class TVCCreateEntries : AFTVCMain{
    var delegate: TVCCreateEntriesDelegate?
    @IBOutlet weak var progressPic: UIImageView!
    @IBOutlet weak var btnSaveEntry: UIBarButtonItem!
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet var tvDescription: UITextView!
    var entry:Entry!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        self.entry = Entry(context: AFDataSupport.sharedInstance.context!)
        self.btnSaveEntry.isEnabled = false
        tvDescription.textContainerInset = UIEdgeInsets(top: 16, left: 8, bottom: 12, right: 8)

    }
    
    @IBAction func captureImage(_ sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = (sender.tag == 0) ? .camera : .photoLibrary
        self.present(pickerController, animated: true) {
        }
    }
    
    @IBAction func btnSaveEntryTapped(_ sender: UIBarButtonItem) {
        self.entry.location = self.tfLocation.text
        self.entry.detail = self.tvDescription.text
        self.entry.createTime = Date()
        self.entry.updateTime = Date()
        self.delegate?.create(self, entry: self.entry, completed: AFDataSupport.sharedInstance.contextSave())
    }
}


extension TVCCreateEntries : UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let i = info[.originalImage] as? UIImage {
            self.progressPic.image = i
            let imageData = i.jpegData(compressionQuality: 1.0)
            self.entry.image = imageData
            self.btnSaveEntry.isEnabled = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
