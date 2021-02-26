//
//  ChordsSequenceCollectionViewCell.swift
//  AVAudioUnitSamplerFrobs
//
//  Created by Kwok Ching Fung on 16/6/2018.
//  Copyright © 2018 Gene De Lisa. All rights reserved.
//

import UIKit
import RealmSwift

//protocol ChordsSequenceCollectionViewCellDelegate: class {
//    func delete(cell: ChordsSequenceCollectionViewCell)
//    
//    //useless?
//    func showNumber(cell: ChordsSequenceCollectionViewCell)
//}

class ChordsSequenceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var chordSequenceCollectionView: UICollectionView!
    
    @IBOutlet weak var chordLabel: UILabel!
    
    @IBOutlet weak var chordNumberLabel: UILabel!
    
//    @IBOutlet weak var deleteButtonBackgroundView: UIVisualEffectView!
//
//    weak var delegate: ChordsSequenceCollectionViewCellDelegate?
//
//    var labelName: String! {
//        didSet {
//            deleteButtonBackgroundView.layer.cornerRadius = deleteButtonBackgroundView.bounds.width / 2.0
//            deleteButtonBackgroundView.layer.masksToBounds = true
//            deleteButtonBackgroundView.isHidden = true
//        }
//    }
//
//    @IBAction func deleteButtonDidTap(_ sender: Any) {
//        delegate?.delete(cell: self)
//
//        if let id = UserDefaults.standard.object(forKey: "currentSongID") as? Int{
//            realm = try! Realm()
//            //print(select)
//            let song = realm.object(ofType: Song.self, forPrimaryKey: id)
//            currentSong = song
//
//            if (currentSong) != nil{ //
//                newChordsCount = currentSong.chords.count
//                print("newChordsCount: ", newChordsCount)
//            }
//
//            if let chordSequenceSelectedIndexPathrow = UserDefaults.standard.object(forKey: "chordSequenceSelectedIndexPath") as? Int {
//                chordSequenceSelectedIndexPathrow2 = chordSequenceSelectedIndexPathrow
//            }
//
//            if currentSong.chords.count > 0 {
//                for i in 0...currentSong.chords.count-1 {
//                    print(currentSong.chords[i])
//                }
//            }
//        }
//    }
//
//    var realm: Realm!
//
//    var currentSong: Song!
//    var newChordsCount: Int = 0
//    var chordSequenceSelectedIndexPathrow2: Int = 0
//
//    var baseTriadBass: UInt8!
//    var chordType: String!
//    var ext: String!
//    var bass: String!
//
//    var bassNotes : [String: UInt8] = ["E": 40,
//                                       "F": 41,
//                                       "F#/Gb": 42,
//                                       "G": 43,
//                                       "G#/Ab": 44,
//                                       "A": 45,
//                                       "A#/Bb": 46,
//                                       "B": 47,
//                                       "C": 48,
//                                       "C#/Db": 49,
//                                       "D": 50,
//                                       "D#/Eb": 51,
//                                       ]
}
