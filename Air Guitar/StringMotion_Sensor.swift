//
//  MotionString.swift
//  MotionReadingsTest
//
//  Created by ios_Training(EEE) on 25/6/2018.
//  Copyright © 2018 iOS Training (EEE). All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

class StringMotion_Sensor : NSObject {
    
    var motionManager:CMMotionManager!
    
    var rate:Double!; var sampleTime:Double!; var sampleInterval:Float!
    var x3:Float!; var y3:Float!; var z3:Float!
    var accel:Float!; var accelPrev:Float!; var accelMax:Float!; var accelChangeRateMax:Float!
    var velocity:Float!; var velocityPrev:Float!; var velocityMax:Float!; var velocityA:Float = 0; var velocityB:Float = 0
    var displacement:Float = 0; var displacementPrev:Float!; var displacementMax:Float!
    
    var gyroX:Float!; var gyroXPrev:Float!; var gyroXMax:Float!
    var gyroXAccel:Float!; var gyroXAccelPrev:Float!; var gyroXAccelMax:Float!
    var gyroY:Float!; var gyroYPrev:Float!; var gyroYMax:Float!
    var gyroYAccel:Float!; var gyroYAccelPrev:Float!; var gyroYAccelMax:Float!
    var gyroZ:Float!; var gyroZPrev:Float!; var gyroZMax:Float!
    var gyroZAccel:Float!; var gyroZAccelPrev:Float!; var gyroZAccelMax:Float!
    var gyroAngle_Roll:Float!; var gyroAngle_Pitch:Float!
    
    var accelerated:Bool!; var decelerated:Bool!
    var velocityIncreased:Bool!; var velocityDecreased:Bool!
    var stateMachine_Core_Linear_Direction:String!; var stateMachine_Core_Linear_Phase:String!
    var stateMachine_Core_GyroY_Direction:String!; var stateMachine_Core_GyroY_Phase:String!
    var stateMachine_Core_GyroY_StartAngle:Float!; var stateMachine_Core_GyroY_StartAngle_Z:Float!
    var stateMachine_Core_GyroX_Direction:String!; var stateMachine_Core_GyroX_Phase:String!
    var stateMachine_Core_GyroX_StartAngle:Float!; var stateMachine_Core_GyroX_StartAngle_Z:Float!
    
    var sensitivity:Float!
    
    var stopped:Bool!
    var hitString_State:String!
    
    var hitAngle:Float!
    
    
    var strings_Sector:Int!; var strings_LastPass:Int!
    var strings_Strumming_Direction:Int!; var strings_Strumming_Count:Int = 0; var strings_Strumming_Speed:Float!
    var strings_Strumming_StartTime:Double!; var strings_Strumming_Time:Double!; var strings_Strumming_Interval:Double!
    var strumLoopLock:Bool = false; var strumLoopLock_PrevStrum:String = ""; var strumLoopLock_PrevString:Int = -1
    var strings_Strumming_Modifier:Float!
    
    var upPickLock:Bool!
    var percissionModeLock:Bool!
    
    var stringThres1:Float!; var stringThres2:Float!; var stringThres3:Float!; var stringThres4:Float!; var stringThres5:Float!
    var string_Interval:Float!
    
    var string1_hit:Bool!; var string2_hit:Bool!; var string3_hit:Bool!
    var string4_hit:Bool!; var string5_hit:Bool!; var string6_hit:Bool!
    //    var string_hit:Int = 0
    
    // ---------------------------------------------------------------
    // Observer
    
    var parent:StringMotion_Parent!
    
    func setParent( parentClass : StringMotion_Parent){
        self.parent = parentClass
    }
    
    func notify(_ input:Int){
        //self.parent.string_Detected(input-1)
    }
    
    
    // ---------------------------------------------------------------
    
    init(_ parent:StringMotion_Parent) {
        motionManager = CMMotionManager()
        
        rate = 100.0  //max is 100
        sampleTime = NSDate().timeIntervalSince1970*1000; sampleInterval = 0
        x3 = 0; y3 = 0; z3 = 0
        accel = 0; accelPrev = 0; accelMax = 0; accelChangeRateMax = 0
        velocity = 0; velocityPrev = 0; velocityMax = 0; velocityA = 0; velocityB = 0
        displacement = 0; displacementPrev = 0; displacementMax = 0
        
        self.gyroX = 0; self.gyroXPrev = 0; self.gyroXMax = 0
        self.gyroXAccel = 0; self.gyroXAccelPrev = 0; self.gyroXAccelMax = 0;
        self.gyroY = 0; self.gyroYPrev = 0; self.gyroYMax = 0
        self.gyroYAccel = 0; self.gyroYAccelPrev = 0; self.gyroYAccelMax = 0;
        self.gyroZ = 0; self.gyroZPrev = 0; self.gyroZMax = 0
        self.gyroZAccel = 0; self.gyroZAccelPrev = 0; self.gyroZAccelMax = 0;
        self.gyroAngle_Roll = 0; self.gyroAngle_Pitch = 0
        
        self.accelerated = false; self.decelerated = false
        self.velocityIncreased = false; self.velocityDecreased = false
        self.stateMachine_Core_Linear_Direction = "0"; self.stateMachine_Core_Linear_Phase = "0"
        self.stateMachine_Core_GyroY_Direction = "0"; self.stateMachine_Core_GyroY_Phase = "0"
        self.stateMachine_Core_GyroY_StartAngle = 0; self.stateMachine_Core_GyroY_StartAngle_Z = 0
        self.stateMachine_Core_GyroX_Direction = "0"; self.stateMachine_Core_GyroX_Phase = "0"
        self.stateMachine_Core_GyroX_StartAngle = 0; self.stateMachine_Core_GyroX_StartAngle_Z = 0
        
        self.sensitivity = 130
        
        self.stopped = false
        self.hitString_State = "0"
        
        self.hitAngle = 0
        
        self.strings_Sector = 0; self.strings_LastPass = 0
        self.string1_hit = false; self.string2_hit = false; self.string3_hit = false
        self.string4_hit = false; self.string5_hit = false; self.string6_hit = false
        self.strings_Strumming_Direction = 0; self.strings_Strumming_Count = 0; self.strings_Strumming_Speed = 0
        self.strings_Strumming_StartTime = 0; self.strings_Strumming_Time = 0; self.strings_Strumming_Interval = 0
        self.strings_Strumming_Modifier = 0;
        
        self.stringThres1 = 120
        self.stringThres2 = 105
        self.stringThres3 = 90
        self.stringThres4 = 75
        self.stringThres5 = 60
        self.string_Interval = 15
        
        self.upPickLock = true
        self.percissionModeLock = true
        
        self.parent = parent
        
        //        NotificationCenter.default.post(name: Notification.Name("string_hit"), object: nil)
        //        self.post(name: Notification.Name("string_hit"), object: nil)
        
    }
    
