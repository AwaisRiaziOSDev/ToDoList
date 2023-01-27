//
//  Connectivity.swift
//  To-Do List
//
//  Created by Awais Malik on 26/01/2023.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
