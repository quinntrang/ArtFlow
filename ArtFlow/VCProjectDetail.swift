//
//  VCPjecjectDetail.swift
//  ArtFlow
//
//  Created by Quinn on 02/05/21.
//

import UIKit

protocol VCProjectDetailDelegate {
    func project(_ p:Project, deletedIn : VCProjectDetail)
    func project(_ p:Project, madeCurrent : Bool, inController c : VCProjectDetail)
}

class VCProjectDetail : VCHome {
    override var project : Project! {
        didSet {
            super.project = project
        }
    }
    var delegate : VCProjectDetailDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        
        self.setupTableView(project: self.project)
    }

    @IBAction func actionButtonTouched(_ sender: Any) {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let makeCurrent = UIAlertAction(title: "Set Current Project", style: .default) { (a) in
            self.setCurrentProject()
        }
        ac.addAction(makeCurrent)
        
        let edit = UIAlertAction(title: "Edit Project", style: .default) { (a) in
            self.performSegue(withIdentifier: "si_projectDetailToEdit", sender: nil)
        }
        ac.addAction(edit)

        let delete = UIAlertAction(title: "Delete Project", style: .destructive) { (a) in
            self.deleteProject()
        }
        ac.addAction(delete)
        
        
        let cancel = UIAlertAction(title: "Cancle", style: .cancel) { (a) in
            
        }
        ac.addAction(cancel)
        
        self.present(ac, animated: true, completion: nil)
    }
    
    func setCurrentProject() {
        delegate?.project(self.project, madeCurrent : true, inController : self)
    }
    
    func deleteProject() {
        delegate?.project(self.project, deletedIn: self)
    }
}


extension VCProjectDetail {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TVCEditProject
        vc.project = self.project
        vc.delegate = self
    }
}
