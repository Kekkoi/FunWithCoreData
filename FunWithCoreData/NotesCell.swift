//
//  NotesCell.swift
//  FunWithCoreData
//
//  Created by Miklos Kekkoi on 11/7/17.
//  Copyright © 2017 Miklos Kekkoi. All rights reserved.
//

import UIKit

class NotesCell: UITableViewCell {

    var notes: UserNote? {
        didSet {
            notesLabel.text = notes?.noteText

            if let dateAdded = notes?.addedDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy MMM dd hh:mm"
                let formatedDate = dateFormatter.string(from: dateAdded)
                notesDateLabel.text = formatedDate
            }

        }
    }

        
    let notesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let notesDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.customRed
        
        addSubview(notesLabel)
        addSubview(notesDateLabel)
        
        notesLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        notesLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        notesLabel.rightAnchor.constraint(equalTo: notesDateLabel.leftAnchor).isActive = true
        notesLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
        notesDateLabel.leftAnchor.constraint(equalTo: notesLabel.rightAnchor, constant: 8).isActive = true
        notesDateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        notesDateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        notesDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        notesDateLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
