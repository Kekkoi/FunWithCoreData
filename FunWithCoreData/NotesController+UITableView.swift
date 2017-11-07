//
//  NotesController+UITableView.swift
//  FunWithCoreData
//
//  Created by Miklos Kekkoi on 11/7/17.
//  Copyright © 2017 Miklos Kekkoi. All rights reserved.
//

import UIKit

extension NotesController {
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! NotesCell
        let note = notes[indexPath.row]
        cell.notes = note
        cell.backgroundColor = UIColor.customRed
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteRowFunc)
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editRowFunc)
        
        editAction.backgroundColor = .customBlue
        return [deleteAction, editAction]
    }
    
    func deleteRowFunc(action: UITableViewRowAction, indexPath: IndexPath) {
        let noteToBeDeleted = self.notes[indexPath.row]
        
        self.notes.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .middle)
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        context.delete(noteToBeDeleted)
        
        do {
            try context.save()
        } catch let err {
            print("Failed to delete", err)
        }
    }
    
    
    func editRowFunc(action: UITableViewRowAction, indexPath: IndexPath) {
        let editNoteController = AddNotesController()
        editNoteController.delegate = self
        editNoteController.note = notes[indexPath.row]
        let navController = CustomNavController(rootViewController: editNoteController)
        present(navController, animated: true)
    }
    
    
    
}
