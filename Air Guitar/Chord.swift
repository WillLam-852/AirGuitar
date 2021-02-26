//
//  Chord.swift
//  AVAudioUnitSamplerFrobs
//
//  Created by Kwok Ching Fung on 14/6/2018.
//  Copyright © 2018 Gene De Lisa. All rights reserved.
//

import Foundation
import RealmSwift

class Chord:Object, NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let chord = Chord(baseTriadBass: baseTriadBass, chordType: chordType, ext: ext, bass: bass)
        return chord
    }
    
    @objc dynamic var baseTriadBass: String = ""
    @objc dynamic var chordType: String = ""
    @objc dynamic var ext: String = ""
    @objc dynamic var bass: String = ""
    
    convenience init(baseTriadBass: String, chordType: String, ext: String, bass: String) {
        self.init()
        self.baseTriadBass = baseTriadBass
        self.chordType = chordType
        self.ext = ext
        self.bass = bass
    }
    
    func toString()->NSMutableAttributedString!{
        let font:UIFont? = UIFont(name: "Helvetica", size:15)
        let fontSuper:UIFont? = UIFont(name: "Helvetica", size:12)
        var text = ""
        var attString:NSMutableAttributedString = NSMutableAttributedString(string: "", attributes: [.font:font!])

        var baseTriadBass = self.baseTriadBass
        var chordType = self.chordType
        var ext = self.ext
        var bass = self.bass
        
        baseTriadBass = baseTriadBass.components(separatedBy: "/")[0]
        
        if chordType == "Maj"{
            chordType = ""
        }
        if ext == "None"{
            ext = ""
        }
        if bass == "None"{
            bass = ""
        }
        else {
            bass = bass.components(separatedBy: "/")[0]
            bass = "/" + bass
        }
        text = baseTriadBass + chordType + ext + bass
        attString = NSMutableAttributedString(string: text, attributes: [.font:font!])
        
        attString.setAttributes([.font:fontSuper!,.baselineOffset:10], range: NSRange(location:(baseTriadBass + chordType).count,length:ext.count))
        
        return attString
    }
}
