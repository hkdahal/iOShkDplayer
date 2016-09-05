//
//  PlayerController.swift
//  hkPlayer
//
//  Created by Hari Dahal on 9/4/16.
//  Copyright © 2016 Hari Dahal. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var player: AVAudioPlayer = AVAudioPlayer()
    
    var songs = [Song]()
    
    var current = -1
    
    @IBOutlet weak var songsTable: UITableView!
    
    @IBOutlet weak var coverArtImage: UIImageView!
    
    @IBOutlet weak var musicTitle: UITextView!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBAction func nextButton(sender: AnyObject) {
        if current >= songs.count-1{
            current = 0
            playMusic(songs[current].fileName)
        }else{
            current += 1
            if current > songs.count-1{
                current = 0
            }
            playMusic(songs[current].fileName)
        }
    }
    
    
    @IBAction func prevButton(sender: AnyObject) {
        
        
        if current <= 0{
            current = 0
            playMusic(songs[current].fileName)
        }else{
            current -= 1
            if current < 0{
                current = 0
            }
            playMusic(songs[current-1].fileName)
        }
    }
    
    @IBAction func shuffleButton(sender: AnyObject) {
    }
    @IBAction func playPauseAction(sender: UIButton) {
        if player.playing{
            player.pause()
            playPauseButton.setBackgroundImage(UIImage(named: "play"), forState: UIControlState.Normal)
        }else{
            player.play()
            playPauseButton.setBackgroundImage(UIImage(named: "pause"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func stopButton(sender: UIButton) {
        if player.playing{
            player.stop()
            player.currentTime = 0
            playPauseButton.setBackgroundImage(UIImage(named: "play"), forState: UIControlState.Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedSongs()
        songsTable.rowHeight = CGFloat(integerLiteral: 25)
        songsTable.scrollEnabled = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        //playMusic("Chull")
        playMusic(songs[0].fileName)
    }
    
    func feedSongs(){
        let hindi_songs = ["Raabta", "Tune Jo Na Kaha", "Pee Loon", "Ishq Sufiyana", "Baby Ko Bass Pasand Hai", "Chull"]
        let cool_songs = ["I Took A Pill", "Bad Blood", "Somebody", "Gone Gone", "Geronimo", "Timilai Jun", "Oh My Love"]
        let nepali_songs = ["Siriri", "Allarey Jovan", "Mann", "Mero Maya", "Junkeri", "Kahiley Kahi"]
        let best_songs = ["Desi Romance", "Humko Humi Se Churalo", "I Gotta Feeling", "Kya Yehi Pyar Hai", "Lal Dupatta", "Main Hoon Na", "Main Hoon Naa", "Tumse Milke Dilka Hai"]
        
        switch self.navigationItem.title! {
        case "Hindi":
            feedMe(hindi_songs)
        case "Bipul Chhetri":
            feedMe(nepali_songs)
        case "Cool Songs":
            feedMe(cool_songs)
        default:
            feedMe(best_songs)
        }
    }
    
    func feedMe(songTitles: [String]){
        for st in songTitles{
            let a_song = Song(file: st)
            songs.append(a_song)
        }
    }
    
    func playMusic(songName: String?){
        current += 1
        
        var url: NSURL
        
        if songName == "Bad Blood"{
            let path = NSBundle.mainBundle().pathForResource(songName, ofType:"m4a")!
            url = NSURL(fileURLWithPath: path)
        }else{
            let path = NSBundle.mainBundle().pathForResource(songName, ofType:"mp3")!
            url = NSURL(fileURLWithPath: path)
        }
        
        //let url = NSURL(string: "http://link.songspk.guru/link1/song1.php?songid=7571")!
        
        //let theData = NSData(contentsOfURL: url!)
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            player = sound
            sound.play()
            playPauseButton.setBackgroundImage(UIImage(named: "pause"), forState: UIControlState.Normal)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: AVAudioSessionCategoryOptions.MixWithOthers )
        } catch {
            // couldn't load file :(
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "songCell")
        cell.textLabel?.text = songs[indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let theSong = songs[indexPath.row].title
        playMusic(theSong)
    }
    

}
