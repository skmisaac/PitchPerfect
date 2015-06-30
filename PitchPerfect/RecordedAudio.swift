//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by SUN Ka Meng Isaac on 30/6/15.
//  Copyright (c) 2015 SUN Ka Meng Isaac. All rights reserved.
//

import Foundation

class RecordedAudio : NSObject {
    var title: String!
    var filePathUrl: NSURL!
    
    init(title: String!, filePathUrl: NSURL) {
        self.title = title
        self.filePathUrl = filePathUrl
    }
}