    // Daniel
    func getVerticalVelocity()->Float{
        return self.velocity
    }
    
    func setSensitivity(_ input:Float ){
        self.sensitivity = input
    }
    
    func setSensitivity(_ input:Int ){
        self.sensitivity = Float(input)
    }
    
    func upPick_Off(){
        self.upPickLock = true
    }
    
    func upPick_On(){
        self.upPickLock = false
    }
    
    func upPickLock(_ input:Bool){
        self.upPickLock = input
    }
    
    func percissionMode(_ input:Bool){
        self.percissionModeLock = input
    }
    
    func setStringPos_Highest(){
        var currentAngle:Float = self.gyroAngle_Roll
        if self.gyroAngle_Pitch > self.gyroAngle_Roll {
            currentAngle = self.gyroAngle_Pitch
        }
        self.stringThres1 = currentAngle
        self.setStringPos_Readjust()
    }
    
    func setStringPos_Lowest(){
        var currentAngle:Float = self.gyroAngle_Roll
        if self.gyroAngle_Pitch < self.gyroAngle_Roll {
            currentAngle = self.gyroAngle_Pitch
        }
        self.stringThres5 = currentAngle
        self.setStringPos_Readjust()
    }
    
    func setStringPos_Readjust(){
        self.string_Interval = (self.stringThres1 - self.stringThres5) / 4
        self.stringThres2 = self.stringThres1 - self.string_Interval
        self.stringThres3 = self.stringThres1 - 2*self.string_Interval
        self.stringThres4 = self.stringThres1 - 3*self.string_Interval
        print("string thres: ",self.stringThres1," ",self.stringThres2," ",self.stringThres3," ",self.stringThres4," ",self.stringThres5)
    }
    
    
    
    
    func motionDetectloop(){
        motionManager.gyroUpdateInterval = (1.0/rate)
        motionManager.accelerometerUpdateInterval = (1.0/rate)
        motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
            if let myGyroData = data
            {
                self.motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
                    if let myAttData = data
                    {
                        self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                            if let myAccelData = data
                            {
                                
                                
                                self.string1_hit = false; self.string2_hit = false; self.string3_hit = false
                                self.string4_hit = false; self.string5_hit = false; self.string6_hit = false
                                
                                //-------------------------------------------------------------------------
                                // Update Sensor Readings
                                
                                // Sampling Interval (ms)
                                
                                let newSampleTime = NSDate().timeIntervalSince1970*1000
                                self.sampleInterval = Float((newSampleTime - self.sampleTime)/1000)
                                self.sampleTime = newSampleTime
                                
                                // Vetical Acceleration (relative to gravity)
                                let x1 = Float(myAttData.userAcceleration.x); let x2 = Float(myAccelData.acceleration.x)
                                let y1 = Float(myAttData.userAcceleration.y); let y2 = Float(myAccelData.acceleration.y)
                                let z1 = Float(myAttData.userAcceleration.z); let z2 = Float(myAccelData.acceleration.z)
                                let tempX = acos(x1 - x2); let tempY = acos(y1 - y2); let tempZ = acos(z1 - z2)
                                if !(tempX.isNaN){self.x3 = tempX}; if !(tempY.isNaN){self.y3 = tempY}; if !(tempZ.isNaN){self.z3 = tempZ}
                                self.accel = x1*cos(self.x3) + y1*cos(self.y3) + z1*cos(self.z3)
                                
                                // Clear false/discrete acceleration and velocity
                                if ( abs(100*self.velocity) < 0.01 && self.accel == self.accelPrev ){
                                    self.velocityA = 0; self.velocityB = 0
                                }
                                
                                // Linear Veritcal Velocity (from acceleration)
                                if (self.accel > 0.01){
                                    self.accelerated = true
                                    if self.accel > self.accelPrev{
                                        self.velocityA += self.accelPrev*self.sampleInterval
                                        self.velocityA += (self.accel - self.accelPrev)*self.sampleInterval/2
                                    }
                                    else if self.accel < self.accelPrev{
                                        self.velocityA += self.accel*self.sampleInterval
                                        self.velocityA += (self.accelPrev - self.accel)*self.sampleInterval/2
                                    }
                                }
                                else if (self.accel < -0.01){
                                    self.decelerated = true
                                    if self.accel < self.accelPrev{
                                        self.velocityB += self.accelPrev*self.sampleInterval
                                        self.velocityB += (self.accel - self.accelPrev)*self.sampleInterval/2
                                    }
                                    else if self.accel > self.accelPrev{
                                        self.velocityB += self.accel*self.sampleInterval
                                        self.velocityB += (self.accelPrev - self.accel)*self.sampleInterval/2
                                    }
                                }
                                else {
                                    if  ( self.accelerated && self.decelerated )
                                        || ( self.accelerated != self.decelerated )
                                        || ( abs(100*self.velocity) < 0.01 )
                                    {
                                        self.velocityA = 0; self.velocityB = 0; self.accelerated = false; self.decelerated = false
                                    }
                                }
                                
                                self.velocity = self.velocityA + self.velocityB
//                                print(self.velocity)
                                
                                if abs(self.velocity) > abs(self.velocityPrev) {
                                    self.velocityIncreased = true
                                }
                                if abs(self.velocity) < abs(self.velocityPrev) {
                                    self.velocityDecreased = true
                                }
                                
                                // Angular Velocity
                                self.gyroX = Float(myGyroData.rotationRate.x)
                                self.gyroY = Float(myGyroData.rotationRate.y)
                                self.gyroZ = Float(myGyroData.rotationRate.z)
                                
                                // Angular Acceleration
                                self.gyroXAccel = (self.gyroX-self.gyroXPrev)/self.sampleInterval
                                self.gyroYAccel = (self.gyroY-self.gyroYPrev)/self.sampleInterval
                                self.gyroZAccel = (self.gyroZ-self.gyroZPrev)/self.sampleInterval
                                
                                // Angular Roll and Pitch
                                self.gyroAngle_Roll = Float(myAttData.attitude.roll*(180.0/Double.pi))
                                self.gyroAngle_Pitch = Float(myAttData.attitude.pitch*(180.0/Double.pi))
                                
                                // State Machines
                                self.StateMachine_Core_Linear()
                                self.StateMachine_Core_GyroY()
                                self.StateMachine_Core_GyroX()
                                
                                // Displacement
                                switch self.stateMachine_Core_Linear_Direction{
                                case "1" : self.displacement += abs((self.velocity-self.velocityPrev) / self.sampleInterval)
                                case "2" : self.displacement -= abs((self.velocity-self.velocityPrev) / self.sampleInterval)
                                default: self.displacement = 0
                                }
                                
                                //-------------------------------------------------------------------------
                                
                                self.UpdateMax()
                                
                                //-------------------------------------------------------------------------
                                
                                let movementData = ( self.stateMachine_Core_Linear_Direction,self.stateMachine_Core_Linear_Phase,
                                                     self.stateMachine_Core_GyroY_Direction,self.stateMachine_Core_GyroY_Phase,
                                                     self.stateMachine_Core_GyroX_Direction,self.stateMachine_Core_GyroX_Phase,
                                                     self.stopped,self.hitString_State )
                                switch movementData{
                                case(let move1,_,let move2,_,let move3,_,true,_) where move1 != "0" || move2 != "0" || move3 != "0" :
                                    self.stopped = false
                                case(let move1,_,let move2,_,let move3,_,false,_) where move1 == "0" || move2 == "0" || move3 == "0" :
                                    self.stopped = true; self.hitString_State = "0"
                                case(let move1,_,let move2,_,let move3,_,_,_) where move1 == "0" && move2 == "0" && move3 == "0" :
                                    self.stopped = true; self.hitString_State = "0"
                                default: ()
                                }
                                
                                if self.stateMachine_Core_Linear_Direction == "0" && self.stateMachine_Core_Linear_Phase == "0" {
                                    self.accelMax = 0; self.velocityMax = 0; self.displacementMax = 0
                                }
                                if self.stateMachine_Core_GyroY_Direction == "0" && self.stateMachine_Core_GyroY_Phase == "0" {
                                    self.gyroYAccelMax = 0; self.gyroYMax = 0
                                }
                                if self.stateMachine_Core_GyroX_Direction == "0" && self.stateMachine_Core_GyroX_Phase == "0" {
                                    self.gyroXAccelMax = 0; self.gyroXMax = 0
                                }
                                
                                //-------------------------------------------------------------------------
//                                self.strings_CheckSector()
                                //                                self.strings_StrummingHandler()
                                //-------------------------------------------------------------------------
                                
//                                // Pluck and Strum
//
//                                let triggerThreshold_gyroAccel:Float = self.sensitivity
//
//                                let threshold_AngleDifference:Float = 30
//                                let angleDifference_Y = abs(self.x3/Float.pi*180 - self.stateMachine_Core_GyroY_StartAngle)
//                                let angleDifference_X = abs(self.y3/Float.pi*180 - self.stateMachine_Core_GyroX_StartAngle)
//                                let angleDifference_XY = sqrt(angleDifference_Y*angleDifference_Y + angleDifference_X*angleDifference_X)
//                                let gyroXY = sqrt( self.gyroYMax*self.gyroYMax + self.gyroXMax*self.gyroXMax )
//
//                                let displacement_Threshold:Float = 50
//                                let threshold_strumVelocity:Float = 9
                                
//
//                                if  ( !self.stopped && self.hitString_State == "0" ) {
//                                    // Strum Downward
//                                    if ( self.gyroY <= -1*threshold_strumVelocity  && self.gyroAngle_Roll <= 140 &&
//                                        self.stateMachine_Core_GyroY_StartAngle_Z > 140)
//                                    {
//                                        self.hitString_State = "strum_down_Y"
//                                        self.strings_Strumming_Count = 0
//                                        print("strum downwards")
//                                    }
//                                    else if ( self.gyroX <= -1*threshold_strumVelocity  && self.gyroAngle_Pitch <= 140 &&
//                                        self.stateMachine_Core_GyroX_StartAngle_Z > 140)
//                                    {
//                                        self.hitString_State = "strum_down_X"
//                                        self.strings_Strumming_Count = 0
//                                        print("strum downwards")
//                                    }
//                                    else if ( gyroXY >= threshold_strumVelocity  &&
//                                        ( self.gyroY < 0 && self.gyroX < 0 ) &&
//                                        ( self.gyroAngle_Roll <= 140 || self.gyroAngle_Pitch <= 140 ) &&
//                                        ( self.stateMachine_Core_GyroY_StartAngle_Z > 140 ||
//                                            self.stateMachine_Core_GyroX_StartAngle_Z > 140) )
//                                    {
//                                        self.hitString_State = "strum_down_XY"
//                                        self.strings_Strumming_Count = 0
//                                        print("strum downwards")
//                                    }
//                                        // Strum Upward
//                                    else if ( self.gyroY >= threshold_strumVelocity  && self.gyroAngle_Roll >= 40 &&
//                                        self.stateMachine_Core_GyroY_StartAngle_Z < 40)
//                                    {
//                                        self.hitString_State = "strum_up_Y"
//                                        self.strings_Strumming_Count = 0
//                                        print("strum upwards")
//                                    }
//                                    else if ( self.gyroX >= threshold_strumVelocity  && self.gyroAngle_Pitch >= 40 &&
//                                        self.stateMachine_Core_GyroX_StartAngle_Z < 40)
//                                    {
//                                        self.hitString_State = "strum_up_X"
//                                        self.strings_Strumming_Count = 0
//                                        print("strum upwards")
//                                    }
//                                    else if ( gyroXY >= threshold_strumVelocity  &&
//                                        ( self.gyroY > 0 && self.gyroX > 0 ) &&
//                                        ( self.gyroAngle_Roll >= 40 || self.gyroAngle_Pitch >= 40 ) &&
//                                        ( self.stateMachine_Core_GyroY_StartAngle_Z < 40 ||
//                                            self.stateMachine_Core_GyroX_StartAngle_Z < 40) )
//                                    {
//                                        self.hitString_State = "strum_up_XY"
//                                        self.strings_Strumming_Count = 0
//                                        print("strum upwards")
//                                    }
                                
//                                        // Pluck
//                                    if ( ( sqrt( self.gyroYAccelMax*self.gyroYAccelMax +
//                                        self.gyroXAccelMax*self.gyroXAccelMax ) > triggerThreshold_gyroAccel ) ) &&
//                                        ( ( !( self.upPickLock && self.stateMachine_Core_GyroY_Direction == "1" ) &&
//                                            self.stateMachine_Core_GyroY_Phase == "B" && self.gyroYAccel < self.gyroYAccelMax*0.5 ) ||
//                                            ( !( self.upPickLock && self.stateMachine_Core_GyroX_Direction == "1" ) &&
//                                                self.stateMachine_Core_GyroX_Phase == "B" && self.gyroXAccel < self.gyroXAccelMax*0.5 ) ) &&
//                                        ( self.stateMachine_Core_GyroY_Phase != "D" && self.stateMachine_Core_GyroX_Phase != "D" )
//                                    {
//
//                                        self.hitString_State = "pluck"
//
//                                        if #available(iOS 10.0, *) {
//                                            let generator = UIImpactFeedbackGenerator(style: .heavy)
//                                            generator.impactOccurred()
//                                        } else {
//                                            // Fallback on earlier versions
//                                        }
//
//
//                                        var startAngle:Float = 0
//
//                                        if self.stateMachine_Core_GyroY_Phase == "B" && self.stateMachine_Core_GyroY_Phase == "B"{
//                                            if self.gyroAngle_Roll > self.gyroAngle_Pitch {
//                                                self.hitAngle = Float( self.gyroAngle_Roll )
//                                                startAngle = self.stateMachine_Core_GyroY_StartAngle_Z
//                                            }
//                                            else{
//                                                self.hitAngle = Float( self.gyroAngle_Pitch )
//                                                startAngle = self.stateMachine_Core_GyroX_StartAngle_Z
//                                            }
//                                        }
//                                        else if self.stateMachine_Core_GyroY_Phase != "B"{
//                                            self.hitAngle = Float( self.gyroAngle_Roll )
//                                            startAngle = self.stateMachine_Core_GyroY_StartAngle_Z
//                                        }
//                                        else if self.stateMachine_Core_GyroX_Phase != "B"{
//                                            self.hitAngle = Float( self.gyroAngle_Pitch )
//                                            startAngle = self.stateMachine_Core_GyroX_StartAngle_Z
//                                        }
//
//                                        if self.percissionModeLock {
//
//                                            if self.hitAngle > self.stringThres1 {
//                                                print("         pluck 1")
//                                                self.stringHit(1)
//                                            }
//                                            else if self.hitAngle > self.stringThres2 {
//                                                print("         pluck 2")
//                                                self.stringHit(2)
//                                            }
//                                            else if self.hitAngle > self.stringThres3 {
//                                                print("         pluck 3")
//                                                self.stringHit(3)
//                                            }
//                                            else if self.hitAngle > self.stringThres4 {
//                                                print("         pluck 4")
//                                                self.stringHit(4)
//                                            }
//                                            else if self.hitAngle > self.stringThres5 {
//                                                print("         pluck 5")
//                                                self.stringHit(5)
//                                            }
//                                            else{
//                                                print("         pluck 6")
//                                                self.stringHit(6)
//                                            }
//
//
//                                        }
//                                        else {
//                                            let angleCalc = ( ( ( self.hitAngle + startAngle ) / 2 ) - angleDifference_XY - gyroXY - self.velocityMax*100)
//                                            if angleCalc >= self.stringThres1 {
//                                                print("         pluck 1")
//                                                self.stringHit(1)
//                                            }
//                                            else if angleCalc >= self.stringThres2 {
//                                                print("         pluck 2")
//                                                self.stringHit(2)
//                                            }
//                                            else if angleCalc >= self.stringThres3 {
//                                                print("         pluck 3")
//                                                self.stringHit(3)
//                                            }
//                                            else if angleCalc >= self.stringThres4 {
//                                                print("         pluck 4")
//                                                self.stringHit(4)
//                                            }
//                                            else if angleCalc >= self.stringThres5 {
//                                                print("         pluck 5")
//                                                self.stringHit(5)
//                                            }
//                                            else {
//                                                print("         pluck 6")
//                                                self.stringHit(6)
//                                            }
//                                        }
//
//                                    }

//
//                                    //                                    // Strum
//                                    //                                    else if ( self.stateMachine_Core_GyroY_Phase == "A" || self.stateMachine_Core_GyroX_Phase == "A" ||
//                                    //                                        self.stateMachine_Core_GyroY_Phase == "B" || self.stateMachine_Core_GyroX_Phase == "B" ) &&
//                                    //                                        ( ( angleDifference_Y > threshold_AngleDifference ||
//                                    //                                            angleDifference_XY > threshold_AngleDifference ) &&
//                                    //                                            self.gyroAngle_Roll >= 30 && self.gyroAngle_Roll <= 150 &&
//                                    //                                            ( self.stateMachine_Core_GyroY_StartAngle_Z < 30 ||
//                                    //                                                self.stateMachine_Core_GyroY_StartAngle_Z > 150 ) ) ||
//                                    //                                        ( ( angleDifference_X > threshold_AngleDifference ||
//                                    //                                            angleDifference_XY > threshold_AngleDifference ) &&
//                                    //                                            self.gyroAngle_Pitch >= 30 && self.gyroAngle_Pitch <= 150 &&
//                                    //                                            ( self.stateMachine_Core_GyroX_StartAngle_Z < 30 ||
//                                    //                                                self.stateMachine_Core_GyroX_StartAngle_Z > 150 ) ) ||
//                                    //                                        ( self.displacementMax > displacement_Threshold ) {
//                                    //
//                                    //                                        if ( self.displacementMax > displacement_Threshold ){
//                                    //                                            if self.displacement > 0{ self.strings_Strumming_Direction = 1}
//                                    //                                            if self.displacement < 0{ self.strings_Strumming_Direction = -1}
//                                    //                                        }
//                                    //                                        else{
//                                    //                                            if self.gyroY+self.gyroX < 0{ self.strings_Strumming_Direction = 1 }
//                                    //                                            else { self.strings_Strumming_Direction = -1 }
//                                    //                                        }
//                                    //                                        self.strings_Strumming_Speed = sqrt( self.gyroYMax*self.gyroYMax + self.gyroXMax*self.gyroXMax )
//                                    //                                            + self.velocityMax*100
//                                    //                                        self.strings_Strumming_Time = 0
//                                    //                                        self.strings_Strumming_StartTime = NSDate().timeIntervalSince1970*1000
//                                    //                                        self.strings_Strumming_Interval = 1000
//                                    //                                        self.hitString_State = "strum"
//                                    //                                        print("strum")
//                                    //
//                                    //                                    }
//
//                                }
//
//
//                                //                                if ( self.hitString_State == "strum_up" || self.hitString_State == "strum_down" ) {
//                                self.strings_StrummingHandler()
//                                //                                }
//
//                                //-------------------------------------------------------------------------
                                self.UpdatePrev()
//                                //-------------------------------------------------------------------------
//                                
                                
                            }
                        }
                    }
                }
            }
            
        }
        
    }
    
    func stringHit(_ input:Int){
        if self.hitString_State == "pluck" {
            self.notify( 7 - input )
            self.strumLoopLock_PrevStrum = ""
            self.strumLoopLock_PrevString = -1
        }
        else{
            if !( self.strumLoopLock_PrevStrum == self.hitString_State &&
                self.strumLoopLock_PrevString == self.strings_Strumming_Count )
            {
                self.notify( 7 - input )
                self.strumLoopLock_PrevStrum = self.hitString_State
                self.strumLoopLock_PrevString = self.strings_Strumming_Count
            }
            
        }
        
    }
    
    func UpdateMax()->Void{
        // Update maximum readings
        if abs(self.accel) > self.accelMax{ self.accelMax = abs(self.accel) }
        let accelChangeRateTemp = abs( (self.accel-self.accelPrev) / self.sampleInterval )
        if accelChangeRateTemp > self.accelChangeRateMax{ self.accelChangeRateMax = accelChangeRateTemp }
        if abs(self.velocityA) > self.velocityMax{ self.velocityMax = abs(self.velocityA) }
        if abs(self.velocityB) > self.velocityMax{ self.velocityMax = abs(self.velocityB) }
        if abs(self.gyroX) > self.gyroXMax{ self.gyroXMax = abs(self.gyroX) }
        if abs(self.gyroY) > self.gyroYMax{ self.gyroYMax = abs(self.gyroY) }
        if abs(self.gyroZ) > self.gyroZMax{ self.gyroZMax = abs(self.gyroZ) }
        if abs(self.gyroXAccel) > self.gyroXAccelMax{ self.gyroXAccelMax = abs(self.gyroXAccel) }
        if abs(self.gyroYAccel) > self.gyroYAccelMax{ self.gyroYAccelMax = abs(self.gyroYAccel) }
        if abs(self.gyroZAccel) > self.gyroZAccelMax{ self.gyroZAccelMax = abs(self.gyroZAccel) }
        if abs(self.displacement) > abs(self.displacementMax){ self.displacementMax = abs(self.displacement) }
    }
    
    func UpdatePrev()->Void{
        // Store current acceleration and velocity as reference
        self.accelPrev = self.accel
        self.velocityPrev = self.velocity
        self.gyroXPrev = self.gyroX
        self.gyroYPrev = self.gyroY
        self.gyroZPrev = self.gyroZ
        self.gyroXAccelPrev = self.gyroXAccel
        self.gyroYAccelPrev = self.gyroYAccel
        self.gyroZAccelPrev = self.gyroZAccel
        self.displacementPrev = self.displacement
    }
    
    func StateMachine_Core_Linear()->Void{
        // State Machine (Core - Linear)
        let coreLinearData = (self.stateMachine_Core_Linear_Direction,self.stateMachine_Core_Linear_Phase,
                              self.accel,self.velocity,self.accelerated,self.decelerated)
        switch coreLinearData{
        case ("0","0",let acc,let vel,_,_) where acc > self.accelPrev && vel > self.velocityPrev:
            self.stateMachine_Core_Linear_Direction = "1"
            self.stateMachine_Core_Linear_Phase = "A"
        case ("1","A",let acc,let vel,_,_) where acc < self.accelPrev && vel > self.velocityPrev:
            self.stateMachine_Core_Linear_Direction = "1"
            self.stateMachine_Core_Linear_Phase = "B"
        case ("1","B",let acc,let vel,_,_) where acc < self.accelPrev && vel < self.velocityPrev:
            self.stateMachine_Core_Linear_Direction = "1"
            self.stateMachine_Core_Linear_Phase = "C"
        case ("1","C",let acc,let vel,_,_) where acc > self.accelPrev && vel < self.velocityPrev:
            self.stateMachine_Core_Linear_Direction = "1"
            self.stateMachine_Core_Linear_Phase = "D"
        case ("1","D",let acc,_,_,_) where acc < self.accelPrev:
            self.stateMachine_Core_Linear_Direction = "0"
            self.stateMachine_Core_Linear_Phase = "0"
            self.clearMotionValues_Linear()
        case ("0","0",let acc,let vel,_,_) where acc < self.accelPrev && vel < self.velocityPrev:
            self.stateMachine_Core_Linear_Direction = "2"
            self.stateMachine_Core_Linear_Phase = "A"
        case ("2","A",let acc,let vel,_,_) where acc > self.accelPrev && vel < self.velocityPrev:
            self.stateMachine_Core_Linear_Direction = "2"
            self.stateMachine_Core_Linear_Phase = "B"
        case ("2","B",let acc,let vel,_,_) where acc > self.accelPrev && vel > self.velocityPrev:
            self.stateMachine_Core_Linear_Direction = "2"
            self.stateMachine_Core_Linear_Phase = "C"
        case ("2","C",let acc,let vel,_,_) where acc < self.accelPrev && vel > self.velocityPrev:
            self.stateMachine_Core_Linear_Direction = "2"
            self.stateMachine_Core_Linear_Phase = "D"
        case ("2","D",let acc,_,_,_) where acc > self.accelPrev:
            self.stateMachine_Core_Linear_Direction = "0"
            self.stateMachine_Core_Linear_Phase = "0"
            self.clearMotionValues_Linear()
        case (_,"D",_,_,false,false):
            self.stateMachine_Core_Linear_Direction = "0"
            self.stateMachine_Core_Linear_Phase = "0"
            self.clearMotionValues_Linear()
        case (_,_,_,_,false,false):
            self.stateMachine_Core_Linear_Direction = "0"
            self.stateMachine_Core_Linear_Phase = "0"
            self.clearMotionValues_Linear()
        default: ()
        }
    }
    
    func StateMachine_Core_GyroY()->Void{
        // State Machine (Core - Gyro Y)
        let initialGyroYVel:Float = 1.5
        let coreGyroYData = (self.stateMachine_Core_GyroY_Direction,self.stateMachine_Core_GyroY_Phase,
                             self.gyroYAccel,self.gyroY)
        switch coreGyroYData{
        case ("0","0",let acc,let vel) where acc > self.gyroYAccelPrev && vel > self.gyroYPrev && abs(vel!) > initialGyroYVel:
            self.stateMachine_Core_GyroY_Direction = "1"
            self.stateMachine_Core_GyroY_Phase = "A"
            self.stateMachine_Core_GyroY_StartAngle = self.x3/Float.pi*180
            self.stateMachine_Core_GyroY_StartAngle_Z = Float(self.gyroAngle_Roll)
        case ("1","A",let acc,let vel) where acc < self.gyroYAccelPrev && vel > self.gyroYPrev:
            self.stateMachine_Core_GyroY_Direction = "1"
            self.stateMachine_Core_GyroY_Phase = "B"
        case ("1","B",let acc,let vel) where acc < self.gyroYAccelPrev && vel < self.gyroYPrev:
            self.stateMachine_Core_GyroY_Direction = "1"
            self.stateMachine_Core_GyroY_Phase = "C"
        case ("1","C",let acc,let vel) where acc > self.gyroYAccelPrev && vel < self.gyroYPrev:
            self.stateMachine_Core_GyroY_Direction = "1"
            self.stateMachine_Core_GyroY_Phase = "D"
        case ("1","D",let acc,_) where acc < self.gyroYAccelPrev:
            self.stateMachine_Core_GyroY_Direction = "0"
            self.stateMachine_Core_GyroY_Phase = "0"
        case ("0","0",let acc,let vel) where acc < self.gyroYAccelPrev && vel < self.gyroYPrev && abs(vel!) > initialGyroYVel:
            self.stateMachine_Core_GyroY_Direction = "2"
            self.stateMachine_Core_GyroY_Phase = "A"
            self.stateMachine_Core_GyroY_StartAngle = self.x3/Float.pi*180
            self.stateMachine_Core_GyroY_StartAngle_Z = Float(self.gyroAngle_Roll)
        case ("2","A",let acc,let vel) where acc > self.gyroYAccelPrev && vel < self.gyroYPrev:
            self.stateMachine_Core_GyroY_Direction = "2"
            self.stateMachine_Core_GyroY_Phase = "B"
        case ("2","B",let acc,let vel) where acc > self.gyroYAccelPrev && vel > self.gyroYPrev:
            self.stateMachine_Core_GyroY_Direction = "2"
            self.stateMachine_Core_GyroY_Phase = "C"
        case ("2","C",let acc,let vel) where acc < self.gyroYAccelPrev && vel > self.gyroYPrev:
            self.stateMachine_Core_GyroY_Direction = "2"
            self.stateMachine_Core_GyroY_Phase = "D"
        case ("2","D",let acc,_) where acc > self.gyroYAccelPrev:
            self.stateMachine_Core_GyroY_Direction = "0"
            self.stateMachine_Core_GyroY_Phase = "0"
        case (_,let state,_,let vel) where state != "D" && state != "A" && abs(vel!) < initialGyroYVel:
            self.stateMachine_Core_GyroY_Direction = "0"
            self.stateMachine_Core_GyroY_Phase = "0"
            self.stateMachine_Core_GyroY_StartAngle = self.x3/Float.pi*180
            self.stateMachine_Core_GyroY_StartAngle_Z = Float(self.gyroAngle_Roll)
        default: ()
        }
    }
    
    func StateMachine_Core_GyroX()->Void{
        // State Machine (Core - Gyro X)
        let initialGyroXVel:Float = 1.5
        let coreGyroXData = (self.stateMachine_Core_GyroX_Direction,self.stateMachine_Core_GyroX_Phase,
                             self.gyroXAccel,self.gyroX)
        switch coreGyroXData{
        case ("0","0",let acc,let vel) where acc > self.gyroXAccelPrev && vel > self.gyroXPrev && abs(vel!) > initialGyroXVel:
            self.stateMachine_Core_GyroX_Direction = "1"
            self.stateMachine_Core_GyroX_Phase = "A"
            self.stateMachine_Core_GyroX_StartAngle = self.y3/Float.pi*180
            self.stateMachine_Core_GyroX_StartAngle_Z = Float(self.gyroAngle_Pitch)
        case ("1","A",let acc,let vel) where acc < self.gyroXAccelPrev && vel > self.gyroXPrev:
            self.stateMachine_Core_GyroX_Direction = "1"
            self.stateMachine_Core_GyroX_Phase = "B"
        case ("1","B",let acc,let vel) where acc < self.gyroXAccelPrev && vel < self.gyroXPrev:
            self.stateMachine_Core_GyroX_Direction = "1"
            self.stateMachine_Core_GyroX_Phase = "C"
        case ("1","C",let acc,let vel) where acc > self.gyroXAccelPrev && vel < self.gyroXPrev:
            self.stateMachine_Core_GyroX_Direction = "1"
            self.stateMachine_Core_GyroX_Phase = "D"
        case ("1","D",let acc,_) where acc < self.gyroXAccelPrev:
            self.stateMachine_Core_GyroX_Direction = "0"
            self.stateMachine_Core_GyroX_Phase = "0"
        case ("0","0",let acc,let vel) where acc < self.gyroXAccelPrev && vel < self.gyroXPrev && abs(vel!) > initialGyroXVel:
            self.stateMachine_Core_GyroX_Direction = "2"
            self.stateMachine_Core_GyroX_Phase = "A"
            self.stateMachine_Core_GyroX_StartAngle = self.y3/Float.pi*180
            self.stateMachine_Core_GyroX_StartAngle_Z = Float(self.gyroAngle_Pitch)
        case ("2","A",let acc,let vel) where acc > self.gyroXAccelPrev && vel < self.gyroXPrev:
            self.stateMachine_Core_GyroX_Direction = "2"
            self.stateMachine_Core_GyroX_Phase = "B"
        case ("2","B",let acc,let vel) where acc > self.gyroXAccelPrev && vel > self.gyroXPrev:
            self.stateMachine_Core_GyroX_Direction = "2"
            self.stateMachine_Core_GyroX_Phase = "C"
        case ("2","C",let acc,let vel) where acc < self.gyroXAccelPrev && vel > self.gyroXPrev:
            self.stateMachine_Core_GyroX_Direction = "2"
            self.stateMachine_Core_GyroX_Phase = "D"
        case ("2","D",let acc,_) where acc > self.gyroXAccelPrev:
            self.stateMachine_Core_GyroX_Direction = "0"
            self.stateMachine_Core_GyroX_Phase = "0"
        case (_,let state,_,let vel) where state != "D" && state != "A" && abs(vel!) < initialGyroXVel:
            self.stateMachine_Core_GyroX_Direction = "0"
            self.stateMachine_Core_GyroX_Phase = "0"
            self.stateMachine_Core_GyroX_StartAngle = self.y3/Float.pi*180
            self.stateMachine_Core_GyroX_StartAngle_Z = Float(self.gyroAngle_Pitch)
        default: ()
        }
    }
    
    func clearMotionValues_Linear()->Void{
        self.velocityA = 0; self.velocityB = 0; self.velocity = 0
        self.accelerated = false; self.decelerated = false
        self.velocityIncreased = false; self.velocityDecreased = false
    }
    
    func strings_StrummingHandler()->Void{
        if !( self.hitString_State == "pluck" || self.hitString_State == "0" ){
            
            let temp = self.strings_Strumming_Count
            let string1Temp = self.stringThres1 + ( self.string_Interval / 2 )
            let string2Temp = self.stringThres2 + ( self.string_Interval / 2 )
            let string3Temp = self.stringThres3 + ( self.string_Interval / 2 )
            let string4Temp = self.stringThres4 + ( self.string_Interval / 2 )
            let string5Temp = self.stringThres5 + ( self.string_Interval / 2 )
            let string6Temp = self.stringThres5 - ( self.string_Interval / 2 )
            
            
            
            if self.hitString_State == "strum_down_Y" && self.gyroY < 0 {
                let data = (self.strings_Strumming_Count,self.gyroAngle_Roll)
                switch data{
                case (0,let angle) where angle <= string1Temp :
                    self.stringHit(1)
                    self.strings_Strumming_Count = 1
                case (1,let angle) where angle <= string2Temp :
                    self.stringHit(2)
                    self.strings_Strumming_Count = 2
                case (2,let angle) where angle <= string3Temp :
                    self.stringHit(3)
                    self.strings_Strumming_Count = 3
                case (3,let angle) where angle <= string4Temp :
                    self.stringHit(4)
                    self.strings_Strumming_Count = 4
                case (4,let angle) where angle <= string5Temp :
                    self.stringHit(5)
                    self.strings_Strumming_Count = 5
                case (5,let angle) where angle <= string6Temp :
                    self.stringHit(6)
                    self.hitString_State = "0"
                    self.stateMachine_Core_GyroY_StartAngle_Z = Float(self.gyroAngle_Roll)
                    self.stateMachine_Core_GyroX_StartAngle_Z = Float(self.gyroAngle_Pitch)
                default:()
                }
            }
            else if self.hitString_State == "strum_down_X" && self.gyroX < 0 {
                let data = (self.strings_Strumming_Count,self.gyroAngle_Pitch)
                switch data{
                case (0,let angle) where angle <= string1Temp :
                    self.stringHit(1)
                    self.strings_Strumming_Count = 1
                case (1,let angle) where angle <= string2Temp :
                    self.stringHit(2)
                    self.strings_Strumming_Count = 2
                case (2,let angle) where angle <= string3Temp :
                    self.stringHit(3)
                    self.strings_Strumming_Count = 3
                case (3,let angle) where angle <= string4Temp :
                    self.stringHit(4)
                    self.strings_Strumming_Count = 4
                case (4,let angle) where angle <= string5Temp :
                    self.stringHit(5)
                    self.strings_Strumming_Count = 5
                case (5,let angle) where angle <= string6Temp :
                    self.stringHit(6)
                    self.hitString_State = "0"
                    self.stateMachine_Core_GyroY_StartAngle_Z = Float(self.gyroAngle_Roll)
                    self.stateMachine_Core_GyroX_StartAngle_Z = Float(self.gyroAngle_Pitch)
                default:()
                }
            }
            else if self.hitString_State == "strum_down_XY" && self.gyroX < 0 || self.gyroY < 0 {
                let data = (self.strings_Strumming_Count,self.gyroAngle_Roll,self.gyroAngle_Pitch)
                switch data{
                case (0,let y,let x) where y <= string1Temp || x <= string1Temp:
                    self.stringHit(1)
                    self.strings_Strumming_Count = 1
                case (1,let y,let x) where y <= string2Temp || x <= string2Temp:
                    self.stringHit(2)
                    self.strings_Strumming_Count = 2
                case (2,let y,let x) where y <= string3Temp || x <= string3Temp:
                    self.stringHit(3)
                    self.strings_Strumming_Count = 3
                case (3,let y,let x) where y <= string4Temp || x <= string4Temp:
                    self.stringHit(4)
                    self.strings_Strumming_Count = 4
                case (4,let y,let x) where y <= string5Temp || x <= string5Temp:
                    self.stringHit(5)
                    self.strings_Strumming_Count = 5
                case (5,let y,let x) where y <= string6Temp || x <= string6Temp:
                    self.stringHit(6)
                    self.hitString_State = "0"
                    self.stateMachine_Core_GyroY_StartAngle_Z = Float(self.gyroAngle_Roll)
                    self.stateMachine_Core_GyroX_StartAngle_Z = Float(self.gyroAngle_Pitch)
                default:()
                }
            }
            else if self.hitString_State == "strum_up_Y" && self.gyroY > 0 {
                let data = (self.strings_Strumming_Count,self.gyroAngle_Roll)
                switch data{
                case (0,let angle) where angle >= string6Temp :
                    self.stringHit(6)
                    self.strings_Strumming_Count = 1
                case (1,let angle) where angle >= string5Temp :
                    self.stringHit(5)
                    self.strings_Strumming_Count = 2
                case (2,let angle) where angle >= string4Temp :
                    self.stringHit(4)
                    self.strings_Strumming_Count = 3
                case (3,let angle) where angle >= string3Temp :
                    self.stringHit(3)
                    self.strings_Strumming_Count = 4
                case (4,let angle) where angle >= string2Temp :
                    self.stringHit(2)
                    self.strings_Strumming_Count = 5
                case (5,let angle) where angle >= string1Temp :
                    self.stringHit(1)
                    self.hitString_State = "0"
                    self.stateMachine_Core_GyroY_StartAngle_Z = Float(self.gyroAngle_Roll)
                    self.stateMachine_Core_GyroX_StartAngle_Z = Float(self.gyroAngle_Pitch)
                default:()
                }
            }
            else if self.hitString_State == "strum_up_X" && self.gyroX > 0 {
                let data = (self.strings_Strumming_Count,self.gyroAngle_Roll)
                switch data{
                case (0,let angle) where angle >= string6Temp :
                    self.stringHit(6)
                    self.strings_Strumming_Count = 1
                case (1,let angle) where angle >= string5Temp :
                    self.stringHit(5)
                    self.strings_Strumming_Count = 2
                case (2,let angle) where angle >= string4Temp :
                    self.stringHit(4)
                    self.strings_Strumming_Count = 3
                case (3,let angle) where angle >= string3Temp :
                    self.stringHit(3)
                    self.strings_Strumming_Count = 4
                case (4,let angle) where angle >= string2Temp :
                    self.stringHit(2)
                    self.strings_Strumming_Count = 5
                case (5,let angle) where angle >= string1Temp :
                    self.stringHit(1)
                    self.hitString_State = "0"
                    self.stateMachine_Core_GyroY_StartAngle_Z = Float(self.gyroAngle_Roll)
                    self.stateMachine_Core_GyroX_StartAngle_Z = Float(self.gyroAngle_Pitch)
                default:()
                }
            }
            else if self.hitString_State == "strum_up_XY" && self.gyroX > 0 || self.gyroY > 0 {
                let data = (self.strings_Strumming_Count,self.gyroAngle_Roll,self.gyroAngle_Pitch)
                switch data{
                case (0,let y,let x) where y >= string6Temp || x >= string6Temp:
                    self.stringHit(6)
                    self.strings_Strumming_Count = 1
                case (1,let y,let x) where y >= string5Temp || x >= string5Temp:
                    self.stringHit(5)
                    self.strings_Strumming_Count = 2
                case (2,let y,let x) where y >= string4Temp || x >= string4Temp:
                    self.stringHit(4)
                    self.strings_Strumming_Count = 3
                case (3,let y,let x) where y >= string3Temp || x >= string3Temp:
                    self.stringHit(3)
                    self.strings_Strumming_Count = 4
                case (4,let y,let x) where y >= string2Temp || x >= string2Temp:
                    self.stringHit(2)
                    self.strings_Strumming_Count = 5
                case (5,let y,let x) where y >= string1Temp || x >= string1Temp:
                    self.stringHit(1)
                    self.hitString_State = "0"
                    self.stateMachine_Core_GyroY_StartAngle_Z = Float(self.gyroAngle_Roll)
                    self.stateMachine_Core_GyroX_StartAngle_Z = Float(self.gyroAngle_Pitch)
                default:()
                }
            }
            else{
                self.stateMachine_Core_GyroY_StartAngle_Z = Float(self.gyroAngle_Roll)
                self.stateMachine_Core_GyroX_StartAngle_Z = Float(self.gyroAngle_Pitch)
            }
            
            if temp != self.strings_Strumming_Count{
                print(strings_Strumming_Count)
            }
            
        }
        
        
        //        else if ( self.gyroY <= -8  && self.gyroAngle_Roll <= 150 &&
        //            self.stateMachine_Core_GyroY_StartAngle_Z > 150)
        //        {
        //            self.hitString_State = "strum_down_Y"
        //            self.strings_Strumming_Count = 0
        //            print("strumn downwards")
        //        }
        //        else if ( self.gyroX <= -8  && self.gyroAngle_Pitch <= 150 &&
        //            self.stateMachine_Core_GyroX_StartAngle_Z > 150)
        //        {
        //            self.hitString_State = "strum_down_X"
        //            self.strings_Strumming_Count = 0
        //            print("strumn downwards")
        //        }
        //            // Strum Upward
        //        else if ( self.gyroY >= 8  && self.gyroAngle_Roll >= 30 &&
        //            self.stateMachine_Core_GyroY_StartAngle_Z < 30)
        //        {
        //            self.hitString_State = "strum_up_Y"
        //            self.strings_Strumming_Count = 0
        //            print("strumn upwards")
        //        }
        //        else if ( self.gyroX >= 8  && self.gyroAngle_Pitch >= 30 &&
        //            self.stateMachine_Core_GyroX_StartAngle_Z < 30)
        //        {
        //            self.hitString_State = "strum_up_X"
        //            self.strings_Strumming_Count = 0
        //            print("strumn upwards")
        //        }
        
    }
    
    //    func strings_StrummingHandler()->Void{
    //
    //        if self.strings_Strumming_Direction != 0{
    //
    //            if self.strings_Strumming_Count < 7 &&
    //                NSDate().timeIntervalSince1970*1000 > self.strings_Strumming_Time + self.strings_Strumming_Interval {
    //
    //                var stringToPlay:Int = 0
    //                self.strings_Strumming_Count = self.strings_Strumming_Count + 1
    //                if self.strings_Strumming_Direction > 0{ stringToPlay = self.strings_Strumming_Count }
    //                if self.strings_Strumming_Direction < 0{ stringToPlay = 7 - self.strings_Strumming_Count }
    //
    //                let generator = UIImpactFeedbackGenerator(style: .heavy)
    //                generator.impactOccurred()
    //                if 6 >= stringToPlay && stringToPlay >= 1 {
    //                    self.stringHit(stringToPlay)
    //                }
    //
    //            }
    //            if self.strings_Strumming_Count >= 7 { self.strings_Strumming_Direction = 0; self.strings_Strumming_Count = 0 }
    //        }
    //
    //    }
    
}

public func > (left: Float?, right: Float?) -> Bool {
    return (right?.isLess(than: left!))!
}

public func < (left: Float?, right: Float?) -> Bool {
    return (left?.isLess(than: right!))!
}

public func >= (left: Float?, right: Float?) -> Bool {
    return (right?.isLessThanOrEqualTo(left!))!
}

public func <= (left: Float?, right: Float?) -> Bool {
    return (left?.isLessThanOrEqualTo(right!))!
}
