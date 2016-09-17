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
    var id: Int
    var Details = [String]()
    
    init(file: String, id: Int, title: String = "None"){
        self.coverArt = UIImage(named: "pause")!
        if title != "None"{
            self.title = title
        }else{
            self.title = file
        }
        self.fileName = file
        self.id = id
        self.Details = ["", ""]
    }
    
}

class Playlist{
    var name: String
    var songs: [Song]
    var id: Int
    var theViews = [String: [UIView]]()
    var playlistCover: UIImage
    //var navBarButtons = [UIButton]()
    //var currentlyPlaying: UILabel
    
    static var myPlayer: AVAudioPlayer{
        get{
            //return Playlist.myPlayer
            return playTheMusic("")
        }
        set{
            //self.myPlayer = AVAudioPlayer()
        }
    }
    
    internal var getMyPlayer: AVAudioPlayer{
        get{
            if songs.count > 0{
                Playlist.myPlayer = Playlist.playTheMusic(songs[0].fileName)
            }
            return Playlist.myPlayer
        }
        set{
            Playlist.myPlayer = Playlist.playTheMusic(songs[0].fileName)
        }
    }
    
    
    init(name: String, songs: [Song], id: Int, imageName: String){
        self.name = name
        self.songs = songs
        self.id = id
        self.playlistCover = UIImage(named: imageName)!
        feedViews()
        
    }
    
    func feedViews(){
        theViews["navBarButtons"] = feedNavBar()
        theViews["sharedCurrent"] = feedSharedCurrent()
    }
    
    func feedNavBar() -> [UIButton]{
        var buttons = [UIButton]()
        let btnNames = ["Home", "Search", "Library", "Playing"]
        for btnName in btnNames{
            let btn = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 50))
            btn.setTitle(btnName, for: UIControlState())
            // btn.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            //self.view.addSubview(btn) // add to view as subview
            buttons.append(btn)
        }
        return buttons
    }
    
    func feedSharedCurrent() -> [UIView]{
        var sharedCurrent = [UIView]()
        sharedCurrent.append(UILabel(frame: CGRect(x: 100, y: 400, width: 100, height: 50)))
        sharedCurrent.append(UIImageView(frame: CGRect(x: 100, y: 400, width: 100, height: 50)))
        sharedCurrent.append(UIImageView(frame: CGRect(x: 100, y: 400, width: 100, height: 50)))
        return sharedCurrent
    }
    
    static func playTheMusic(_ songName: String) -> AVAudioPlayer{
        
        var a_player = AVAudioPlayer()
        var url: URL
        
        if songName.hasPrefix("http"){
            url = URL(string: songName)!
        }else{
            if songName == "Bad Blood"{
                let path = Bundle.main.path(forResource: songName, ofType:"m4a")!
                url = URL(fileURLWithPath: path)
            }else if songName == ""{
                let path = Bundle.main.path(forResource: "Bad Blood", ofType:"m4a")!
                url = URL(fileURLWithPath: path)
            }else{
                let path = Bundle.main.path(forResource: songName, ofType:"mp3")!
                url = URL(fileURLWithPath: path)
            }
        }
        
        //url = NSURL(string: "http://sound6.mp3slash.net/indian/omshantiom/omshantiom01(www.songs.pk).mp3")!
        let myData = try? Data(contentsOf: url)
        
        //let url = NSURL(string: "http://link.songspk.guru/link1/song1.php?songid=7571")!
        
        //let theData = NSData(contentsOfURL: url!)
        do {
            a_player = try AVAudioPlayer(data: myData!)
            //a_player = try AVAudioPlayer(contentsOfURL: url)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.duckOthers )
            
        } catch {
            // couldn't load file :(
        }
        return a_player
    }
    
}

class Category{
    var name: String
    var type: String
    var playlists: [Playlist]?
    var playlist: Playlist?
    
    init(name: String, type: String){
        self.name = name
        self.type = type
    }
    
    func giveData() -> AnyObject{
        
        if self.type == "category"{
            return self.playlists! as AnyObject
        }else{
            return self.playlist!
        }
    }

}

struct MySong{
    var song_link: String
    var title: String
    var id: Int
    var artists: String
}


struct SongDetails{
    var song_obj = [MySong]()
    //var imageLink: String
    //var occassions: String
    //var pricing: String
}

// making ItemDetails JSON extendable
extension SongDetails: JSONDecodable{
    
    init?(JSONList: [[String: AnyObject]]){
        for thing in JSONList{
            
            let song_link = thing["song_link"] as? String
            let title = thing["title"] as? String
            let id = thing["id"] as? Int
            let artists = thing["artists"] as? String
            
            self.song_obj.append(MySong(song_link: song_link!, title: title!, id: id!, artists: artists!))
        }
    }
}








