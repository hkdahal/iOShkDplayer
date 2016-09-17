//
//  PlayerController.swift
//  hkPlayer
//
//  Created by Hari Dahal on 9/4/16.
//  Copyright © 2016 Hari Dahal. All rights reserved.
//

import UIKit
import AVFoundation

class MyOwnController: UIViewController{
    var myCategory: Category?
    var myPlaylist: Playlist?
}


class PlayerController: MyOwnController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {
    
    var player: AVAudioPlayer?
    
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
    
    @IBOutlet weak var volumeButton: UIImageView!
    
    @IBOutlet weak var volumeSlider: UISlider!{
        didSet{
            //volumeSlider.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))

        }
    }
    
    @IBOutlet weak var currentSong: UITextView!
    
    @IBAction func nextButton(_ sender: AnyObject) {
        counter += 1
        playTheNext()
    }
    
    
    @IBAction func prevButton(_ sender: AnyObject) {
        if counter == 0{
            counter = songs.count-1
        }else{
            counter -= 1
        }
        
        playTheNext()
    }
    
    @IBAction func updateVolumeSlider(_ sender: AnyObject) {
        player!.volume = volumeSlider.value
    }
    
    @IBAction func shuffleButton(_ sender: AnyObject) {
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        
        if current_song != currentSong.text{
            currentSong.text = current_song
        }
        
        if player!.isPlaying{
            player!.pause()
            playPauseButton.setBackgroundImage(UIImage(named: "play"), for: UIControlState())
        }else{
            player!.play()
            playPauseButton.setBackgroundImage(UIImage(named: "pause"), for: UIControlState())
        }
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        player!.stop()
        player!.currentTime = 0
        musicSlider.value = 0.0
        playPauseButton.setBackgroundImage(UIImage(named: "play"), for: UIControlState())
        currentSong.text = "..."
    }
    
    @IBAction func updateMusicSlider(_ sender: AnyObject) {
        //player.stop()
        player!.currentTime = TimeInterval(musicSlider.value)
        
        //player.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = self.myPlaylist?.getMyPlayer
        // player = myInmformation!["myPlayer"] as? AVAudioPlayer
        songs = (self.myPlaylist?.songs)! //(self.myCategory?.playlist!.songs)!
        coverArtImage.image = self.myPlaylist?.playlistCover
        //feedSongs()
        songsTable.rowHeight = CGFloat(integerLiteral: 25)
        songsTable.isScrollEnabled = true
        musicSlider.value = 0.0
        volumeSlider.value = 0.5
        //volumeSlider.setThumbImage(UIImage(named: "volumeIndicator"), forState: UIControlState.Normal)
        
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        player?.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //playMusic("Chull")
        playTheNext()
    }
    
    func updateTheSlider(){
        musicSlider.value = Float(player!.currentTime)
        startTime.text = giveTime(musicSlider.value)
        player?.volume = volumeSlider.value
    }
    
    func playMusic(_ playThisSong: Song?){
        current += 1
        player = Playlist.playTheMusic(playThisSong!.fileName)
        //self.myPlaylist?.playTheMusic(songName!)
        _ = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(PlayerController.updateTheSlider), userInfo: nil, repeats: true)
        musicSlider.maximumValue = Float(player!.duration)
        endTime.text = giveTime(musicSlider.maximumValue)
        player!.delegate = self
        player!.play()
        current_song = (playThisSong?.title)!
        currentSong.text = current_song
        playPauseButton.setBackgroundImage(UIImage(named: "pause"), for: UIControlState())
        self.songsTable.selectRow(at: IndexPath(row: counter, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.middle)
    }
    
    func giveTime(_ value: Float) -> String{
        let minute = Int(value/60)
        let seconds = Int(value.truncatingRemainder(dividingBy: 60))
        var timeString = minute.description + ":"
        if seconds < 10{
            timeString += "0" + seconds.description
        }else{
            timeString += seconds.description
        }
        return timeString
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "songCell")
        cell.textLabel?.text = songs[(indexPath as NSIndexPath).row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theSong = songs[(indexPath as NSIndexPath).row]
        counter = (indexPath as NSIndexPath).row
        playMusic(theSong)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        if flag {
            counter += 1
        }
        
        if ((counter + 1) == songs.count) {
            counter = 0
        }
        playMusic(songs[counter])
    }
    
    func playTheNext(){
        if (counter == songs.count || counter < 0) {
            counter = 0
        }
        playMusic(songs[counter])
    }

}
