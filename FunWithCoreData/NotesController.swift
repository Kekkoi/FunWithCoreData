//
//  NotesController.swift
//  FunWithCoreData
//
//  Created by Miklos Kekkoi on 11/7/17.
//  Copyright © 2017 Miklos Kekkoi. All rights reserved.
//

import UIKit
import CoreData


class NotesController: UITableViewController, CreateNoteDelegate {
 
   
    
    var notes = [UserNote]()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = UIColor.customRed

        navigationItem.title = "Your Notes"
        tableView.backgroundColor = UIColor.yellow
        tableView.separatorColor = .white

        
        tableView.register(NotesCell.self, forCellReuseIdentifier: "cellID")
        
       
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        fetchNotes()
        
    }
    
    func fetchNotes() {
    
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<UserNote>(entityName: "UserNote")
        do {
           let notes = try context.fetch(fetchRequest)
                notes.forEach({ (note) in
                    print(note.noteText ?? "")
            })
            
            self.notes = notes
            self.tableView.reloadData()
            
        } catch let fetchErr {
            print(fetchErr)
        }
  
        
    }
    

    
    @objc func addNote() {
        
        let addNotesController = AddNotesController()
        
        let navController = CustomNavController(rootViewController: addNotesController)
        
        addNotesController.delegate = self
        
        present(navController, animated: true, completion: nil)
        
        
    
    }
    
    func didAddNote(note: UserNote) {
        notes.append(note)
        let newIndexPath =  IndexPath(row: notes.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .middle)
        
    }
    

    func didEditNote(note: UserNote) {
        let row = notes.index(of: note)
        
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
 


}

