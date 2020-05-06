//
//  UIView+Ext.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 27/04/2020.
//  Copyright © 2020 Talaqah All rights reserved.
//

import UIKit

extension UIView {
    func pin( to superview: UIView){
        translatesAutoresizingMaskIntoConstraints                             = false
        topAnchor.constraint(equalTo: superview.topAnchor).isActive           = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive   = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive     = true
    }
}
