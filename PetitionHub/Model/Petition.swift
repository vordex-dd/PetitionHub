//
//  Petition.swift
//  PetitionHub
//
//  Created by Dmitry on 11.05.2023.
//

import Foundation


struct Petition {
    let title: String
    let count: Int = 0
}

class Petitions {
    var all: [Petition] {
        [Petition(title: "aboba")]
    }
}
