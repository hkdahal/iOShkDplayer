//
//  ViewController.swift
//  hkPlayer
//
//  Created by Hari Dahal on 9/3/16.
//  Copyright © 2016 Hari Dahal. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: MyOwnController, UITableViewDelegate, UITableViewDataSource {
    
    // var playlists = [String]()
    var categories = [Category]()
    
    var mySongsFromAPI = [MySong]()

    @IBOutlet weak var theTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMeDataFromAPI()
        categories = initializePlaylists()
        // updateTheData()
        //playlists = ["Hindi", "Cool Songs", "Best Songs", "Bipul Chhetri"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // TABLE STUFFS ***
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = categories[(indexPath as NSIndexPath).row].name
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categories[(indexPath as NSIndexPath).row].name == "Online Playlists"{
            self.performSegue(withIdentifier: "toPlaylists", sender: theTable)
        }else{
            self.performSegue(withIdentifier: "toPlayer", sender: theTable)
        }
    }
    
    
    // SEGUE STUFFS ***
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlayer"{
            let VC = segue.destination as! MyOwnController
            let indexPath: IndexPath = theTable.indexPathForSelectedRow!
            VC.title = categories[(indexPath as NSIndexPath).row].name
            let temp_category = categories[(indexPath as NSIndexPath).row]
            feedThePlaylists(temp_category)
            VC.myPlaylist = temp_category.playlist!
        }else{
            let VC = segue.destination as! MyOwnController
            let indexPath: IndexPath = theTable.indexPathForSelectedRow!
            VC.title = categories[(indexPath as NSIndexPath).row].name
            VC.myCategory = categories[(indexPath as NSIndexPath).row]
            feedCollectionOfPlaylists(VC.myCategory!)
            //feedThePlaylists(VC.myCategory!)
            
        }
    }
    
    // FEEDING PLAYLISTS STUFFS ***
    
    func feedCollectionOfPlaylists(_ category: Category){
        let my_playlists = ["Cool Songs"]
        var the_playlists = [Playlist]()
        
        
        var playlist_1 = [String]()
        let name = "http://sound.mp3slash.net/indian/lage_raho_munna_bhai/lageraho_munnabhai0"
        let suf = "(songs.pk).mp3"
        
        for i in 1...8{
            playlist_1.append(name+String(i)+suf)
        }
        
        
        for my_pl in my_playlists{
            the_playlists.append(Playlist(name: my_pl, songs: feedMe(playlist_1, onlinePlaylist: my_pl), id: 10, imageName: "gone.png"))
        }
        
        category.playlists = the_playlists
        
    }
    
    func initializePlaylists() -> [Category]{
        var categories = [Category]()
        categories.append(Category(name: "API Playlist", type: "API"))
        let the_playlists = ["Random Playlist", "Most Played", "Songs", "Recently Added", "Currently Playing"]
        
        for pl in the_playlists{
            categories.append(Category(name: pl, type: "playlist"))
        }
        categories.append(Category(name: "Online Playlists", type: "category"))
        
        
        return categories
    }
    
    func feedThePlaylists(_ category: Category){
        
        if category.type == "category"{
            return
        }
        
        if category.type == "API"{
            feedTheAPIData(category)
            return
        }
        
        let hindi_songs = ["Raabta", "Tune Jo Na Kaha", "Pee Loon", "Ishq Sufiyana", "Baby Ko Bass Pasand Hai", "Chull"]
        let cool_songs = ["I Took A Pill", "Bad Blood", "Somebody", "Gone Gone", "Geronimo", "Timilai Jun", "Oh My Love"]
        let nepali_songs = ["Siriri", "Allarey Jovan", "Mann", "Mero Maya", "Junkeri", "Kahiley Kahi"]
        let best_songs = ["Bistarai", "Desi Romance", "Humko Humi Se Churalo", "I Gotta Feeling", "Kya Yehi Pyar Hai", "Lal Dupatta", "Main Hoon Na", "Main Hoon Naa", "Tumse Milke Dilka Hai"]
        let coverArts = ["bipul.jpg", "gone.png", "new york.jpg", "srk.jpg"]
        
        switch category.name {
        case "Random Playlist":
            category.playlist = Playlist(name: category.name, songs: feedMe(hindi_songs), id: 1, imageName: coverArts[0])
        case "Most Played":
            category.playlist = Playlist(name: category.name, songs: feedMe(cool_songs), id: 2, imageName: coverArts[1])
        case "Recently Added":
            category.playlist = Playlist(name: category.name, songs: feedMe(nepali_songs), id: 3, imageName: coverArts[2])
        default:
            category.playlist = Playlist(name: category.name, songs: feedMe(best_songs), id: 4, imageName: coverArts[3])
        }
    }
    
    
    func feedTheAPIData(_ category: Category){
        var the_songs = [Song]()
        
        for s in mySongsFromAPI{
            the_songs.append(Song(file: s.song_link, id: s.id, title: s.title))
        }
        
        category.playlist = Playlist(name: category.name, songs: the_songs, id: 6, imageName: "hk.jpg")
    }
    
    func feedMe(_ songTitles: [String], onlinePlaylist: String = "") -> [Song]{
        var my_songs = [Song]()
        var s_id = 0
        for st in songTitles{
            s_id += 1
            var a_song: Song
            if onlinePlaylist != ""{
                a_song = Song(file: st, id: s_id, title: onlinePlaylist + String(s_id) )
            }else{
                a_song = Song(file: st, id: s_id)
            }
            my_songs.append(a_song)
        }
        return my_songs
    }
    
    func getMeDataFromAPI(){
        updateTheData()
    }
    
    func updateTheData(){
        getDataFromAPI(String("movies/6/songs"))
    }
    
    func getDataFromAPI(_ token: String){
        let ownClient = MyClient(token: token)
        ownClient.fetchCurrentWeather({result in
            switch result{
            case .success(let SongDetails):
                //print("Called Cool Stuffs")
                DispatchQueue.main.sync{
                    self.giveBackDetails(SongDetails)
                }
            case .failure(let error as NSError):
                print("Failed because of \(error)")
            default: break
            }
        })
    }
    
    func giveBackDetails(_ stuff: SongDetails){
        mySongsFromAPI = stuff.song_obj
        //print(stuff.song_link + " " + stuff.title )
        // card.coverVerse = stuff.coverVerse
        //card.insideVerse = stuff.insideVerse
    }
    
}

