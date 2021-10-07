//
//  VCHome.swift
//  ArtFlow
//
//  Created by Quinn on 4/10/21.
//

import UIKit

class VCHome : AFVCMain {
    @IBOutlet var btnCreateNewProject: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnNewEntry: UIButton?
    
    var user : User! {
        didSet {
            self.setupTableView(user: self.user)
        }
    }
    let dataSupport = AFDataSupport.sharedInstance
    var project : Project?
    var entries : [Entry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register cell
        self.tableView.register(UINib(nibName: "TVCellStage", bundle: .main), forCellReuseIdentifier: "ci_TVCellStage")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //..
        self.updateUser()
    }
    
    func updateUser() {
        if let u = dataSupport.currentUser() {
            self.user = u
        }else{
            self.performSegue(withIdentifier: "si_homeToUser", sender: nil)
        }
    }
    
    func update(project:Project, isCurrent:Bool) {
        if self.user != nil && (self.user.currentProject == nil || isCurrent == true) {
            self.user.currentProject = project
        }
        
        self.project = project
        
        //..
        self.setupTableView(project: self.project)
    }
}

//MARK:- Navigation
extension VCHome {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "si_homeToCreateProject":
            let d = segue.destination as! TVCCreateProject
            d.delegate = self
            break
        case "si_homeToUser":
            let d = segue.destination as! TVCUser
            d.delegate = self
            break
        case "si_homeToNewEntry":
            let d = segue.destination as! TVCCreateEntries
            d.delegate = self
            break
        case "si_homeToProjectList":
            let d = (segue.destination as! UINavigationController).viewControllers.first as! TVCProjectList
            //let d = segue.destination as! TVCProjectList
            
            d.delegate = self
            break
            
        default:
            break
        }
    }
}


extension VCHome  : TVCCreateProjectDelegate {
    func create(project:Project, completed:Bool, isCurrent:Bool) {
        //print("Project", project.title, project.detail)
        if completed == true {
            self.navigationController?.popViewController(animated: true)
            self.update(project: project, isCurrent:isCurrent)
        }else{
            //
        }
    }
}

extension VCHome : TVCUserDelegate {
    func created(_ c:TVCUser, user:User, created:Bool) {
        if created {
            c.dismiss(animated: true) {
                self.user = user
            }
        }
    }
}


//populate data
extension VCHome : UITableViewDelegate, UITableViewDataSource {
    func setupTableView(user:User) {
        self.project = self.user.currentProject
        self.navigationItem.title = "\(self.project?.title! ?? "Hi \(self.user.firstName ?? "")!")"
        self.setupTableView(project: self.project)
    }
    
    func setupTableView(project:Project?) {
        guard let p = project else {return}
        self.navigationItem.title = p.title
        self.tableView.delegate = self
        self.tableView.dataSource = self

        if let ds = p.entries, let d = Array(ds) as? [Entry] {
            self.entries = d
        }
        self.tableView.isHidden = false
        self.btnNewEntry?.isHidden = false
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return self.project?.numberOfLine() ?? 0
//        }
        
        return self.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            var cell : UITableViewCell!
//            if let c = tableView.dequeueReusableCell(withIdentifier: "ci_projectCell") {
//                cell = c
//            }else{
//                cell = UITableViewCell(style: .default, reuseIdentifier: "ci_projectCell")
//            }
//
//            cell.textLabel?.text = (indexPath.row == 0) ? self.project?.title : self.project?.detail
//            return cell
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ci_TVCellStage") as! TVCellStage
        cell.entry = self.entries[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if entries.count == 0 {
            let l = UILabel()
            l.text = "No entry yet. Add your first entry to this project! You can only improve on what already exists. :)"
            l.numberOfLines = 2
            l.textAlignment = .center
            
            l.textColor = #colorLiteral(red: 0.4737139344, green: 0.4709020853, blue: 0.4758780599, alpha: 1)
            return  l
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (entries.count > 0) ? 0 : 240
    }
}


extension VCHome : TVCCreateEntriesDelegate {
    func create (_ c:TVCCreateEntries, entry: Entry, completed:Bool) {
        if completed == true {
            entry.project = self.project
            self.project?.entries = self.project?.entries?.adding(entry) as NSSet?
            _ = AFDataSupport.sharedInstance.contextSave()

            self.entries.insert(entry, at: 0)
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:-
extension Project {
    func numberOfLine() -> Int {
        return (self.detail != nil) ? 2 : 1
    }
}


extension VCHome : TVCProjectListProtocol {
    func projectList(_ p:TVCProjectList, selected project:Project){
        self.entries.removeAll()
        self.updateUser()
    }
}

extension VCHome : TVCellStageDelegate {
    func cell(_ cell:TVCellStage, delete entry:Entry) {
        let ac = UIAlertController(title: "Delete Entry?", message: "This is irreversible action and deleted entry can not be rolled back.", preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (a) in
            if let index = self.entries.firstIndex(of: entry) {
                self.dataSupport.deleteContext(entry)
                self.entries.remove(at: index)
                self.tableView.reloadData()
            }
        }
        ac.addAction(delete)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel ) { (a) in
        }
        ac.addAction(cancel)
        self.present(ac, animated: true, completion: nil)
    }
}
