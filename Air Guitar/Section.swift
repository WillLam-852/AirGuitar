//
//  Section.swift
//  AVAudioUnitSamplerFrobs
//
//  Created by Kwok Ching Fung on 3/11/2018.
//  Copyright © 2018 Gene De Lisa. All rights reserved.
//

import Foundation
import RealmSwift

class Section: Object, NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let section = Section(title: title, chordSequence: chordSequence)
        return section
    }
    
    convenience init(title: String, chordSequence: List<Chord>) {
        self.init()
        self.title = title
        self.chordSequence.append(objectsIn: chordSequence)
    }
    
//    @objc dynamic var id = 0
    @objc dynamic var title = ""
    let chordSequence = List<Chord>()
//
//    override class func primaryKey() -> String? {
//        return "id"
//    }
}
