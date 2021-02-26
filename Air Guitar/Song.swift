//
//  Song.swift
//  AVAudioUnitSamplerFrobs
//
//  Created by Kwok Ching Fung on 14/6/2018.
//  Copyright © 2018 Gene De Lisa. All rights reserved.
//

import Foundation
import RealmSwift

class Song: Object {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    
    //e.g.  A->B->C->A->B
    let sectionSequence = List<Section>()
    
    //e.g. A,B,C
    let uniqueSections = List<Section>()
    
    @objc dynamic var preset: Preset?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
