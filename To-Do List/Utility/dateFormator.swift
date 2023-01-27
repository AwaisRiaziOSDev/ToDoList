//
//  dateFormator.swift
//  To-Do List
//
//  Created by Awais Malik on 26/01/2023.
//

import Foundation
import UIKit

extension Date{
    func formateDate() -> String{
        let formator = DateFormatter()
        formator.dateFormat = "MMM dd,yyyy HH:mm"
        let str = formator.string(from: self)
        return str
    }
}

extension String{
    func formateStringToDate()->Date{
        let formator = DateFormatter()
        formator.dateFormat = "MMM dd,yyyy HH:mm"
        let date = formator.date(from: self) ?? Date()
        return date
    }
}
