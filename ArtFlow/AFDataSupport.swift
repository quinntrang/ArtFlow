//
//  AFDataSupport.swift
//  ArtFlow
//
//  Created by Quinn on 4/11/21.
//

import UIKit
import CoreData


class AFDataSupport {
    typealias CDSaveResponse = (Bool, String?, NSManagedObject?) -> Void
    static var sharedInstance = AFDataSupport()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var me:User!
    
    init() {
        //self.me = user
    }
    
    func deleteContext(_ c:Any) {
        context?.delete(c as! NSManagedObject)
        _ = self.contextSave()
    }
    
    //
    typealias CDFetchResponse = (Bool, String?, [NSManagedObject]?) -> Void
    func fetch (entity:String,
                where clause:String? = nil,
                limit:Int? = nil,
                orderBy columnNames:[String]? = nil,
                ascending : Bool = false,
                complition: @escaping CDFetchResponse) {
        print("\nFetch Request For:", entity, "\nwhere =",  clause ?? "", "\nlimit = ", limit ?? "", "\ncolumnNames =", columnNames ?? "_None", "ascending = ", ascending)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        
        if let c = clause {
            fetchRequest.predicate = NSPredicate(format: c)
        }
        
        if let l = limit {
            fetchRequest.fetchLimit = l
        }
        
        if let cns = columnNames {
            for cn in cns {
                let sd = NSSortDescriptor(key:cn, ascending: ascending)
                fetchRequest.sortDescriptors = [sd]
            }
        }
        
        do {
            let m = try context?.fetch(fetchRequest)
            complition(true, "Success", m)
        } catch let e {
            complition(true, e.localizedDescription, nil)
        }
    }
    
    func contextSave() -> Bool {
        do {
            try context?.save()
            return true
        } catch let e {
            print("Date Save Error:", e, e.localizedDescription)
            return false
        }
    }
}


//MARK:_ User
extension AFDataSupport {
    func loadUsers() -> [User] {
        var users : [User] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        do {
            users = try context?.fetch(fetchRequest) as! [User]
        }catch {
            print("Failed!")
        }
        return users
    }
    
    func currentUser() -> User? {
        self.loadUsers().first
    }
}


//MARK:_ Project
extension AFDataSupport {
    func loadProjects() -> [Project] {
        var projects : [Project] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Project")
        do {
            projects = try context?.fetch(fetchRequest) as! [Project]
        }catch {
            print("Failed!")
        }
        return projects
    }
}
