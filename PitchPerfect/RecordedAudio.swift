//
//  RecordedAudio.swift
//  PitchPerfect
//
//  This is to represent the filepath and title of the voice recording to be stored on the disk
//
//  Created by SUN Ka Meng Isaac on 30/6/15.
//  Copyright (c) 2015 SUN Ka Meng Isaac. All rights reserved.
//

import Foundation

class RecordedAudio {
    var title: String!
    var filePathUrl: NSURL!
    
    init(title: String!, filePathUrl: NSURL) {
        self.title = title
        self.filePathUrl = filePathUrl
    }
}