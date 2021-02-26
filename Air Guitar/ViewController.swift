//
//  ViewController.swift
//
//

import UIKit
import RealmSwift
import CoreMotion
import MediaPlayer


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    var guitar: Guitar!
    
    @IBOutlet weak var switchChordButton: UIButton!
    @IBOutlet weak var switchChordTapLabel: UIImageView!
    @IBOutlet weak var topBarButton: UIButton!
    @IBOutlet weak var topBarBG: UIImageView!
    @IBOutlet weak var topBarContentsView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var chordEditorButton: UIButton!
    
    var chordIndex : Int = 0
    
    var mute : Bool = false

    @IBAction func calibrate(_ sender: UIButton) {
        guitar.calibrate()
        animateButton(sender)
    }
    
    @IBOutlet weak var songTitle: UILabel!
    
    var bassNotes : [String: UInt8]!

    var touchPoint = CGPoint()
    
    //for testing swiping strings(buttons) on the screen.  There is no string now.//////////
    //var myPanGesture : UIPanGestureRecognizer!
    
    var myTapGesture : SingleTouchDownGestureRecognizer!

    var rotationAngle: CGFloat!
    let chordSequencePickerViewOptionWidth : CGFloat = 80
    let chordSequencePickerViewOptionHeight : CGFloat = 80
    @IBOutlet weak var chordSequencePickerView: UIPickerView!
    
    
    var lastActiveString: UIButton?
    
    var currentSong : Song!
    
//    e.g. A->B->A
    var currentSongSectionSequence : List<Section>!
    
