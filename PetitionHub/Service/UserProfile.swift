//
//  File.swift
//  PetitionHub
//
//  Created by Dmitry on 10.05.2023.
//

import Foundation


class UserProfile {
    private let defaults = UserDefaults.standard
    
    func openAuth() -> Bool {
        !defaults.bool(forKey: "auth")
    }
    
    func readyAuth() {
        defaults.set(true, forKey: "auth")
    }
}
