//
//  PlayerController.swift
//  hkPlayer
//
//  Created by Hari Dahal on 9/4/16.
//  Copyright © 2016 Hari Dahal. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {
    
    var player: AVAudioPlayer = AVAudioPlayer()
    
    var songs = [Song]()
    
    var current = 0
    
    var counter = 0
    
    var current_song = "..."
    
    @IBOutlet weak var songsTable: UITableView!
    
    @IBOutlet weak var coverArtImage: UIImageView!
    
    @IBOutlet weak var musicTitle: UITextView!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var musicSlider: UISlider!
    
    @IBOutlet weak var endTime: UITextView!
    
    @IBOutlet weak var startTime: UITextView!
    
    @IBOutlet weak var currentSong: UITextView!
    
    @IBAction func nextButton(sender: AnyObject) {
        counter += 1
        playTheNext()
    }
    
    
    @IBAction func prevButton(sender: AnyObject) {
        counter -= 1
        playTheNext()
    }
    
    @IBAction func shuffleButton(sender: AnyObject) {
    }
    @IBAction func playPauseAction(sender: UIButton) {
        
        if current_song != currentSong.text{
            currentSong.text = current_song
        }
        
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
            musicSlider.value = 0.0
            playPauseButton.setBackgroundImage(UIImage(named: "play"), forState: UIControlState.Normal)
            currentSong.text = "..."
        }
    }
    
    @IBAction func updateMusicSlider(sender: AnyObject) {
        //player.stop()
        player.currentTime = NSTimeInterval(musicSlider.value)
        
        //player.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedSongs()
        songsTable.rowHeight = CGFloat(integerLiteral: 25)
        songsTable.scrollEnabled = true
        musicSlider.value = 0.0

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        //playMusic("Chull")
        playMusic(songs[0].fileName)
    }
    
    func updateTheSlider(){
        musicSlider.value = Float(player.currentTime)
        startTime.text = giveTime(musicSlider.value)
    }
    
    func feedSongs(){
        let hindi_songs = ["Raabta", "Tune Jo Na Kaha", "Pee Loon", "Ishq Sufiyana", "Baby Ko Bass Pasand Hai", "Chull"]
        let cool_songs = ["I Took A Pill", "Bad Blood", "Somebody", "Gone Gone", "Geronimo", "Timilai Jun", "Oh My Love"]
        let nepali_songs = ["Siriri", "Allarey Jovan", "Mann", "Mero Maya", "Junkeri", "Kahiley Kahi"]
        let best_songs = ["Desi Romance", "Humko Humi Se Churalo", "I Gotta Feeling", "Kya Yehi Pyar Hai", "Lal Dupatta", "Main Hoon Na", "Main Hoon Naa", "Tumse Milke Dilka Hai"]
        let coverArts = ["bipul.jpg", "gone.png", "new york.jpg", "srk.jpg"]
        
        switch self.navigationItem.title! {
        case "Hindi":
            feedMe(hindi_songs)
            coverArtImage.image = UIImage(named: coverArts[2])
        case "Bipul Chhetri":
            feedMe(nepali_songs)
            coverArtImage.image = UIImage(named: coverArts[0])
            musicSlider.setThumbImage(UIImage(named: "triangle"), forState: UIControlState.Normal)
        case "Cool Songs":
            feedMe(cool_songs)
            coverArtImage.image = UIImage(named: coverArts[1])
        default:
            feedMe(best_songs)
            coverArtImage.image = UIImage(named: coverArts[3])
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
            player = try AVAudioPlayer(contentsOfURL: url)
            _ = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(PlayerController.updateTheSlider), userInfo: nil, repeats: true)
            musicSlider.maximumValue = Float(player.duration)
            endTime.text = giveTime(musicSlider.maximumValue)
            player.delegate = self
            player.play()
            current_song = songName!
            currentSong.text = current_song
            playPauseButton.setBackgroundImage(UIImage(named: "pause"), forState: UIControlState.Normal)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: AVAudioSessionCategoryOptions.MixWithOthers )
            
        } catch {
            // couldn't load file :(
        }
    }
    
    func giveTime(value: Float) -> String{
        let minute = Int(value/60)
        let seconds = Int(value%60)
        var timeString = minute.description + ":"
        if seconds < 10{
            timeString += "0" + seconds.description
        }else{
            timeString += seconds.description
        }
        return timeString
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
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool)
    {
        if flag {
            counter += 1
        }
        
        if ((counter + 1) == songs.count) {
            counter = 0
        }
        
        playMusic(songs[counter].fileName)
    }
    
    func playTheNext(){
        if (counter == songs.count || counter < 0) {
            counter = 0
        }
        playMusic(songs[counter].fileName)
    }

}
