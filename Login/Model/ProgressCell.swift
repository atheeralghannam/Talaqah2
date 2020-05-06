//
//  TableCell.swift
//  Talaqah
//
//  Created by Haneen Abdullah on 26/03/2020.
//  Copyright © 1441 Talaqah. All rights reserved.
//

import Foundation
import UIKit

class ProgressCell: UITableViewCell {

    
    @IBOutlet private var answerLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
   @IBOutlet private var resultImageView: UIImageView!

    
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        answerLabel.text = nil
        dateLabel.text = nil
        resultImageView.image = nil
    }

    // MARK: Cell Configuration

    func configurateCell(_ progress : Progress) {

        answerLabel.text = progress.answer
        dateLabel.text = progress.date
        
        if (progress.result == "f"){
            if #available(iOS 13.0, *) {
                resultImageView.image = UIImage(systemName: "xmark.circle.fill")
                       resultImageView.image = resultImageView.image?.withRenderingMode(.alwaysTemplate)
                            resultImageView.tintColor = UIColor.red
                //            resultImageView.setTintColor(UIColor.red)
            }

        }
        else{
            if #available(iOS 13.0, *) {
                resultImageView.image = UIImage(systemName:"checkmark.circle.fill")
                resultImageView.image = resultImageView.image?.withRenderingMode(.alwaysTemplate)
//                resultImageView.tintColor = UIColor.green
                resultImageView.tintColor = Utilities.greenColor

            }

        }
    }

}
