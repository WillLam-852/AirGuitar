//
//  SongsViewController.swift
//  AVAudioUnitSamplerFrobs
//
//  Created by Kwok Ching Fung on 13/6/2018.
//  Copyright © 2018 Gene De Lisa. All rights reserved.
//

import UIKit
import RealmSwift

class SongsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var guitar: Guitar!
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == sectionSequenceCollectionView{
            return CGSize(width: 109*sectionSequenceCollectionViewCellWidthScale, height: 50)
        }
        else if collectionView == chordSequenceCollectionView {
            return CGSize(width: 109, height: 50)
        }
        else if collectionView == PresetCollectionView {
            return CGSize(width: PresetCollectionView.frame.width/4, height: 50)
        }
        
        print("Cannot see cell because the size is set to 0 here")
        return CGSize(width: 0, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sectionSequenceCollectionView{
            if currentSongSectionSequence != nil {
                return currentSongSectionSequence.count + 1
            }
            else{
                return 0
            }
        }
        else if collectionView == chordSequenceCollectionView {
            if currentSongSectionChordSequence != nil {
                return currentSongSectionChordSequence.count + 1
            }
            else{
                return 0
            }
        }
        else if collectionView == PresetCollectionView {
            return currentSongPresetChords.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sectionSequenceCollectionView {   //new
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath) as! SectionsSequenceCollectionViewCell
            
            
            //set sectionLabel
            //last cell, display "add section"
            if indexPath.row == currentSongSectionSequence.count {
                cell.sectionLabel.text = "Add Section"
            }
            //other cells, display section name
            else{
                let label = cell.sectionLabel
                
                label!.translatesAutoresizingMaskIntoConstraints = false
                
                label!.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
                label!.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
                cell.sectionLabel.text = currentSongSectionSequence[indexPath.row].title
            }
            //highlight cell
            cell.layer.borderWidth = 2.0
            if (sectionSequenceSelectedIndexPath) != nil {
                if indexPath == sectionSequenceSelectedIndexPath{
                    cell.layer.borderColor = UIColor.green.cgColor
                    if #available(iOS 10.0, *) {
                        let generator = UISelectionFeedbackGenerator()
                        generator.selectionChanged()
                    } else {
                        // Fallback on earlier versions
                    }
                }else{
                    cell.layer.borderColor = UIColor.black.cgColor
                }
            }
            return cell
        }
        if collectionView == chordSequenceCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chordCell", for: indexPath) as! ChordsSequenceCollectionViewCell
            
            
            
            ////set chordLabel
    //        let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 40))
    //        label.textColor = UIColor.black
    //        label.textAlignment = .center
            let font:UIFont? = UIFont(name: "Helvetica", size:15)
            let fontSuper:UIFont? = UIFont(name: "Helvetica", size:12)
            var text = ""
            var attString:NSMutableAttributedString = NSMutableAttributedString(string: "", attributes: [.font:font!])
            collectionView.backgroundColor = UIColor.clear
            