//    e.g. (A) C->Am->F->G -> (B) Dm->G->Dm->G -> (A) C->Am->F->G
    var currentSongChordSequence : Array<Chord>!

    var destination : SongsViewController!
    
    var realm: Realm!
    
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var calibrateButton: UIButton!

    @IBOutlet weak var enableMuteView: UIView!
    @IBOutlet weak var enableUpStrokeView: UIView!
    
    
    @IBOutlet weak var enableMuteLabel: UILabel!
    @IBAction func enableMuteSwitch(_ sender: UISwitch) {
        guitar.setEnableMute(enable: sender.isOn)
        if sender.isOn {
            self.enableMuteLabel.text = "Mute: Enabled"
        } else {
            self.enableMuteLabel.text = "Mute: Disabled"
        }
    }
    
    @IBOutlet weak var enableUpStrokeLabel: UILabel!
    @IBAction func enableUpStrokeSwitch(_ sender: UISwitch) {
        guitar.setEnableUpStroke(enable: sender.isOn)
        if sender.isOn {
            self.enableUpStrokeLabel.text = "Up Stroke: Enabled"
        } else {
            self.enableUpStrokeLabel.text = "Up Stroke: Disabled"
        }
    }
    
    @IBOutlet weak var enablePluckLabel: UILabel!
    @IBAction func enablePluckSwitch(_ sender: UISwitch) {
        guitar.setEnablePluck(enable: sender.isOn)

        if sender.isOn {
            self.enablePluckLabel.text = "Pluck: Enabled"
        } else {
            self.enablePluckLabel.text = "Pluck: Disabled"
        }
    }
    
    @IBAction func openTopBar(_ sender: UIButton) {
        animateButton(sender)
        UIView.animate(withDuration: 0.1) {
            if self.topBarBG.transform == .identity {
                self.topBarBG.transform = CGAffineTransform(translationX: 0, y: self.topBarBG.frame.size.height-110 )
                self.topBarContentsView.transform = CGAffineTransform(translationX: 0, y: 80 )
            }
            else{
                self.settingsView.transform = .identity
                self.topBarBG.transform = .identity
                self.topBarContentsView.transform = .identity
            }
        }
    }
    
    @IBAction func chordEditorOnClick(_ sender: UIButton) {
        animateButton(sender)
        self.settingsView.transform = .identity
    }
    
    @IBAction func settingsButtonOnClick(_ sender: UIButton) {
        animateButton(sender)
        UIView.animate(withDuration: 0.1) {
            if self.settingsView.transform == .identity {
                self.settingsView.transform = CGAffineTransform(translationX: 0, y: self.settingsView.frame.height )
                //                self.settingsView.transform = CGAffineTransform(translationX: 0, y: self.settingsView.frame.height + UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.size.height)!)
            }
            else{
                self.settingsView.transform = .identity
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (currentSong) != nil{ //
            return currentSongChordSequence.count
        }
        else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return chordSequencePickerViewOptionWidth
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return chordSequencePickerViewOptionHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        self.chordSequencePickerView.backgroundColor = UIColor.clear
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: chordSequencePickerViewOptionWidth, height: chordSequencePickerViewOptionHeight)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: chordSequencePickerViewOptionWidth, height: chordSequencePickerViewOptionHeight)
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        let indexLabel = UILabel()
        indexLabel.frame = CGRect(x: 0, y: chordSequencePickerViewOptionHeight - 15, width: 30, height: 15)
        indexLabel.textAlignment = .center
        indexLabel.textColor = UIColor.white
        
        let font:UIFont? = UIFont(name: "Helvetica", size:15)
        let fontSuper:UIFont? = UIFont(name: "Helvetica", size:12)
        var text = ""
        var attString:NSMutableAttributedString = NSMutableAttributedString(string: "", attributes: [.font:font!])
        var attStringLabel:NSMutableAttributedString = NSMutableAttributedString(string: "", attributes: [.font:font!])
        
        let chord = currentSongChordSequence[row]
        
        var baseTriadBass = chord.baseTriadBass
        var chordType = chord.chordType
        var ext = chord.ext
        var bass = chord.bass
        
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
        attStringLabel = NSMutableAttributedString(string: String(row+1), attributes: [.font:font!])
        
        attString.setAttributes([.font:fontSuper!,.baselineOffset:10], range: NSRange(location:(baseTriadBass + chordType).count,length:ext.count))
        //attStringLabel.setAttributes([.font:fontSuper!,.baselineOffset:10], range: NSRange(location:(baseTriadBass + chordType).count,length:ext.count))
        
        label.attributedText = attString
        indexLabel.attributedText = attStringLabel
        view.addSubview(label)
        view.addSubview(indexLabel)
        
        //view.transform = CGAffineTransform(rotationAngle: 90*(.pi/180))
        
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if ((currentSong) != nil && currentSongChordSequence.count != 0) { //
            chordIndex = row
            guitar.switchChord(chord: currentSongChordSequence[row])
        }
        else{
            let eMaj = Chord(baseTriadBass: "E", chordType: "Maj", ext: "None", bass: "None")
            guitar.switchChord(chord: eMaj)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guitar = Guitar.sharedInstance
        guitar.play()
        
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
        
        let screenHeight = Double(view.frame.size.height)
        let screenWidth = Double(view.frame.size.width)
        let chordSequencePickerViewWidth = Double(view.frame.size.width / 8)
        let chordSequencePickerViewHeight = Double(view.frame.size.height * 4 / 5)
        
        //rotationAngle = -90 * (.pi/180)
        //chordSequencePickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        chordSequencePickerView.frame = CGRect(x: 15, y: screenHeight/6, width: chordSequencePickerViewWidth, height: chordSequencePickerViewHeight)
        
//        switchChordButton.frame = CGRect(x: screenWidth/5, y: screenHeight/4, width: screenWidth*4/5, height: screenHeight*3/5)

        
        //new
        calibrateButton.layer.borderWidth = 1
        calibrateButton.layer.borderColor = UIColor.lightGray.cgColor
        settingsView.layer.borderWidth = 1
        settingsView.layer.borderColor = UIColor.lightGray.cgColor
        let settingsViewHeight = Double(settingsView.frame.size.height)
        let settingsViewWidth = Double(settingsView.frame.size.width)
        settingsView.frame = CGRect(x: screenWidth - settingsViewWidth, y: -settingsViewHeight, width: settingsViewWidth, height: settingsViewHeight)
        
        topBarContentsView.frame = CGRect(x: 0, y: -80, width: screenWidth, height: 80)
        topBarBG.frame = CGRect(x: 0, y: -Double(topBarBG.frame.size.height), width: screenWidth, height: Double(topBarBG.frame.size.height))
//        Double(topBarButton.frame.size.width) + Double(topBarButton.frame.origin.x) + 20
        songTitle.frame = CGRect(x: screenWidth*0.25, y: 10, width: screenWidth*0.5, height: 50)
        songTitle.adjustsFontSizeToFitWidth = true
        settingsButton.frame = CGRect(x: screenWidth-115, y: 10, width: 50, height: 50)
        chordEditorButton.frame = CGRect(x: screenWidth-55, y: 10, width: 65, height: 50)

        allowOtherOutputSource()  //bluetooth speaker
        
        //myPanGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panDetected(sender:)))
        //myPanGesture.maximumNumberOfTouches = 1
        //view.addGestureRecognizer(myPanGesture)
        //settings button add gesture recognizer

        
        myTapGesture = SingleTouchDownGestureRecognizer(target: self, action: #selector(ViewController.tapDetected(sender:)))
//        myTapGesture.numberOfTapsRequired = 1
        switchChordButton.addGestureRecognizer(myTapGesture)
//        view.addGestureRecognizer(myTapGesture)
        
//        MoDetect.setSensitivity(130)
//        MoDetect.upPickLock(!self.enableUpStroke)
//        MoDetect.motionDetectloop()
        
        realm = try! Realm()
    }
    
    override func viewDidAppear(_ animated: Bool){        
        if let id = UserDefaults.standard.object(forKey: "currentSongID") as? Int{
            if id > -1 {
                let song = realm.object(ofType: Song.self, forPrimaryKey: id)
                currentSong = song
                currentSongSectionSequence = currentSong.sectionSequence
                currentSongChordSequence = Array(currentSongSectionSequence.map({$0.chordSequence}).joined())
                chordSequencePickerView.reloadComponent(0)
                songTitle.text = song?.title
                
                if currentSongSectionSequence.count > 0 {
                chordSequencePickerView.selectRow(0, inComponent: 0, animated: true)
                chordSequencePickerView.delegate?.pickerView?(chordSequencePickerView, didSelectRow: 0, inComponent: 0)
                }
            }
            else{
                songTitle.text = "Please select song"
            }
        }
        else{
            songTitle.text = "Please select song"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tapDetected(sender : UITapGestureRecognizer) {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        } else {
            // Fallback on earlier versions
        }
        UIImageView.animate(withDuration: 0.2,
        animations: {
            self.switchChordTapLabel.transform = CGAffineTransform(scaleX: 0.975, y: 0.96) },
        completion: { finish in
            UIImageView.animate(withDuration: 0.2, animations: {
                    self.switchChordTapLabel.transform = CGAffineTransform.identity})
        })
        if currentSong != nil {
            chordIndex = chordIndex + 1
            if chordIndex >= currentSongChordSequence.count {
                chordIndex = 0
            }
            chordSequencePickerView.selectRow(chordIndex, inComponent: 0, animated: true)
            self.pickerView(self.chordSequencePickerView, didSelectRow: chordIndex, inComponent: 0)
        }
    }
    
    func allowOtherOutputSource() {
        
        let model = UIDevice.current.model
        
        let session = AVAudioSession()
//        do{
//            try session.setMode(AVAudioSessionModeMeasurement)
//        } catch {
//            print("dsfg")
//        }
        let controller = UIAlertController(title: "Select Output", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        controller.addAction(UIAlertAction(title: model, style: UIAlertAction.Style.default, handler: { action in
            do {
                if #available(iOS 10.0, *) {
                    try session.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord)), mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                } else {
                    // Fallback on earlier versions
                }
            } catch {
                print("AVAudioSession error!")
            }
        }))
        controller.addAction(UIAlertAction(title: "Bluetooth", style: UIAlertAction.Style.default, handler: { action in
            do {
                if #available(iOS 10.0, *) {
                    try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode(rawValue: convertFromAVAudioSessionMode(AVAudioSession.Mode.measurement)), options: AVAudioSession.CategoryOptions.allowBluetooth)
                } else {
                    // Fallback on earlier versions
                }
//                try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.allowBluetooth)
            } catch {
                print("AVAudioSession error!")
            }
        }))
        //presentViewController(controller, animated: true, completion: nil)
    }
    
    func animateButton(_ sender: UIButton){
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        } else {
            // Fallback on earlier versions
        }
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96) },
                       completion: { finish in
                        UIView.animate(withDuration: 0.2,
                                       delay: 0,
                                       options: UIView.AnimationOptions.allowUserInteraction,
                                       animations: {
                                        sender.transform = CGAffineTransform.identity})
        })
    }
    
    
    @IBAction func unwindToGuitar(segue:UIStoryboardSegue) {}
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionMode(_ input: AVAudioSession.Mode) -> String {
	return input.rawValue
}
