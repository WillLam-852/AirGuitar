//
//  Guitar.swift
//  AVAudioUnitSamplerFrobs
//
//  Created by Kwok Ching Fung on 26/2/2019.
//  Copyright © 2019 Gene De Lisa. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class Guitar: StringMotion_Parent {
        
    static let sharedInstance = Guitar()

    var sampler: Sampler!
    var sampler2: Sampler!
    
    var moDetect: StringMotion_Sensor!
    
    var velocity : UInt8 = 0
    
    var motionManager = CMMotionManager()
    var motionOutput = "none"
    var motionCounter = 0
    var rate = 100.0
    
    var yaw : Double = 0.0
    var pitch : Double = 0.0
    var roll : Double = 0.0
    
    var yawOffset : Double = 0.0
    var pitchOffset : Double = 0.0
    var rollOffset : Double = 0.0
    
    var yawCalibrated : Double = 0.0
    var pitchCalibrated : Double = 0.0
    var rollCalibrated : Double = 0.0
    
    var lastRoll : Double = 0.0
    var count : Int = 0
    
    var angularAccelY : Double = 0.0
    
    var maxAngularAccelY : Double = 0.0
    
    let string1 = "STRING1"
    let string2 = "STRING2"
    let string3 = "STRING3"
    let string4 = "STRING4"
    let string5 = "STRING5"
    let string6 = "STRING6"
    var strings: [String]!
    
    var string1Up : Bool = false
    var string2Up : Bool = false
    var string3Up : Bool = false
    var string4Up : Bool = false
    var string5Up : Bool = false
    var string6Up : Bool = false
    
    var baseTriadBass: UInt8!
    var chordType: String!
    var ext: String!
    var bass : String!
    var bassInput : UInt8!
    
    var StringOffsets : [String: UInt8]!
    var majorStringOffsets : [String: UInt8]!
    var minorStringOffsets : [String: UInt8]!
    var diminishedStringOffsets : [String: UInt8]!
    var augmentedStringOffsets : [String: UInt8]!
    var suspended2ndStringOffsets : [String: UInt8]!
    var suspended4thStringOffsets : [String: UInt8]!
    var fifthStringOffsets : [String: UInt8]!
    
    var positiveExtensionOffsets : [String: UInt8]!
    var negativeExtensionOffsets : [String: UInt8]!
    var noneExtensionOffsets : [String: UInt8]!
    var sixthExtensionOffsets : [String: UInt8]!
    var seventhExtensionOffsets : [String: UInt8]!
    var majorseventhExtensionOffsets : [String: UInt8]!
    var addninthExtensionOffsets : [String: UInt8]!
    var partialExtensionOffsets : [String: UInt8]!
    var eleventhExtensionOffsets : [String: UInt8]!
    var thirtenthExtensionOffsets : [String: UInt8]!
    
    var bassNotes : [String: UInt8]!
    
    var currentChordNotes: [String: UInt8]!
    var previousChordNotes: [String: UInt8]!
    var newChordForString: [String: Bool]!
    
    var enableMute : Bool = false
    var enableUpStroke : Bool = true
    var enablePluck : Bool = false

    private init(){
        strings = [string1, string2, string3, string4, string5, string6]

        sampler = Sampler()
        sampler2 = Sampler()
        
        moDetect = StringMotion_Sensor(self)
        
        bassNotes = ["E": 40,
                     "F": 41,
                     "F#/Gb": 42,
                     "G": 43,
                     "G#/Ab": 44,
                     "A": 45,
                     "A#/Bb": 46,
                     "B": 47,
                     "C": 48,
                     "C#/Db": 49,
                     "D": 50,
                     "D#/Eb": 51,
        ]
        
        majorStringOffsets = [string1: 24,
                              string2: 19,
                              string3: 16,
                              string4: 12,
                              string5: 7,
                              string6: 0
        ]
        
        minorStringOffsets = [string1: 24,
                              string2: 19,
                              string3: 15,
                              string4: 12,
                              string5: 7,
                              string6: 0
        ]
        
        diminishedStringOffsets = [string1: 24,
                                   string2: 18,
                                   string3: 15,
                                   string4: 12,
                                   string5: 6,
                                   string6: 0
        ]
        
        augmentedStringOffsets = [string1: 24,
                                  string2: 20,
                                  string3: 16,
                                  string4: 12,
                                  string5: 8,
                                  string6: 0
        ]
        
        suspended2ndStringOffsets = [string1: 24,
                                     string2: 19,
                                     string3: 14,
                                     string4: 12,
                                     string5: 7,
                                     string6: 0
        ]
        
        suspended4thStringOffsets = [string1: 24,
                                     string2: 19,
                                     string3: 17,
                                     string4: 12,
                                     string5: 7,
                                     string6: 0
        ]
        
        fifthStringOffsets = [string1: 24,
                              string2: 19,
                              string3: 19,
                              string4: 12,
                              string5: 7,
                              string6: 0
        ]
        
        StringOffsets = majorStringOffsets
        
        
        
        noneExtensionOffsets = [string1: 0,
                                string2: 0,
                                string3: 0,
                                string4: 0,
                                string5: 0,
                                string6: 0
        ]
        
        sixthExtensionOffsets = [string1: 3,
                                 string2: 0,
                                 string3: 0,
                                 string4: 3,
                                 string5: 0,
                                 string6: 0
        ]
        
        seventhExtensionOffsets = [string1: 2,
                                   string2: 0,
                                   string3: 0,
                                   string4: 2,
                                   string5: 0,
                                   string6: 0
        ]
        
        majorseventhExtensionOffsets = [string1: 1,
                                        string2: 0,
                                        string3: 0,
                                        string4: 1,
                                        string5: 0,
                                        string6: 0
        ]
        
        addninthExtensionOffsets = [string1: 2,
                                    string2: 0,
                                    string3: 0,
                                    string4: 0,
                                    string5: 0,
                                    string6: 0
        ]
        
        partialExtensionOffsets = [string1: 0,
                                   string2: 0,
                                   string3: 0,
                                   string4: 2,
                                   string5: 0,
                                   string6: 0
        ]
        
        eleventhExtensionOffsets = [string1: 5,
                                    string2: 0,
                                    string3: 0,
                                    string4: 0,
                                    string5: 0,
                                    string6: 0
        ]
        
        thirtenthExtensionOffsets = [string1: 3,
                                     string2: 0,
                                     string3: 0,
                                     string4: 2,
                                     string5: 0,
                                     string6: 0
        ]
        
        positiveExtensionOffsets = noneExtensionOffsets
        negativeExtensionOffsets = noneExtensionOffsets
        
        baseTriadBass = bassNotes["E"]
        chordType = "Maj"
        ext = "None"
        bass = "None"
        bassInput = baseTriadBass
        
        currentChordNotes = [
            string1: 0,
            string2: 0,
            string3: 0,
            string4: 0,
            string5: 0,
            string6: 0
        ]
        previousChordNotes = currentChordNotes
        
        newChordForString = [
            string1: false,
            string2: false,
            string3: false,
            string4: false,
            string5: false,
            string6: false
        ]
    }
    
    func play(){
        moDetect.motionDetectloop()  //new
        
        //daniel's strum
        motionManager.gyroUpdateInterval = (1.0/rate)
        motionManager.accelerometerUpdateInterval = (1.0/rate)
        
        motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
            if data != nil {
                self.motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
                    if let myAttData = data {
                        self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                            if let myAccelData = data {
                                
                                self.yaw = myAttData.attitude.yaw*(180.0/Double.pi)
                                self.pitch = myAttData.attitude.pitch*(180.0/Double.pi)
                                self.roll = myAttData.attitude.roll*(180.0/Double.pi)
                                
                                self.rollCalibrated = self.roll - self.rollOffset
                                self.yawCalibrated = -(self.yaw - self.yawOffset)
                                
                                if ( myAccelData.acceleration.z - myAttData.userAcceleration.z ) < 0 {
                                    self.rollCalibrated = self.rollCalibrated - 180
                                }
                                
                                self.processAngle(angleAddress: &self.rollCalibrated, flipSign: true)
                                self.processAngle(angleAddress: &self.yawCalibrated, flipSign: false)
                                
                                self.velocity = UInt8(min(30, abs(self.moDetect.gyroY) )*127/30)
                                
                                
                                let upStrokeCheck = !(self.moDetect.gyroY > 0 && !self.enableUpStroke)
                                let phaseCheck_upwards  =  ( self.moDetect.gyroY > 0 && !(self.moDetect.stateMachine_Core_GyroY_Phase == "D" && self.moDetect.stateMachine_Core_GyroY_Direction == "1") )
                                let phaseCheck_downwards = ( self.moDetect.gyroY < 0 && !(self.moDetect.stateMachine_Core_GyroY_Phase == "D" && self.moDetect.stateMachine_Core_GyroY_Direction == "2") )
                                let pluckCheck_Gyro = self.moDetect.gyroYAccelMax > 250 && self.moDetect.gyroYAccelMax < 400 && self.moDetect.stateMachine_Core_GyroY_Phase == "B"
                                
                                var stringPluck:String!
                                var stringStrum:String!
                                
                                //                                print(self.velocity)
                                //                                print( min(30, self.moDetect.gyroYAccelMax*0.1)*127/30 )
                                
                                let diff = self.moDetect.stateMachine_Core_GyroY_StartAngle - self.moDetect.x3/Float.pi*180
                                let vel = self.moDetect.gyroYMax
                                let acc = self.moDetect.gyroYAccelMax
                                
                                let vel2 = self.moDetect.gyroY
                                let acc2 = self.moDetect.gyroYAccel
                                
                                let ratio = vel!/abs(diff)
                                let ratio2 = acc!/(vel!*abs(diff))
                                
                                
                                
                                if upStrokeCheck && ( phaseCheck_upwards || phaseCheck_downwards ) {
                                    
                                    if self.bindAngleStringUp(angle: 25, stringUp: &self.string1Up, string: self.string1, velocity: self.velocity, play: false) { stringStrum = self.string1 }
                                    else if self.bindAngleStringUp(angle: 15, stringUp: &self.string2Up, string: self.string2, velocity: self.velocity, play: false) { stringStrum = self.string2 }
                                    else if self.bindAngleStringUp(angle: 5, stringUp: &self.string3Up, string: self.string3, velocity: self.velocity, play: false) { stringStrum = self.string3 }
                                    else if self.bindAngleStringUp(angle: -5, stringUp: &self.string4Up, string: self.string4, velocity: self.velocity, play: false) { stringStrum = self.string4 }
                                    else if self.bindAngleStringUp(angle: -15, stringUp: &self.string5Up, string: self.string5, velocity: self.velocity, play: false) { stringStrum = self.string5 }
                                    else if self.bindAngleStringUp(angle: -25, stringUp: &self.string6Up, string: self.string6, velocity: self.velocity, play: false) { stringStrum = self.string6 }
                                    if stringStrum != nil {
                                        self.motionCounter += 1
                                        self.motionOutput = "strum"
                                    }
                                    else{
                                        if pluckCheck_Gyro && self.motionOutput == "none" {
                                            
                                            self.motionOutput = "pluck"
                                            
                                            let difference = abs( self.moDetect.stateMachine_Core_GyroY_StartAngle - self.moDetect.x3/Float.pi*180 )
                                            let adjustedRoll:Double!
                                            
                                            if self.moDetect.gyroY < 0 {
                                                adjustedRoll = self.rollCalibrated + Double(difference/2)
                                            }
                                            else {
                                                adjustedRoll = self.rollCalibrated - Double(difference/2)
                                            }
                                            
                                            if adjustedRoll > 20 {
                                                stringPluck = self.string1
                                            }else if adjustedRoll > 10 {
                                                stringPluck = self.string2
                                            }else if adjustedRoll > 0 {
                                                stringPluck = self.string3
                                            }else if adjustedRoll > -10 {
                                                stringPluck = self.string4
                                            }else if adjustedRoll > -20 {
                                                stringPluck = self.string5
                                            }else {
                                                stringPluck = self.string6
                                            }
                                            
                                        }
                                        else if self.moDetect.stateMachine_Core_GyroY_Phase == "0" {
                                            self.motionCounter = 0
                                            self.motionOutput = "none"
                                        }
                                    }
                                }
                                
                                let rationalMotionCheck = ratio2 < 10 && abs(diff) <= 15 &&
                                    ( ( Float(vel2!) > Float(0) && Float(acc2!) > Float(0) && diff > 0 ) ||
                                        ( Float(vel2!) < Float(0) && Float(acc2!) < Float(0) && diff < 0 ) )
                                
                                if stringPluck != nil && self.enablePluck && rationalMotionCheck
                                    && self.motionCounter < 1 && self.motionOutput == "pluck" {
                                    //                                    print("pluck main")
                                    //                                    print(diff,"  ",vel, "  ",ratio,"  ",acc,"  " ,ratio2,"  ", vel2, "   ", acc2)
                                    
                                    self.playString2(string: stringPluck, velocity: UInt8(min(30, self.moDetect.gyroYAccelMax*0.05)*127/30) )
                                }
                                else if stringStrum != nil && stringStrum != stringPluck {
                                    //                                if stringStrum != nil && stringStrum != stringPluck {
                                    if self.motionCounter == 1 && self.enablePluck {
                                        //                                        print(self.MoDetect.gyroYAccelMax,"  ",self.velocity,
                                        //                                              "  ",diff,"  ", abs(self.MoDetect.gyroYAccel - self.MoDetect.gyroYAccelMax),"  ",
                                        //                                              abs(self.MoDetect.gyroY - self.MoDetect.gyroYMax))
                                        //self.playString(string: stringStrum, velocity: self.velocity)
                                        let pluckCheck = UInt8(min(30, self.moDetect.gyroYAccelMax*0.1)*127/30) > self.velocity
                                            && self.moDetect.gyroYAccelMax > 200 //&& self.MoDetect.gyroYAccelMax < 400
                                            && self.moDetect.stateMachine_Core_GyroY_Phase == "B"
                                            && abs(diff) < 30 && self.velocity < 75
                                            && abs(self.moDetect.gyroYAccel - self.moDetect.gyroYAccelMax) < 650
                                            && abs(self.moDetect.gyroY - self.moDetect.gyroYMax) < 30
                                            && abs(self.moDetect.gyroY - self.moDetect.gyroYMax) != 0
                                        if pluckCheck  {
                                            //                                            print("pluck")
                                            self.playString2(string: stringStrum, velocity: UInt8(min(30, self.moDetect.gyroYAccelMax*0.05)*127/30) )
                                        }
                                        else {
                                            self.playString(string: stringStrum, velocity: self.velocity )
                                        }
                                        
                                    }
                                    else{
                                        self.playString(string: stringStrum, velocity: self.velocity)
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    func switchChord(chord: Chord){
        newChordForString = [
            string1: true,
            string2: true,
            string3: true,
            string4: true,
            string5: true,
            string6: true
        ]
            
        baseTriadBass = bassNotes[chord.baseTriadBass]
        chordType = chord.chordType
        ext = chord.ext
        bass = chord.bass
        
        if chordType == "Maj" {
            StringOffsets = majorStringOffsets
        }
        else if chordType == "Min" {
            StringOffsets = minorStringOffsets
        }
        else if chordType == "Dim" {
            StringOffsets = diminishedStringOffsets
        }
        else if chordType == "Aug" {
            StringOffsets = augmentedStringOffsets
        }
        else if chordType == "Sus2" {
            StringOffsets = suspended2ndStringOffsets
        }
        else if chordType == "Sus4" {
            StringOffsets = suspended4thStringOffsets
        }
        else if chordType == "5" {
            StringOffsets = fifthStringOffsets
        }
        
        if ext == "None" {
            positiveExtensionOffsets = noneExtensionOffsets
            negativeExtensionOffsets = noneExtensionOffsets
        }
        else if ext == "6" {
            positiveExtensionOffsets = noneExtensionOffsets
            negativeExtensionOffsets = sixthExtensionOffsets
        }
        else if ext == "7" {
            positiveExtensionOffsets = noneExtensionOffsets
            negativeExtensionOffsets = seventhExtensionOffsets
        }
        else if ext == "Maj7" {
            positiveExtensionOffsets = noneExtensionOffsets
            negativeExtensionOffsets = majorseventhExtensionOffsets
        }
        else if ext == "Add9" {
            positiveExtensionOffsets = addninthExtensionOffsets
            negativeExtensionOffsets = noneExtensionOffsets
        }
        else if ext == "9" {
            positiveExtensionOffsets = addninthExtensionOffsets
            negativeExtensionOffsets = partialExtensionOffsets
        }
        else if ext == "11" {
            positiveExtensionOffsets = eleventhExtensionOffsets
            negativeExtensionOffsets = partialExtensionOffsets
        }
        else if ext == "13" {
            positiveExtensionOffsets = noneExtensionOffsets
            negativeExtensionOffsets = thirtenthExtensionOffsets
        }
        
        if bass == "None" {
            bassInput = baseTriadBass
        }else{
            bassInput = bassNotes[bass]
        }
        
        previousChordNotes = currentChordNotes
        currentChordNotes =
            [string1: baseTriadBass + StringOffsets[string1]! + positiveExtensionOffsets[string1]! - negativeExtensionOffsets[string1]!,
             string2: baseTriadBass + StringOffsets[string2]! + positiveExtensionOffsets[string2]! - negativeExtensionOffsets[string2]!,
             string3: baseTriadBass + StringOffsets[string3]! + positiveExtensionOffsets[string3]! - negativeExtensionOffsets[string3]!,
             string4: baseTriadBass + StringOffsets[string4]! + positiveExtensionOffsets[string4]! - negativeExtensionOffsets[string4]!,
             string5: baseTriadBass + StringOffsets[string5]! + positiveExtensionOffsets[string5]! - negativeExtensionOffsets[string5]!,
             string6: bassInput,
        ]
    }
    
    func processAngle(angleAddress: UnsafeMutablePointer<Double>, flipSign: Bool){  //changed
        if (flipSign){
            if angleAddress.pointee >= 0 {
                angleAddress.pointee = 180 - angleAddress.pointee
            }
            else if angleAddress.pointee < 0 {
                angleAddress.pointee = -180 - angleAddress.pointee
            }
        }
        
        if angleAddress.pointee > 180 {
            angleAddress.pointee = -360 + angleAddress.pointee
        }
        else if angleAddress.pointee < -180 {
            angleAddress.pointee = 360 + angleAddress.pointee
        }
    }
    
    func bindAngleStringUp(angle: Double, stringUp: UnsafeMutablePointer<Bool>, string: String, velocity: UInt8, play: Bool) -> Bool{
        if ((rollCalibrated > angle && stringUp.pointee) || (rollCalibrated < angle && !stringUp.pointee)){
            stringUp.pointee = !stringUp.pointee
            if velocity > 40 {
                //hit string
                if play {
                    self.playString(string: string, velocity: velocity)
                }
                return true
            }
        }
        return false
    }
    
    func playString(string: String, velocity: UInt8){
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        } else {
            // Fallback on earlier versions
        }
        
        //mute previous chord if needed
        if newChordForString[string]! && !currentChordNotes.values.contains(previousChordNotes[string]!) {
            self.sampler.playOpened(note: previousChordNotes[string]!, velocity: 1)
            newChordForString[string] = false
        }
        
        var noteToPlay: UInt8 = 0
        var playMuted = false
        if string == string6 {
            noteToPlay = bassInput
            if enableMute && self.yawCalibrated <= 0 {
                playMuted = true
            }
        }
        else {
            noteToPlay = baseTriadBass + StringOffsets[string]! + positiveExtensionOffsets[string]! - negativeExtensionOffsets[string]!
            if enableMute && self.yawCalibrated <= 0 {
                playMuted = true
            }
        }
        
        print("playString " + string + " " + String(noteToPlay))
        
        if playMuted {
            self.sampler.playOpened(note: noteToPlay, velocity: 1)
            if (noteToPlay < 67){
                //avoid the wrong muted note
                if noteToPlay != 66 {
                    self.sampler.playMuted(note: noteToPlay, velocity: velocity)
                }
            }
        }
        else {
            self.sampler.playOpened(note: noteToPlay, velocity: velocity)
        }
    }
    
    func playString2(string: String, velocity: UInt8){
        print("playString2: " + string)
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        } else {
            // Fallback on earlier versions
        }
        if string == string6 {
            if enableMute {
                if self.yawCalibrated > 0 {
                    self.sampler2.playOpened(note: bassInput, velocity: velocity)
                }
                else {
                    self.sampler2.playOpened(note: bassInput, velocity: 1)
                    self.sampler2.playMuted(note: bassInput, velocity: velocity)
                }
            }
            else{
                self.sampler2.playOpened(note: bassInput, velocity: velocity)
            }
        }
        else {
            let note = baseTriadBass + StringOffsets[string]! + positiveExtensionOffsets[string]! - negativeExtensionOffsets[string]!
            if enableMute{
                if self.yawCalibrated > 0 {
                    self.sampler2.playOpened(note: note, velocity: velocity)
                }
                else{
                    self.sampler2.playOpened(note: note, velocity: 1)
                    if (note < 67){
                        self.sampler2.playMuted(note: note, velocity: velocity)
                    }
                }
            }
            else{
                self.sampler2.playOpened(note: note, velocity: velocity)
            }
        }
    }
    
    func setEnableMute(enable: Bool){
        enableMute = enable
    }
    
    func setEnableUpStroke(enable: Bool){
        enableUpStroke = enable
    }
    
    func setEnablePluck(enable: Bool){
        enablePluck = enable
    }
    
    func calibrate(){
        yawOffset = yaw
        pitchOffset = pitch
        rollOffset = roll
    }
}
