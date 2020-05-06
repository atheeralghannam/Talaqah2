//
//  TableCell.swift
//  Talaqah
//
//  Created by Atheer Alghannam on 07/07/1441 AH.
//  Copyright © 1441 Talaqah. All rights reserved.
//

import Foundation
import UIKit

class TableCell: UITableViewCell {

    @IBOutlet weak var profile: UIButton!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var idLabel: UILabel!
//    @IBOutlet private var thumbnailImageView: UIImageView!

    @IBOutlet weak var Progress: UIButton!
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        idLabel.text = nil
        gender.image = nil
//        thumbnailImageView.image = nil
    }

    // MARK: Cell Configuration

    func configurateTheCell(_ patient : Patient) {
        let name = patient.FirstName+" "+patient.LastName
        
        nameLabel.text = name
        idLabel.text = "رقم هوية/إقامة المريض: " + patient.NID
        if patient.Gender == "female"{
            gender.image = #imageLiteral(resourceName: "female")
        }else {
            gender.image = #imageLiteral(resourceName: "male")
        }
    nameLabel.font = UIFont(name: "jf flat", size: 15.0)
     idLabel.font = UIFont(name: "jf flat", size: 13.0)
        
    }

}
