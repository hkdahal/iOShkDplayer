//
//  File.swift
//  hkPlayer
//
//  Created by Hari Dahal on 9/4/16.
//  Copyright © 2016 Hari Dahal. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Song{
    var coverArt: UIImage
    var title: String
    var fileName: String
    var Details = [String]()
    
    init(file: String){
        self.coverArt = UIImage(named: "pause")!
        self.title = file
        self.fileName = file
        self.Details = ["", ""]
    }
    
}

class Playlist{
    var name: String
    var songs = [String: [Song]]()
    
    init(name: String, songs: [Song]){
        self.name = name
        self.songs[self.name] = songs
    }
}

class Stuff{
    var thePlayer: AVAudioPlayer?
}
