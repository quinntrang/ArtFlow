//
//  VCProjectList.swift
//  ArtFlow
//
//  Created by Quinn on 4/10/21.
//

import UIKit


class ProjectCell : UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var entryImage: UIImageView!
    
}

protocol TVCProjectListProtocol {
    func projectList(_ p:TVCProjectList, selected project:Project)
}

class TVCProjectList : UITableViewController {
    var delegate : TVCProjectListProtocol?
    var projects : [Project] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.projects = AFDataSupport.sharedInstance.loadProjects()
        self.user = AFDataSupport.sharedInstance.currentUser()
        self.navigationItem.title = "Project List"
    }
    @IBAction func closeButtonTocuhed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension TVCProjectList {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ci_projectCell") as? ProjectCell
        
        let p = projects[indexPath.row]
        cell?.titleLabel.text = p.title
        if let e = p.entries?.allObjects.first as? Entry {
            cell?.entryImage.image = UIImage(data: e.image!)
        }
        
//        cell?.textLabel?.text = p.title
//        cell?.detailTextLabel?.text = p.detail
//        if let cp = self.user.currentProject, p == cp {
//            cell?.accessoryType = .checkmark
//        }else{
//            cell?.accessoryType = .none
//        }
        
        return cell!
    }
    
//    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return "Tap on cell to make it your current project!"
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let p = self.projects[indexPath.row]
        self.performSegue(withIdentifier: "si_projectListToDeatail", sender: p)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 254
    }
}

extension TVCProjectList {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! VCProjectDetail
        vc.project = sender as? Project
        vc.delegate = self
    }
}

extension TVCProjectList : VCProjectDetailDelegate {
    func project(_ p:Project, deletedIn : VCProjectDetail) {
        if let index = self.projects.firstIndex(of: p) {
            self.navigationController?.popViewController(animated: true)
            AFDataSupport.sharedInstance.deleteContext(p)
            self.projects.remove(at: index)
            self.tableView.reloadData()
        }
    }
    
    func project(_ p:Project, madeCurrent : Bool, inController c : VCProjectDetail) {
        self.navigationController?.popViewController(animated: true)

        self.user.currentProject = p
        self.tableView.reloadData()
        self.delegate?.projectList(self, selected:p)
    }
}
