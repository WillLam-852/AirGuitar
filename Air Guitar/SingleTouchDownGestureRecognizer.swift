//
//  SingleTouchDownGestureRecognizer.swift
//  AVAudioUnitSamplerFrobs
//
//  Created by WillLam on 28/6/2018.
//  Copyright © 2018 Gene De Lisa. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class SingleTouchDownGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == .possible {
            self.state = .recognized
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .failed
        print("touchesMoved")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .failed
    }
}