//            cell.delegate = self
            if indexPath != nil {
                print("currentSongSectionChordSequence:")
                print(currentSongSectionChordSequence)
                if indexPath.row == currentSongSectionChordSequence.count {
                    text = "+"
                    attString = NSMutableAttributedString(string: text, attributes: [.font:font!])
                }
                else{
                    let chord = currentSongSectionChordSequence[indexPath.row]
                    
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
                    
                    attString.setAttributes([.font:fontSuper!,.baselineOffset:10], range: NSRange(location:(baseTriadBass + chordType).count,length:ext.count))


                }
            }
            cell.chordLabel.attributedText = attString
            
            
            //set chordNumberLabel
            if indexPath.row != currentSongSectionChordSequence.count {
                cell.chordNumberLabel.text = String(Int(indexPath[1])+1)
            } else {
                cell.chordNumberLabel.text = ""
            }
            
            
            //highlight chord
            cell.layer.borderWidth = 2.0
            if (chordSequenceSelectedIndexPath) != nil {  // 
                if indexPath == chordSequenceSelectedIndexPath{
                    cell.layer.borderColor = UIColor.cyan.cgColor
//                    cell.deleteButtonBackgroundView.isHidden = false
                    if #available(iOS 10.0, *) {
                        let generator = UISelectionFeedbackGenerator()
                        generator.selectionChanged()
                    } else {
                        // Fallback on earlier versions
                    }
                }else{
                    cell.layer.borderColor = UIColor.black.cgColor
//                    cell.deleteButtonBackgroundView.isHidden = true
                }
            }
            return cell
        }
        else if collectionView == PresetCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "presetCell", for: indexPath) as! PresetCollectionViewCell
            
            //        let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 40))
            //        label.textColor = UIColor.black
            //        label.textAlignment = .center
            let font:UIFont? = UIFont(name: "Helvetica", size:15)
            let fontSuper:UIFont? = UIFont(name: "Helvetica", size:12)
            var text = ""
            var attString:NSMutableAttributedString = NSMutableAttributedString(string: "", attributes: [.font:font!])
            PresetCollectionView.backgroundColor = UIColor.clear
        
            let chord =  currentSongPresetChords[indexPath.row]
            
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
            
            attString.setAttributes([.font:fontSuper!,.baselineOffset:10], range: NSRange(location:(baseTriadBass + chordType).count,length:ext.count))
            
            cell.chordLabel.attributedText = attString
            cell.layer.borderWidth = 3.0
            let chordPresetLabelLower = ChordPresetLabel.frame.origin.y + ChordPresetLabel.frame.height
            cell.frame.size.width = self.PresetCollectionView.frame.size.width * 0.24
            cell.frame.size.height = self.PresetCollectionView.frame.size.height * 0.45
            
            if PresetSelectedIndexPath != nil {
                if indexPath == PresetSelectedIndexPath{
                    cell.layer.borderColor = UIColor.yellow.cgColor
                    if #available(iOS 10.0, *) {
                        let generator = UISelectionFeedbackGenerator()
                        generator.selectionChanged()
                    } else {
                        // Fallback on earlier versions
                    }
                }else{
                    cell.layer.borderColor = UIColor.black.cgColor
                }
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //sectionSequenceCollectionView
        if collectionView == sectionSequenceCollectionView{
            var addSection = false
            var needToReloadDataSectionSequenceCollectionView = true
            //if add new section
            if indexPath.row == (currentSongSectionSequence.count){
                addSection = true
                
                let section = Section()
                
                section.title = ""
                
                try! realm.write {
                    currentSongSectionSequence.append(section)
                }
                
                sectionSequenceSelectedIndexPath = indexPath
                currentSongSelectedSection = currentSongSectionSequence[sectionSequenceSelectedIndexPath.row]
                renameSection()
            }
            //if new chord is selected
            else if indexPath != sectionSequenceSelectedIndexPath {
                sectionSequenceSelectedIndexPath = indexPath
                currentSongSelectedSection = currentSongSectionSequence[sectionSequenceSelectedIndexPath.row]
                currentSongSectionChordSequence = currentSongSectionSequence[indexPath.row].chordSequence
            }
            //else if the previously selected chord is selected again
            else{
                needToReloadDataSectionSequenceCollectionView = false
                currentSelectedCell = collectionView.cellForItem(at: indexPath)
                currentSelectedCell.becomeFirstResponder()
                
                // Tell the menu controller the first responder's frame and its super view
                UIMenuController.shared.setTargetRect(currentSelectedCell.frame, in: currentSelectedCell.superview!)
                
                // Animate the menu onto view
                UIMenuController.shared.setMenuVisible(true, animated: true)
            }
            
            if needToReloadDataSectionSequenceCollectionView{
                sectionSequenceCollectionView.reloadData()
            }
            
            //automatically scroll chordSequenceCollectionView to the right if needed
            if (addSection){
                sectionSequenceCollectionView.scrollToItem(at: IndexPath(row: indexPath.row+1, section: indexPath.section) , at: .right, animated: false)
            }
            
        }
        //chordSequenceCollectionView
        else if collectionView == chordSequenceCollectionView {
            var addChord = false
            var needToReloadDataChordsSequenceCollectionView = true
            //if new cell is selected
            if indexPath != chordSequenceSelectedIndexPath {
                PresetSelectedIndexPath.row = -1
                PresetCollectionView.reloadData()
                chordSequenceSelectedIndexPath = indexPath
            }
            //else if the previously selected chord is selected again
            else{
                needToReloadDataChordsSequenceCollectionView = false
                currentSelectedCell = collectionView.cellForItem(at: indexPath)
                currentSelectedCell.becomeFirstResponder()
                
                // Tell the menu controller the first responder's frame and its super view
                UIMenuController.shared.setTargetRect(currentSelectedCell.frame, in: currentSelectedCell.superview!)
                
                // Animate the menu onto view
                UIMenuController.shared.setMenuVisible(true, animated: true)
            }
            //if add new chord
            if indexPath.row == (currentSongSectionChordSequence.count){
                addChord = true
                let chord = Chord()
                chord.baseTriadBass = "C"
                chord.chordType = "Maj"
                chord.ext = "None"
                chord.bass = "None"

                try! realm.write {
                    currentSongSectionChordSequence.append(chord)
                }
                chordSequenceSelectedIndexPath = indexPath
            }
            
            UserDefaults.standard.set(chordSequenceSelectedIndexPath.row, forKey: "chordSequenceSelectedIndexPath")
            
            if needToReloadDataChordsSequenceCollectionView{
                chordSequenceCollectionView.reloadData()
            }
            
            let chord = currentSongSectionChordSequence[chordSequenceSelectedIndexPath.row]
            
            //switch chord for guitar sound
            guitar.switchChord(chord: chord)
            
            //set customize chord picker view selection
            baseTriadBassPicker.selectRow(baseTriadBassOptions.index(of: chord.baseTriadBass)!, inComponent: 0, animated: true)
            chordTypePicker.selectRow(chordTypeOptions.index(of: chord.chordType)!, inComponent: 0, animated: true)
            extensionPicker.selectRow(extensionOptions.index(of: chord.ext)!, inComponent: 0, animated: true)
            bassPicker.selectRow(bassOptions.index(of: chord.bass)!, inComponent: 0, animated: true)

            //automatically scroll chordSequenceCollectionView to the right if needed
            if (addChord){
                chordSequenceCollectionView.scrollToItem(at: IndexPath(row: indexPath.row+1, section: indexPath.section) , at: .right, animated: false)
            }
        }
        //PresetCollectionView
        else if collectionView == PresetCollectionView {
            PresetSelectedIndexPath = indexPath
            let chord = currentSongPresetChords[PresetSelectedIndexPath.row]
            //switch chord for guitar sound
            guitar.switchChord(chord: chord)
            
            if chordSequenceSelectedIndexPath != nil && chordSequenceSelectedIndexPath.row > -1{
                try! self.realm.write {
                    currentSongSectionChordSequence[chordSequenceSelectedIndexPath.row] = chord.copy() as! Chord
                }
                chordSequenceCollectionView.reloadData()
            }
            
            baseTriadBassPicker.selectRow(baseTriadBassOptions.index(of: chord.baseTriadBass)!, inComponent: 0, animated: true)
            chordTypePicker.selectRow(chordTypeOptions.index(of: chord.chordType)!, inComponent: 0, animated: true)
            extensionPicker.selectRow(extensionOptions.index(of: chord.ext)!, inComponent: 0, animated: true)
            bassPicker.selectRow(bassOptions.index(of: chord.bass)!, inComponent: 0, animated: true)

            
            UserDefaults.standard.set(PresetSelectedIndexPath.row, forKey: "PresetSelectedIndexPath")
            PresetCollectionView.reloadData()
        }
        
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        //for section
        if action == #selector(editSectionTapped) || action == #selector(renameSection) || action == #selector(deleteSectionTapped){
            return currentSelectedCell.superview == sectionSequenceCollectionView && !isEditingSection
        }
        //for chord
        else if action == #selector(saveChordTapped) || action == #selector(deleteChordTapped){
            return currentSelectedCell.superview == chordSequenceCollectionView
        }

        return super.canPerformAction(action, withSender: sender)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = songs[indexPath.row].title
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == songSelectTableVIew {
            currentSong = songs[indexPath.row]
            currentSongSectionSequence = currentSong.sectionSequence
            currentSongPresetChords = currentSong.preset?.chords
            PresetCollectionView.reloadData()
            sectionSequenceCollectionView.reloadData()
//            let range = Range(uncheckedBounds: (0, chordSequenceCollectionView.numberOfSections))
//            let indexSet = IndexSet(integersIn: range)
//            chordSequenceCollectionView.reloadSections(indexSet)
            
            let string = currentSong.title
            let font = UIFont.systemFont(ofSize: 24)
            let width = string.size(OfFont: font).width
            selectSongButton.setTitle(string,for: .normal)
            selectSongButton.frame.size = CGSize(width: width, height: selectSongButton.frame.height)
            
            UserDefaults.standard.set(currentSong.id, forKey: "currentSongID")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //delete song
        if editingStyle == .delete {
            let song = songs[indexPath.row]
            
            //if deleting song which is the currently selected song
            if song == currentSong {
                UserDefaults.standard.set(-1, forKey: "currentSongID")
                let string = "Select Song"
                let font = UIFont.systemFont(ofSize: 24)
                let width = string.size(OfFont: font).width
                selectSongButton.setTitle(string,for: .normal)
                selectSongButton.frame.size = CGSize(width: width, height: selectSongButton.frame.height)
                selectSongButton.isHidden = false
                
                currentSongSectionChordSequence = nil
                chordSequenceCollectionView.reloadData()
                currentSongSectionSequence = nil
                sectionSequenceCollectionView.reloadData()
                
            }
            
            try! self.realm.write {
                self.realm.delete(song)
            }
            
            if songs.count == 0 {
                createASongLabel.isHidden = false
            }
            else{
                createASongLabel.isHidden = true
            }

            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func addSong(_ sender: UIButton) {
        animateButton(sender)
        let alertVC = UIAlertController(title: "Add New Song", message: "Song Title:", preferredStyle: .alert)
        alertVC.addTextField(configurationHandler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            let myTextField = (alertVC.textFields?.first)! as UITextField

            let song = Song()
            song.id = self.incrementSongID()
            song.title = myTextField.text!
            song.preset = (self.Presets[0].copy() as! Preset)

            try! self.realm.write {
                self.realm.add(song)
                self.songSelectTableVIew.insertRows(at: [IndexPath(row: self.songs.count - 1, section: 0)], with: .automatic)
            }
            
            self.createASongLabel.isHidden = true
            
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(addAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func incrementSongID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Song.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func incrementPresetID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Preset.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countrows : Int = self.baseTriadBassOptions.count
        if pickerView == chordTypePicker {
            countrows = self.chordTypeOptions.count
        }
        else if pickerView == extensionPicker {
            countrows = self.extensionOptions.count
        }
        else if pickerView == bassPicker {
            countrows = self.bassOptions.count
        }
        return countrows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == baseTriadBassPicker {
            let titleRow = baseTriadBassOptions[row]
            return titleRow
        }
        else if pickerView == chordTypePicker {
            let titleRow = chordTypeOptions[row]
            return titleRow
        }
        else if pickerView == extensionPicker {
            let titleRow = extensionOptions[row]
            return titleRow
        }
        else if pickerView == bassPicker {
            let titleRow = bassOptions[row]
            return titleRow
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var chordSequenceChord : Chord!
        var presetChord : Chord!
        if (chordSequenceSelectedIndexPath != nil) && chordSequenceSelectedIndexPath.row > -1 {
            chordSequenceChord = (currentSongSectionChordSequence[chordSequenceSelectedIndexPath.row])
        }
        if (PresetSelectedIndexPath != nil) && PresetSelectedIndexPath.row > -1 {
            presetChord = currentSongPresetChords[PresetSelectedIndexPath.row]
        }

        if pickerView == baseTriadBassPicker {
            baseTriadBass = bassNotes[baseTriadBassOptions[row]]
            if chordSequenceChord != nil {
                try! realm.write {
                    chordSequenceChord.baseTriadBass = baseTriadBassOptions[row]
                }
            }
            if presetChord != nil {
                try! realm.write {
                    presetChord.baseTriadBass = baseTriadBassOptions[row]
                }
            }
        }
        else if pickerView == chordTypePicker {
            chordType = chordTypeOptions[row]
            if chordSequenceChord != nil {
                try! realm.write {
                    chordSequenceChord.chordType = chordType
                }
            }
            if presetChord != nil {
                try! realm.write {
                    presetChord.chordType = chordType
                }
            }
        }
        else if pickerView == extensionPicker {
            ext = extensionOptions[row]
            if chordSequenceChord != nil {
                try! realm.write {
                    chordSequenceChord.ext = ext
                }
            }
            if presetChord != nil {
                try! realm.write {
                    presetChord.ext = ext
                }
            }
        }
        else if pickerView == bassPicker {
            bass = bassOptions[row]
            if chordSequenceChord != nil {
                try! realm.write {
                    chordSequenceChord.bass = bass
                }
            }
            if presetChord != nil {
                try! realm.write {
                    presetChord.bass = bass
                }
            }
        }
        
        if chordSequenceChord != nil {
            chordSequenceCollectionView.reloadData()

        }
        if presetChord != nil {
            PresetCollectionView.reloadData()
        }
    }
    
//    //new
//    @IBAction func settingsOnClick(_ sender: UIButton) {
//        animateButton(sender)
//        UIView.animate(withDuration: 0.1) {
//            if self.settingsView.transform == .identity {
//                self.settingsView.transform = CGAffineTransform(translationX: 0, y: self.settingsView.frame.height )
//                //                self.settingsView.transform = CGAffineTransform(translationX: 0, y: self.settingsView.frame.height + UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.size.height)!)
//            }
//            else{
//                self.settingsView.transform = .identity
//            }
//        }
//        self.customizeChordStack.transform = .identity
//        self.songSelectContainer.transform = .identity
//    }
    
//    @IBAction func onClickCustomizeChord(_ sender: UIButton) {
//        animateButton(sender)
//        print(self.customizeChordStack.frame.height)  //new
//        UIView.animate(withDuration: 0.1) {
//            if self.customizeChordStack.transform == .identity {
//                //self.customizeChordStack.transform = CGAffineTransform(translationX: 0, y: self.customizeChordStack.frame.height + UIApplication.shared.statusBarFrame.height)  //new
//                self.customizeChordStack.transform = CGAffineTransform(translationX: 0, y: self.customizeChordStack.frame.height )
//            }
//            else{
//                self.customizeChordStack.transform = .identity
//            }
//        }
////        self.customizeChordButton.isEnabled = false
////        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        self.settingsView.transform = .identity
//        self.songSelectContainer.transform = .identity
//    }

    @IBAction func onClickTranspose(_ sender: UIButton) {
//        animateButton(sender)
        var semitones = 0
        if(sender == transposeDownButton){
            semitones = -1
        }
        if(sender == transposeUpButton){
            semitones = 1
        }
        try! realm.write {
            for chord in currentSongPresetChords {
                transposeChord(chord: chord, semitones: semitones)
            }

            if (currentSong != nil){
                for section in currentSongSectionSequence {
                    for chord in section.chordSequence{
                        transposeChord(chord: chord, semitones: semitones)
                    }
                }
            }
        }
        
        PresetCollectionView.reloadData()
        chordSequenceCollectionView.reloadData()
    }
    
    func transposeChord(chord: Chord, semitones: Int){
        if (chord.bass != "None"){
            print("bass: " + chord.bass)
            chord.bass = transposeNote(note: chord.bass, semitones: semitones)
        }
        chord.baseTriadBass = transposeNote(note: chord.baseTriadBass, semitones: semitones)
    }
    
    func transposeNote(note: String, semitones: Int)->String{
        let originalIndex = baseTriadBassOptions.index(of: note)
        var newIndex = originalIndex! + semitones
        
        if (newIndex >= 12){
            newIndex = newIndex - 12
        }
        if (newIndex < 0){
            newIndex = newIndex + 12
        }
        return baseTriadBassOptions[newIndex]
    }
        
    
    
    @IBAction func selectSong(_ sender: UIButton) {
        animateButton(sender)
        //open select song stack view
        if songSelectContainer.transform == .identity {
//            let screenHeight = view.frame.size.height
            UIView.animate(withDuration: 0.1) {
                self.songSelectContainer.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
                self.createAndSelectASongLabel.isHidden = true
                self.selectASongLabel.isHidden = true

                if self.songs.count == 0 {
                    self.createASongLabel.isHidden = false
                }
                else{
                    self.createASongLabel.isHidden = true
                }
                //                self.songSelectContainer.transform = CGAffineTransform(translationX: 0, y: screenHeight + (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.shared.statusBarFrame.height + self.songSelectContainer.frame.size.height)
            }
        }
        //close select song stack view
        else{
            UIView.animate(withDuration: 0.1) {
                self.songSelectContainer.transform = .identity
                self.createASongLabel.isHidden = true
                
                //display select song reminder boxes
                let id = UserDefaults.standard.object(forKey: "currentSongID") as? Int
                if ((id != nil) && (id != -1)) {
                    //if there is a song currently selected
                    self.createAndSelectASongLabel.isHidden = true
                    self.selectASongLabel.isHidden = true
                }
                else{
                    //if no song is currently selected
                    if self.songs.count == 0{
                        self.createAndSelectASongLabel.isHidden = false
                        self.selectASongLabel.isHidden = true
                    }
                    else{
                        self.createAndSelectASongLabel.isHidden = true
                        self.selectASongLabel.isHidden = false
                    }
                }
                
            }
        }
        self.settingsView.transform = .identity
        self.customizeChordStack.transform = .identity
    }
    
    @IBAction func doneEditingSection(_ sender: UIButton) {
        print("done")
        isEditingSection = false
        
        self.sectionSequenceCollectionView.clipsToBounds = true
        self.sectionSequenceCollectionView.isScrollEnabled = true
        chordSequenceSelectedIndexPath.row = -1
        currentSelectedCell.resignFirstResponder()
        currentSelectedCell = nil
        currentSongSectionChordSequence = nil
        UIView.animate(withDuration: 0.1, animations: {
            let cell = self.currentEditingSectionCell!

            cell.frame = self.originalCGRectOfSelectedSectionSequenceCell

            //change border color to green
            cell.layer.borderColor = UIColor.green.cgColor
            
            //change background color to clear
            cell.backgroundColor = UIColor.clear
            
            //change position of sectionLabel
            let label = cell.sectionLabel
            label!.translatesAutoresizingMaskIntoConstraints = false
            label!.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            label!.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            
            label?.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
            label?.textAlignment = NSTextAlignment.center
//            self.sectionSequenceCollectionView.bringSubviewToFront(self.currentSelectedCell)
            //                        self.view.bringSubviewToFront(self.chordSequenceCollectionView)
            
            self.doneEditingSectionButton.isHidden = true
            self.chordSequenceCollectionView.isHidden = true
        })
        
        self.view.sendSubviewToBack(self.chordSequenceCollectionView)

    }
    
    var realm: Realm!
    
    var songs: Results<Song> {
        get {
            return realm.objects(Song.self)
        }
    }
    
    var Presets: Results<Preset> {
        get {
            return realm.objects(Preset.self)
        }
    }
    var sectionSequenceSelectedIndexPath: IndexPath!
    var chordSequenceSelectedIndexPath: IndexPath!
    var PresetSelectedIndexPath: IndexPath!
    
    var currentSong : Song!
    var currentSongTitle : String!
    var currentSongSectionSequence : List<Section>!
    var currentSongSelectedSection : Section!
    var currentSongUniqueSections : List<Section>!
    var currentSongSectionChordSequence : List<Chord>!
    var currentSongPresetChords : List<Chord>!

    
//    var songI : [Song] = []
    
    var baseTriadBass: UInt8!
    var chordType: String!
    var ext: String!
    var bass: String!
    
    var prevIndexPathRow = 0
    
    var firstDrag = false
    
    @IBOutlet weak var selectASongLabel: UILabel!
    
    @IBOutlet weak var createASongLabel: UILabel!
    
    @IBOutlet weak var createAndSelectASongLabel: UILabel!
    
    @IBOutlet weak var settingsView: UIView!
    
    @IBOutlet weak var SongsButtonDummy: UIBarButtonItem!
    
    @IBOutlet weak var customizeChordButton: UIButton!
//    @IBOutlet weak var customizeChordButton: UIBarButtonItem!
    
    @IBOutlet weak var customizeChordStack: UIView!
    
    @IBOutlet weak var customizeChordView: UIView!
    
    @IBOutlet weak var customizeChordLabel: UILabel!
    
    @IBOutlet weak var transposeDownButton: UIButton!
    
    @IBOutlet weak var transposeUpButton: UIButton!
    
    @IBOutlet weak var songSelectContainer: UIView!
    
    
    @IBOutlet weak var selectSongButton: UIButton!
    
    var originalCGRectOfSelectedSectionSequenceCell: CGRect!
    
    var isEditingSection: Bool!
    
    var interactingWithValidCell: Bool! = true
    
    var bassNotes : [String: UInt8] = ["E": 40,
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
    
    @IBOutlet weak var baseTriadBassPicker: UIPickerView!
    
    @IBOutlet weak var chordTypePicker: UIPickerView!
    
    @IBOutlet weak var extensionPicker: UIPickerView!
    
    @IBOutlet weak var bassPicker: UIPickerView!
    
    @IBOutlet weak var chordSequenceCollectionView: UICollectionView!
    
    @IBOutlet weak var sectionSequenceCollectionView: UICollectionView!
    var sectionSequenceCollectionViewCellWidthScale: CGFloat = 1
    var scaleStart: CGFloat = 1
    var widthStart: CGFloat = 109 // get size of a cell to calulate a difference when scale will change
    var originalContentOffset: CGFloat = 0
    var originalNumberOfCellsToOffset: CGFloat = 0
    @IBOutlet weak var PresetCollectionView: UICollectionView!
    
    @IBOutlet weak var songSelectTableVIew: UITableView!
    
    @IBOutlet weak var customizeChordTitle: UIView!
    
    @IBOutlet weak var ChordPresetLabel: UILabel!
    
    @IBOutlet weak var doneEditingSectionButton: UIButton!
    
    var baseTriadBassOptions = ["C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B"]
    
    var chordTypeOptions = ["Maj", "Min", "Dim", "Aug", "Sus2", "Sus4", "5"]
    
    var extensionOptions = ["None", "6", "7", "Maj7", "Add9", "9", "11", "13"]
    
    var bassOptions = ["None", "C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B"]

    @IBOutlet weak var settingsButton: UIButton!
    
    var sectionSequenceLongPressGestureRecognizer: UILongPressGestureRecognizer!
    var chordSequenceLongPressGestureRecognizer: UILongPressGestureRecognizer!
    
    var sectionSequencePinchGestureRecognizer: UIPinchGestureRecognizer!

    var currentSelectedCell: UICollectionViewCell!
    var currentEditingSectionCell: SectionsSequenceCollectionViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guitar = Guitar.sharedInstance

        realm = try! Realm()
        
        if Presets.count==0{
            var preset = Preset()
//            preset.id = self.incrementPresetID()
            preset.chords.append(Chord(baseTriadBass: "E", chordType: "Min", ext: "None", bass: "None"))
            preset.chords.append(Chord(baseTriadBass: "A", chordType: "Min", ext: "None", bass: "None"))
            preset.chords.append(Chord(baseTriadBass: "D", chordType: "Min", ext: "None", bass: "None"))
            preset.chords.append(Chord(baseTriadBass: "G", chordType: "Maj", ext: "None", bass: "None"))
            preset.chords.append(Chord(baseTriadBass: "C", chordType: "Maj", ext: "None", bass: "None"))
            preset.chords.append(Chord(baseTriadBass: "F", chordType: "Maj", ext: "None", bass: "None"))
            preset.chords.append(Chord(baseTriadBass: "A#/Bb", chordType: "Maj", ext: "None", bass: "None"))
            preset.chords.append(Chord(baseTriadBass: "B", chordType: "Dim", ext: "None", bass: "None"))

            try! realm.write {
                self.realm.add(preset)
            }
            
            currentSongPresetChords = preset.chords
        }
        else {
            currentSongPresetChords = Presets[0].chords
        }
        
        let screenHeight = view.frame.size.height
        let screenWidth = view.frame.size.width  //new
        
        settingsView.layer.borderWidth = 1
        settingsView.layer.borderColor = UIColor.lightGray.cgColor
        let settingsViewHeight = Double(settingsView.frame.size.height)
        let settingsViewWidth = Double(settingsView.frame.size.width)
        settingsView.frame = CGRect(x: Double(screenWidth) - settingsViewWidth, y: -settingsViewHeight, width: settingsViewWidth, height: settingsViewHeight)
        
        customizeChordView.layer.borderWidth = 1
        customizeChordView.layer.borderColor = UIColor.lightGray.cgColor

        chordSequenceSelectedIndexPath = IndexPath(row: -1, section: 0)
        PresetSelectedIndexPath = IndexPath(row: -1, section: 0)
        
        let height = CGFloat(120)
        baseTriadBassPicker.frame = CGRect(x: baseTriadBassPicker.frame.minX, y: CGFloat(customizeChordView.frame.height/2) - CGFloat(height/2), width: baseTriadBassPicker.frame.width, height: height)
        chordTypePicker.frame = CGRect(x: chordTypePicker.frame.minX, y: CGFloat(customizeChordView.frame.height/2) - CGFloat(height/2), width: chordTypePicker.frame.width, height: height)
        extensionPicker.frame = CGRect(x: extensionPicker.frame.minX, y: CGFloat(customizeChordView.frame.height/2) - CGFloat(height/2), width: extensionPicker.frame.width, height: height)
        bassPicker.frame = CGRect(x: bassPicker.frame.minX, y: CGFloat(customizeChordView.frame.height/2) - CGFloat(height/2), width: bassPicker.frame.width, height: height)

//        songSelectTableVIew.frame.size = CGSize(width: songSelectTableVIew.frame.width, height: screenHeight)
        songSelectContainer.frame = CGRect(x: 0, y: -(screenHeight-75), width: screenWidth, height: screenHeight-75)  //new
        
        let customizeChordStackHeight = customizeChordStack.frame.height  //new
        customizeChordStack.frame = CGRect(x: 0, y: -customizeChordStackHeight, width: screenWidth, height: customizeChordStackHeight)  //new
        customizeChordTitle.frame = CGRect(x: 0, y: 70, width: screenWidth, height: 40) //new
        customizeChordView.frame = CGRect(x: 0, y: 110, width: screenWidth, height: customizeChordView.frame.height) //new
        customizeChordStack.layer.borderWidth = 1.0
        customizeChordStack.layer.borderColor = UIColor.black.cgColor
        
        print(customizeChordTitle)  //new
        print(customizeChordView)  //new
        print(customizeChordStackHeight)  //new
        print(customizeChordTitle.frame.size)
        print(customizeChordLabel.frame.size)

        //if user has previously selected a song
        if let id = UserDefaults.standard.object(forKey: "currentSongID") as? Int {
            //if that song still exist
            if id > -1 {
                let song = realm.object(ofType: Song.self, forPrimaryKey: id)
                currentSong = song
                currentSongSectionSequence = currentSong.sectionSequence
                currentSongUniqueSections = currentSong.uniqueSections
                currentSongPresetChords = currentSong.preset?.chords
                
                let string = currentSong.title
                let font = UIFont.systemFont(ofSize: 24)
                let width = string.size(OfFont: font).width
                selectSongButton.setTitle(string,for: .normal)
                selectSongButton.frame.size = CGSize(width: width, height: selectSongButton.frame.height)
                selectSongButton.isHidden = false
                
                createAndSelectASongLabel.isHidden = true
                selectASongLabel.isHidden = true
            }
            else{
                let string = "Select Song"
                let font = UIFont.systemFont(ofSize: 24)
                let width = string.size(OfFont: font).width
                selectSongButton.setTitle(string,for: .normal)
                selectSongButton.frame.size = CGSize(width: width, height: selectSongButton.frame.height)
                selectSongButton.isHidden = false
                
                if songs.count == 0{
                    createAndSelectASongLabel.isHidden = false
                    selectASongLabel.isHidden = true
                }
                else{
                    createAndSelectASongLabel.isHidden = true
                    selectASongLabel.isHidden = false
                }
            }
        }
            
        //user has not previously selected a song
        else{
            let string = "Select Song"
            let font = UIFont.systemFont(ofSize: 24)
            let width = string.size(OfFont: font).width
            selectSongButton.setTitle(string,for: .normal)
            selectSongButton.frame.size = CGSize(width: width, height: selectSongButton.frame.height)
            selectSongButton.isHidden = false
            if songs.count == 0{
                createAndSelectASongLabel.isHidden = false
                selectASongLabel.isHidden = true
            }
            else{
                createAndSelectASongLabel.isHidden = true
                selectASongLabel.isHidden = false
            }
        }
        //add LongPressGestureRecognizer to enable moving section positions in sectionSequenceCollectionView
        sectionSequenceLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(sectionSequenceCollectionViewLongPressRecognized(_:)))
        sectionSequenceLongPressGestureRecognizer.minimumPressDuration = 0.2
        sectionSequenceCollectionView!.addGestureRecognizer(sectionSequenceLongPressGestureRecognizer)
        
        //add LongPressGestureRecognizer to enable moving chord positions in chordSequenceCollectionView
        chordSequenceLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chordSequenceCollectionViewLongPressRecognized(_:)))
        chordSequenceLongPressGestureRecognizer.minimumPressDuration = 0.2
        chordSequenceCollectionView!.addGestureRecognizer(chordSequenceLongPressGestureRecognizer)
        
        //add PinchGestureRecognizer to enable zooming in sectionSequenceCollectionView
        sectionSequencePinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(sectionSequenceCollectionViewPinchRecognized(_:)))
        sectionSequenceCollectionView!.addGestureRecognizer(sectionSequencePinchGestureRecognizer)
        
        // Set up the shared UIMenuController
        let editSectionMenuItem = UIMenuItem(title: "Edit", action: #selector(editSectionTapped))
        let renameSectionMenuItem = UIMenuItem(title: "Rename", action: #selector(renameSection))
        let duplicateSectionMenuItem = UIMenuItem(title: "Duplicate", action: #selector(duplicateSection))
        let deleteSectionMenuItem = UIMenuItem(title: "Delete", action: #selector(deleteSectionTapped))
//        let saveChordMenuItem = UIMenuItem(title: "Save", action: #selector(saveChordTapped))
        let deleteChordMenuItem = UIMenuItem(title: "Delete", action: #selector(deleteChordTapped))
        UIMenuController.shared.menuItems = [editSectionMenuItem, renameSectionMenuItem, duplicateSectionMenuItem, deleteSectionMenuItem, deleteChordMenuItem]
        
        isEditingSection = false
    }
    
    @objc func editSectionTapped() {
        print("edit section")
        isEditingSection = true
        currentSongSectionChordSequence = currentSongSectionSequence[sectionSequenceSelectedIndexPath.row].chordSequence
        
        self.sectionSequenceCollectionView.clipsToBounds = false
        self.sectionSequenceCollectionView.isScrollEnabled = false
        originalCGRectOfSelectedSectionSequenceCell = currentSelectedCell.frame
        currentEditingSectionCell = currentSelectedCell as? SectionsSequenceCollectionViewCell
        
        //pre animation, set initial position of views
        self.chordSequenceCollectionView.transform = CGAffineTransform(translationX: currentSelectedCell.frame.origin.x - self.chordSequenceCollectionView.frame.size.width/2 + currentSelectedCell.frame.size.width/2, y: 0).scaledBy(x: 0.1, y: 1)
        chordSequenceCollectionView.reloadData()
        
        print(self.sectionSequenceCollectionView.frame.origin.y)
        
        self.doneEditingSectionButton.frame.origin = CGPoint(x: self.sectionSequenceCollectionView.frame.origin.x + self.currentEditingSectionCell.frame.origin.x + self.currentEditingSectionCell.frame.size.width - self.doneEditingSectionButton.frame.size.width - 10, y: self.sectionSequenceCollectionView.frame.origin.y)
        
        let xOffset = self.sectionSequenceCollectionView.contentOffset.x

        //animation
        UIView.animate(withDuration: 0.1, delay: 0.0,
                       options: UIView.AnimationOptions.curveLinear,
                       animations: {
                        
                        //change size, position
                        self.currentSelectedCell.frame = CGRect(x: -10 + xOffset, y: -25, width: ((self.currentSelectedCell.superview?.frame.size.width)! + 20), height: ((self.currentSelectedCell.superview?.frame.size.height)!+40))
                        
                        //change border color to black
                        self.currentSelectedCell.layer.borderColor = UIColor.black.cgColor
                        
                        //change background color to white
                        self.currentSelectedCell.backgroundColor = UIColor.white
                        
                        //change position of sectionLabel
                        let cell = self.currentSelectedCell as! SectionsSequenceCollectionViewCell
                        let label = cell.sectionLabel
                        
                        label!.translatesAutoresizingMaskIntoConstraints = true
                        for c in label!.constraints {
                            print(c)
                        }
                        label!.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = false
                        label!.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = false
                        
                        label?.frame = CGRect(x: 5, y: 5, width: cell.sectionLabel.frame.size.width, height: 20)
                        label?.textAlignment = NSTextAlignment.left
                        label?.frame.size.width = cell.sectionLabel.intrinsicContentSize.width
                        self.sectionSequenceCollectionView.bringSubviewToFront(self.currentSelectedCell)
//                        self.view.bringSubviewToFront(self.chordSequenceCollectionView)
                        
                        //display chordSequenceCollectionView
                        self.chordSequenceCollectionView.isHidden = false
                        self.chordSequenceCollectionView.transform = CGAffineTransform.identity
                        
                        //display doneEditingSectionButton
                        self.doneEditingSectionButton.isHidden = false
                        self.doneEditingSectionButton.frame.origin = CGPoint(x: self.chordSequenceCollectionView.frame.origin.x + self.chordSequenceCollectionView.frame.size.width - self.doneEditingSectionButton.frame.size.width - 10, y: self.chordSequenceCollectionView.frame.origin.y - 25)
                }
        )
//        self.view.bringSubviewToFront(self.chordSequenceCollectionView)
        self.view.insertSubview(self.chordSequenceCollectionView, aboveSubview: self.sectionSequenceCollectionView)
        // ...
        // This would be a good place to optionally resign
        // responsiveView's first responder status if you need to
        //        responsiveView.resignFirstResponder()
        
    }
    
    @objc func renameSection() {
        print("rename section")
        let alertVC = UIAlertController(title: "Rename Section", message: "", preferredStyle: .alert)
        alertVC.addTextField(configurationHandler: {(textField) in
            textField.text = self.currentSongSelectedSection.title
            textField.placeholder = "new section"
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (UIAlertAction) in
            let myTextField = (alertVC.textFields?.first)! as UITextField
            
            // 1. delete the chord from our data source
            if myTextField.text! == "" {
                try! self.realm.write {
                    self.currentSongSectionSequence.remove(at: self.sectionSequenceSelectedIndexPath.row)
                }
            }
            
            //reload section sequence collection view
            self.sectionSequenceCollectionView.reloadData()
        }

        
        let addAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            let myTextField = (alertVC.textFields?.first)! as UITextField
            
            print("text:")
            print(myTextField.text!)
            var title = myTextField.text!
            
            if title == "" {
                title = "untitled"
            }
            try! self.realm.write {
                self.currentSongSelectedSection.title = title
            }
            self.sectionSequenceCollectionView.reloadData()
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(addAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc func duplicateSection() {
        print("duplicate section")
        // 1. delete the chord from our data source
        print(currentSongSelectedSection)
        let section = currentSongSelectedSection!.copy() as! Section
        print(1)

        try! realm.write {
            currentSongSectionSequence.insert(section, at: sectionSequenceSelectedIndexPath.row)
        }
        print(2)

        //no animation ----------
        sectionSequenceSelectedIndexPath.row = sectionSequenceSelectedIndexPath.row + 1
        print(3)

        currentSongSelectedSection = currentSongSectionSequence[sectionSequenceSelectedIndexPath.row]
        sectionSequenceCollectionView.reloadData()
    }
    
    @objc func deleteSectionTapped() {
        print("delete section")
        // 1. delete the chord from our data source
        try! realm.write {
            currentSongSectionSequence.remove(at: sectionSequenceSelectedIndexPath.row)
        }
        //no animation ----------
        if sectionSequenceSelectedIndexPath.row == currentSongSectionSequence.count {
            sectionSequenceSelectedIndexPath.row = currentSongSectionSequence.count - 1
        }
        if (sectionSequenceSelectedIndexPath.row > -1){
            currentSongSelectedSection = currentSongSectionSequence[sectionSequenceSelectedIndexPath.row]
        }
        else{
            currentSongSelectedSection = nil
        }
        sectionSequenceCollectionView.reloadData()
    }
    
    @objc func saveChordTapped() {
        print("save tapped")
        // ...
        // This would be a good place to optionally resign
        // responsiveView's first responder status if you need to
        //        responsiveView.resignFirstResponder()
    }
    
    @objc func deleteChordTapped() {
        print("delete tapped")
        // 1. delete the chord from our data source
        try! realm.write {
            currentSongSectionChordSequence.remove(at: chordSequenceSelectedIndexPath.row)
        }
        //no animation ----------
        if chordSequenceSelectedIndexPath.row == currentSongSectionChordSequence.count {
            chordSequenceSelectedIndexPath.row = currentSongSectionChordSequence.count - 1
        }
        chordSequenceCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func unwind(_ sender: UIButton) {
        animateButton(sender)
        performSegue(withIdentifier: "unwindToGuitar", sender: self)
    }
    
    //for longpress gesture recognizer
    var newSequenceIndexPath: IndexPath?
    var orginialIndexPath: IndexPath?
    var SequencePanPoint: CGPoint?
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("Starting Index: \(sourceIndexPath)")
        print("Ending Index: \(destinationIndexPath)")
    }
    
    @objc func sectionSequenceCollectionViewLongPressRecognized(_ recognizer: UILongPressGestureRecognizer) {
        UIMenuController.shared.setMenuVisible(false, animated: true)
        
        let location = recognizer.location(in: sectionSequenceCollectionView)
        let selectedIndexPath = sectionSequenceCollectionView?.indexPathForItem(at: location)
        
        switch recognizer.state {
        case UIGestureRecognizer.State.began:
            sectionSequenceCollectionView.isPagingEnabled = true
            sectionSequenceSelectedIndexPath = selectedIndexPath
            sectionSequenceCollectionView.reloadData()
            firstDrag = true
            
        case UIGestureRecognizer.State.changed:
            if firstDrag {
                interactingWithValidCell = selectedIndexPath?.row != nil && (selectedIndexPath?.row != currentSongSectionSequence.count)
                
                guard interactingWithValidCell else { return }
                
                guard let selectedIndexPath = selectedIndexPath else { return }
                
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.sectionSequenceCollectionView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//                    self.sectionSequenceCollectionView?.alpha = 0.9
//                })
                sectionSequenceCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
                SequencePanPoint = location
                orginialIndexPath = selectedIndexPath
                newSequenceIndexPath = selectedIndexPath
                
                firstDrag = false
            }
            else{
                guard interactingWithValidCell else { return }

                guard let selectedIndexPath = selectedIndexPath else { return }
                
                guard selectedIndexPath.row != currentSongSectionSequence.count else { return }
                
                sectionSequenceCollectionView.updateInteractiveMovementTargetPosition(recognizer.location(in: recognizer.view!))

                self.SequencePanPoint = location

//                sectionSequenceCollectionView?.moveItem(at: newSequenceIndexPath!, to: selectedIndexPath)
                newSequenceIndexPath = selectedIndexPath
            }

        case UIGestureRecognizer.State.ended:
            sectionSequenceCollectionView.isPagingEnabled = false

            guard interactingWithValidCell else { return }
            
            sectionSequenceCollectionView.endInteractiveMovement()

            UIView.animate(withDuration: 0.2, animations: {
                self.sectionSequenceCollectionView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.sectionSequenceCollectionView?.alpha = 1.0
            })

            try! realm.write {
                if orginialIndexPath != nil && newSequenceIndexPath != nil{
                    if orginialIndexPath![1] < newSequenceIndexPath![1] {
                        let temp = currentSongSectionSequence[orginialIndexPath![1]]
                        for index in orginialIndexPath![1]...newSequenceIndexPath![1]-1 {
                            currentSongSectionSequence[index] = currentSongSectionSequence[index+1]
                        }
                        currentSongSectionSequence[newSequenceIndexPath![1]] = temp
                    }
                    else if orginialIndexPath![1] > newSequenceIndexPath![1] {
                        let temp = currentSongSectionSequence[orginialIndexPath![1]]
                        for index in stride(from: orginialIndexPath![1], to: newSequenceIndexPath![1], by: -1) {
                            currentSongSectionSequence[index] = currentSongSectionSequence[index-1]
                        }
                        currentSongSectionSequence[newSequenceIndexPath![1]] = temp
                    }
                }
            }
            sectionSequenceSelectedIndexPath = newSequenceIndexPath


        default:
            sectionSequenceCollectionView.cancelInteractiveMovement()
            sectionSequenceCollectionView.isPagingEnabled = false
            self.newSequenceIndexPath = nil
            self.SequencePanPoint = nil
        }
    }
    
    @objc func chordSequenceCollectionViewLongPressRecognized(_ recognizer: UILongPressGestureRecognizer) {
        UIMenuController.shared.setMenuVisible(false, animated: true)
        
        let location = recognizer.location(in: chordSequenceCollectionView)
        let selectedIndexPath = chordSequenceCollectionView?.indexPathForItem(at: location)
        
        switch recognizer.state {
            
        case UIGestureRecognizer.State.began:
            chordSequenceCollectionView.isPagingEnabled = true
            chordSequenceSelectedIndexPath = selectedIndexPath
            chordSequenceCollectionView.reloadData()
            firstDrag = true
            
        case UIGestureRecognizer.State.changed:
            if firstDrag {
                interactingWithValidCell = selectedIndexPath?.row != nil && (selectedIndexPath?.row != currentSongSectionChordSequence.count)
                
                guard interactingWithValidCell else { return }
                
                guard let selectedIndexPath = selectedIndexPath else { return }
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.chordSequenceCollectionView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    self.chordSequenceCollectionView?.alpha = 0.9
                })
                
                chordSequenceCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
                
                SequencePanPoint = location
                orginialIndexPath = selectedIndexPath
                newSequenceIndexPath = selectedIndexPath
                
                firstDrag = false
            }
            else{
                guard interactingWithValidCell else { return }

                guard let selectedIndexPath = selectedIndexPath else { return }
                
                guard selectedIndexPath.row != currentSongSectionChordSequence.count else { return }

                
                chordSequenceCollectionView.updateInteractiveMovementTargetPosition(recognizer.location(in: recognizer.view!))
                self.SequencePanPoint = location
                
//                chordSequenceCollectionView?.moveItem(at: newSequenceIndexPath!, to: selectedIndexPath)
                newSequenceIndexPath = selectedIndexPath
            }
            
        case UIGestureRecognizer.State.ended:
            chordSequenceCollectionView.isPagingEnabled = false

            guard interactingWithValidCell else { return }

            chordSequenceCollectionView.endInteractiveMovement()
            
            UIView.animate(withDuration: 0.2, animations: {
                self.chordSequenceCollectionView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.chordSequenceCollectionView?.alpha = 1.0
            })

            try! realm.write {
                if orginialIndexPath != nil && newSequenceIndexPath != nil{
                    if orginialIndexPath![1] < newSequenceIndexPath![1] {
                        let temp = currentSongSectionSequence[sectionSequenceSelectedIndexPath.row].chordSequence[orginialIndexPath![1]]
                        for index in orginialIndexPath![1]...newSequenceIndexPath![1]-1 {
                            currentSongSectionSequence[sectionSequenceSelectedIndexPath.row].chordSequence[index] = currentSongSectionSequence[sectionSequenceSelectedIndexPath.row].chordSequence[index+1]
                        }
                        currentSongSectionSequence[sectionSequenceSelectedIndexPath.row].chordSequence[newSequenceIndexPath![1]] = temp
                    }
                    else if orginialIndexPath![1] > newSequenceIndexPath![1] {
                        let temp = currentSongSectionSequence[sectionSequenceSelectedIndexPath.row].chordSequence[orginialIndexPath![1]]
                        for index in stride(from: orginialIndexPath![1], to: newSequenceIndexPath![1], by: -1) {
                            currentSongSectionSequence[sectionSequenceSelectedIndexPath.row].chordSequence[index] = currentSongSectionSequence[sectionSequenceSelectedIndexPath.row].chordSequence[index-1]
                        }
                        currentSongSectionSequence[sectionSequenceSelectedIndexPath.row].chordSequence[newSequenceIndexPath![1]] = temp
                    }
                }
            }
            chordSequenceSelectedIndexPath = newSequenceIndexPath
            
        default:
            chordSequenceCollectionView.cancelInteractiveMovement()
            chordSequenceCollectionView.isPagingEnabled = false
            self.newSequenceIndexPath = nil
            self.SequencePanPoint = nil
        }
    }
    
    @objc func sectionSequenceCollectionViewPinchRecognized(_ recognizer: UIPinchGestureRecognizer) {
        let scaleValue: CGFloat = recognizer.scale
        if (recognizer.state == .began) {
            scaleStart = sectionSequenceCollectionViewCellWidthScale // remember current scale
            widthStart = sectionSequenceCollectionView.visibleCells[0].bounds.width // get size of a cell to calulate a difference when scale will change
            originalContentOffset = sectionSequenceCollectionView.contentOffset.x // remember original content offset
            
            //for zooming at the middle of the pinch
            originalNumberOfCellsToOffset = (recognizer.location(ofTouch: 0, in: sectionSequenceCollectionView).x + recognizer.location(ofTouch: 1, in: sectionSequenceCollectionView).x) / (widthStart * 2)
            
            //for zooming at the middle of the screen
//            originalNumberOfCellsToOffset =  (originalContentOffset + (self.view.frame.size.width/2) - 20) / widthStart
        }
        else if (recognizer.state == .changed) {
            
            let newScale = max(0.5, recognizer.scale*scaleStart) // normalize scale. give 0.5, 1, 1.5, 2
            
            sectionSequenceCollectionViewCellWidthScale = newScale // global struct
            
            //let ZoomIn = (newScale > scaleStart)
            
            sectionSequenceCollectionView.collectionViewLayout.invalidateLayout() // invalidate layout in order to redisplay cell with updated scale
            
            let scaleRatio = newScale / scaleStart
            var newContentOffset = CGFloat(0)
            
            let offsetDiffForEachCell: CGFloat = (scaleRatio * widthStart) - widthStart
            
            newContentOffset = max(0,(offsetDiffForEachCell)*originalNumberOfCellsToOffset + (originalContentOffset))
            
//            print("pinch " + String(Int(scaleValue)) + " " + String(Int(recognizer.location(ofTouch: 0, in: sectionSequenceCollectionView).x)) + " " + String(Int(newContentOffset)) + " " + String(Int(originalNumberOfCellOffset)))

            print(sectionSequenceCollectionView.numberOfItems(inSection: 0))
            let numberOfCells = sectionSequenceCollectionView.numberOfItems(inSection: 0)
            let cellWidth = sectionSequenceCollectionView.visibleCells[0].bounds.width
            if (CGFloat(numberOfCells)*cellWidth <= sectionSequenceCollectionView.frame.size.width){
                sectionSequenceCollectionView.setContentOffset(CGPoint(x: 0 ,y: 0), animated: false)
            }
            else {
                sectionSequenceCollectionView.setContentOffset(CGPoint(x: newContentOffset ,y: 0), animated: false)
            }
        }
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
    
    @IBAction func settingsButtonOnClick(_ sender: UIButton) {
        animateButton(sender)
        
        UIView.animate(withDuration: 0.1) {
            if self.settingsView.transform == .identity {
                self.settingsView.transform = CGAffineTransform(translationX: 0, y: self.settingsView.frame.height )
            }
            else{
                self.settingsView.transform = .identity
            }
        }
        self.customizeChordStack.transform = .identity
        self.songSelectContainer.transform = .identity
    }
    
    @IBAction func customizeChordButtonOnClick(_ sender: UIButton) {
        animateButton(customizeChordButton)

        UIView.animate(withDuration: 0.1) {
            if self.customizeChordStack.transform == .identity {
                self.customizeChordStack.transform = CGAffineTransform(translationX: 0, y: self.customizeChordStack.frame.height )
            }
            else{
                self.customizeChordStack.transform = .identity
            }
        }
        self.settingsView.transform = .identity
        self.songSelectContainer.transform = .identity
    }
    
}

extension SongsViewController {
    fileprivate func cellForRow(at indexPath: IndexPath) -> ChordsSequenceCollectionViewCell {
        return chordSequenceCollectionView?.cellForItem(at: indexPath) as! ChordsSequenceCollectionViewCell
    }
}

//extension SongsViewController : ChordsSequenceCollectionViewCellDelegate {
//    func delete(cell: ChordsSequenceCollectionViewCell) {
//        if let indexPath = chordSequenceCollectionView?.indexPath(for: cell) {
//            // 1. delete the chord from our data source
//            try! realm.write {
//                currentSongSectionChordSequence.remove(at: chordSequenceSelectedIndexPath.row)
//            }
//            //no animation ----------
//            if chordSequenceSelectedIndexPath.row == currentSongSectionChordSequence.count {
//                chordSequenceSelectedIndexPath.row = currentSongSectionChordSequence.count - 1
//            }
//            chordSequenceCollectionView.reloadData()
//
//            // 2. delete the chord cell at that index path from the collection view
////            no animation BUT DOESN'T WORK  ----------
////            self.chordSequenceCollectionView?.performBatchUpdates({
////                UIView.setAnimationsEnabled(false)
////                self.chordSequenceCollectionView?.deleteItems(at: [indexPath])
////            }, completion: { [unowned self] (_) in
////                UIView.setAnimationsEnabled(true)
////            })
//
////          with animation BUT DOESN'T WORK ----------
////            chordSequenceCollectionView?.deleteItems(at: [indexPath])
//
//            //with animation ----------
////            self.chordSequenceCollectionView?.performBatchUpdates({
////                self.chordSequenceCollectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
////            }, completion: nil)
//        }
//    }
//
//    //useless?
//    func showNumber(cell: ChordsSequenceCollectionViewCell) {
//        if let indexPath = chordSequenceCollectionView?.indexPath(for: cell) {
//            cell.chordNumberLabel.text = String(Int(indexPath[1])+1)
//        }
//    }
//}

extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
}

extension UICollectionViewCell {
    override open var canBecomeFirstResponder: Bool {
        return true
    }
}
