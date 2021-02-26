//
//  Sampler.swift
//
//

import Foundation
import AVFoundation

class Sampler {
    
    var engine: AVAudioEngine!
    
    var samplerOpened: AVAudioUnitSampler!
    var samplerMuted: AVAudioUnitSampler!

    init() {
        
        engine = AVAudioEngine()
        
        samplerOpened = AVAudioUnitSampler()
        samplerMuted = AVAudioUnitSampler()
        engine.attach(samplerOpened)
        engine.attach(samplerMuted)
        engine.connect(samplerOpened, to: engine.mainMixerNode, format: nil)
        engine.connect(samplerMuted, to: engine.mainMixerNode, format: nil)
        
        loadSF2PresetIntoSampler(25, 28)
        
        addObservers()
        
        startEngine()
        
        setSessionPlayback()
    }
    
    deinit {
        removeObservers()
    }
    
    
    func playOpened(note: UInt8, velocity: UInt8) {
        samplerOpened.startNote(note, withVelocity: velocity, onChannel: 0)
    }
    
    func stopOpened(note: UInt8) {
        samplerOpened.stopNote(note, onChannel: 0)
    }
    
    func playMuted(note: UInt8, velocity: UInt8) {
        samplerMuted.startNote(note, withVelocity: velocity, onChannel: 0)
    }
    
    func stopMuted(note: UInt8) {
        samplerMuted.stopNote(note, onChannel: 0)
    }
    
    func loadSF2PresetIntoSampler(_ presetOpened: UInt8, _ presetMuted: UInt8) {
        
        guard let bankURL = Bundle.main.url(forResource: "FluidR3 GM2-2", withExtension: "SF2") else {
            print("could not load sound font")
            return
        }
        
        do {
            try self.samplerOpened.loadSoundBankInstrument(at: bankURL,
                                                     program: presetOpened,
                                                     bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB),
                                                     bankLSB: UInt8(kAUSampler_DefaultBankLSB))
            try self.samplerMuted.loadSoundBankInstrument(at: bankURL,
                                                           program: presetMuted,
                                                           bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB),
                                                           bankLSB: UInt8(kAUSampler_DefaultBankLSB))
        } catch {
            print("error loading sound bank instrument")
        }
        
    }
    
    // might be better to do this in the app delegate
    func setSessionPlayback() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            if #available(iOS 10.0, *) {
                try
                    audioSession.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: AVAudioSession.Mode.default,
                                             options: AVAudioSession.CategoryOptions.mixWithOthers)
            } else {
                // Fallback on earlier versions
            }
        } catch {
            print("couldn't set category \(error)")
            return
        }
        
        do {
            try audioSession.setActive(true)
        } catch {
            print("couldn't set category active \(error)")
            return
        }
    }
    
    func startEngine() {
        
        if engine.isRunning {
            print("audio engine already started")
            return
        }
        
        do {
            try engine.start()
            print("audio engine started")
        } catch {
            print("oops \(error)")
            print("could not start audio engine")
        }
    }
    
    // MARK: - Notifications
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Sampler.engineConfigurationChange(_:)),
                                               name: NSNotification.Name.AVAudioEngineConfigurationChange,
                                               object: engine)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Sampler.sessionInterrupted(_:)),
                                               name: AVAudioSession.interruptionNotification,
                                               object: engine)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Sampler.sessionRouteChange(_:)),
                                               name: AVAudioSession.routeChangeNotification,
                                               object: engine)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.AVAudioEngineConfigurationChange,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: AVAudioSession.interruptionNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: AVAudioSession.routeChangeNotification,
                                                  object: nil)
    }
    
    
    // MARK: notification callbacks
    
    @objc
    func engineConfigurationChange(_ notification: Notification) {
        print("engineConfigurationChange")
    }
    
    @objc
    func sessionInterrupted(_ notification: Notification) {
        print("audio session interrupted")
        if let engine = notification.object as? AVAudioEngine {
            engine.stop()
        }
        
        if let userInfo = notification.userInfo as? [String: Any?] {
            if let reason = userInfo[AVAudioSessionInterruptionTypeKey] as? AVAudioSession.InterruptionType {
                switch reason {
                case .began:
                    print("began")
                case .ended:
                    print("ended")
                }
            }
        }
    }
    
    @objc
    func sessionRouteChange(_ notification: Notification) {
        print("sessionRouteChange")
        if let engine = notification.object as? AVAudioEngine {
            engine.stop()
        }
        
        if let userInfo = notification.userInfo as? [String: Any?] {
            
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? AVAudioSession.RouteChangeReason {
                
                print("audio session route change reason \(reason)")
                
                switch reason {
                case .categoryChange: print("CategoryChange")
                case .newDeviceAvailable:print("NewDeviceAvailable")
                case .noSuitableRouteForCategory:print("NoSuitableRouteForCategory")
                case .oldDeviceUnavailable:print("OldDeviceUnavailable")
                case .override: print("Override")
                case .wakeFromSleep:print("WakeFromSleep")
                case .unknown:print("Unknown")
                case .routeConfigurationChange:print("RouteConfigurationChange")
                }
            }
            
            if let previous = userInfo[AVAudioSessionRouteChangePreviousRouteKey] {
                print("audio session route change previous \(String(describing: previous))")
            }
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
