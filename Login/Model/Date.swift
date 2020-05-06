//
//  Date.swift
//  Talaqah
//
//  Created by Haneen Abdullah on 16/04/2020.
//  Copyright © 2020 Talaqah. All rights reserved.
//

import Foundation

extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd/MM/yyyy"

        return dateFormatter.string(from: Date())

    }
}
