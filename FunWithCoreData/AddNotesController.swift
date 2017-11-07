//
//  AddNotesController.swift
//  FunWithCoreData
//
//  Created by Miklos Kekkoi on 11/7/17.
//  Copyright © 2017 Miklos Kekkoi. All rights reserved.
//

protocol CreateNoteDelegate {
    func didAddNote(note: UserNote)
    func didEditNote(note: UserNote)
}

import UIKit
import CoreData

class AddNotesController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var delegate: CreateNoteDelegate?
    
    var note: UserNote? {
        didSet {
            noteText.text = note?.noteText
            if let imgData = note?.noteImage {
                uploadedImageView.image = UIImage(data: imgData)
            }
            
        }
    }
    
    let noteText: UITextField = {
       let label = UITextField()
        label.placeholder = "Type something"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backgroundView: UIView = {
        let backView = UIView()
        backView.backgroundColor = UIColor.white
        backView.translatesAutoresizingMaskIntoConstraints = false
        return backView
    }()
    
   lazy var uploadedImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "accImage"))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePhotoSelection)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(exitController))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        
        view.backgroundColor = .yellow
        
        setupElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if note != nil {
            navigationItem.title = "Edit Note"
        } else {
            navigationItem.title = "Add a Note"
        }
    }
    
    func setupElements() {
        view.addSubview(backgroundView)
        view.addSubview(noteText)
        view.addSubview(uploadedImageView)
        
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        noteText.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        noteText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        noteText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        noteText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        uploadedImageView.topAnchor.constraint(equalTo: noteText.bottomAnchor, constant: 15).isActive = true
        uploadedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        uploadedImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        uploadedImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    @objc func exitController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveNote() {
        if note == nil {
            createNote()
        } else {
            saveEditedNote()
        }
    }
    
    
    func createNote() {
        guard let noteText = noteText.text, noteText != "" else {return}
        let context =  CoreDataManager.shared.persistentContainer.viewContext
        
        let note = NSEntityDescription.insertNewObject(forEntityName: "UserNote", into: context)
        
        note.setValue(noteText, forKey: "noteText")
        note.setValue(Date(), forKey: "addedDate")
        if let userImage = uploadedImageView.image {
            let imgData = UIImageJPEGRepresentation(userImage, 0.7)
            note.setValue(imgData, forKey: "noteImage")
        }
        
        
        do {
            try context.save()
            dismiss(animated: true, completion: {
                self.delegate?.didAddNote(note: note as! UserNote)
            })
            
        } catch let saveError {
            print("failed to save", saveError)
        }
    }
    
    func saveEditedNote() {
         guard let noteText = noteText.text, noteText != "" else {return}
         let context =  CoreDataManager.shared.persistentContainer.viewContext
        
        note?.noteText = noteText
        note?.addedDate = Date()
        if let userImage = uploadedImageView.image {
            let imgData = UIImageJPEGRepresentation(userImage, 0.7)
            note?.noteImage = imgData
        }
        
        do {
            try context.save()
            dismiss(animated: true, completion: {
                self.delegate?.didEditNote(note: self.note!)
            })
        } catch let error {
            print("Failed to save edit", error)
        }
    }
    
    @objc func handlePhotoSelection() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let originImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            uploadedImageView.image = originImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
}
