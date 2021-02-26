//
//  Preset.swift
//  AVAudioUnitSamplerFrobs
//
//  Created by ios_Training(EEE) on 22/6/2018.
//  Copyright © 2018 Gene De Lisa. All rights reserved.
//

import Foundation
import RealmSwift

class Preset: Object, NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let preset = Preset(chords: chords)
        return preset
    }
    
    convenience init(chords: List<Chord>) {
        self.init()
//        self.id = id
        for chord in chords{
            self.chords.append(chord.copy() as! Chord)
        }
    }
    
//    @objc dynamic var id = 0
    let chords = List<Chord>()
    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
}
