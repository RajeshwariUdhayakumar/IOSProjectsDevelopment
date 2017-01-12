//
//  ViewController.swift
//  DataBase
//
//  Created by macmini on 03/01/17.
//  Copyright © 2017 nointernetcheck.businessdragan.com. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import  Contacts
import ContactsUI

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AVAudioPlayerDelegate
{

    @IBOutlet var txtfld: UITextField!
    @IBOutlet var tblview: UITableView!
    @IBOutlet var mediaTblview: UITableView!
    @IBOutlet var mediaView: UIView!
    
    //Contact
    var fullNameArray: [String] = []
    var fullnames:String = ""
    
    
    
    //Text
    var loadMsgArray: [String] = []
    var DateArray: [String] = []
    var checkStr: NSString!
    //Audio
    var soundArray:[String] = []
    var urlArray = NSMutableArray()
    var getSoundStr:String = ""
    var getAudioNameArray = NSMutableArray()
    var StoreAudioArray = NSMutableArray()
    var FetchArray = NSMutableArray()
    var audioPlayer = AVAudioPlayer()
    var Firstarray = NSMutableArray()
    var Secondarray = NSMutableArray()
    var timer:Timer!
    var buttonRow: Int = 0
    var soundFileNameURL: NSURL = NSURL()
    var soundFileName = ""
    var urlString = ""
    var audioString:String = ""
    var sliderTimer:Timer!
    var CheckaudioString:String = ""
    var type:String = ""
    var typeArray: [String] = []
    
    func getContext () -> NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.mediaView.isHidden = true
        soundArray = ["audio1.mp3","audio2.mp3","audio3.mp3","audio4.mp3","audio5.mp3","audio6.mp3","audio7.mp3","audio8.mp3"]
        let name:String = "Message"
        var messageString:String
        var datestring:String
        let context = getContext()
        let entity =  NSEntityDescription.entity(forEntityName: "DB", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let pred = NSPredicate(format: "(name = %@)", name)
        fetchRequest.predicate = pred
        fetchRequest.entity = entity
        var results = [NSManagedObject]()
        do
        {
            // Execute Fetch Request
            let records = try getContext().fetch(fetchRequest)
            if let records = records as? [NSManagedObject]
            {
                results = records
                if results.count == 0
                {
                    print("no result")
                }
                else
                {
                    for res in results
                    {
                        print(res)
                        type = (res.value(forKey: "messageType")as! String)
                        audioString = (res.value(forKey: "audioname") as! String)
                        messageString = (res.value(forKey: "message") as! String)
                        datestring = (res.value(forKey: "date") as! String )
                        loadMsgArray.append(messageString as String)
                        typeArray.append(type)
                        DateArray.append(datestring as String)
                        getAudioNameArray.add(audioString)
                        self.tblview.delegate = self;
                        self.tblview.dataSource = self;
                        self.tblview .reloadData()
                        print("\(loadMsgArray.count)")
                        print("\(loadMsgArray)")
                        for i in 0  ..< loadMsgArray.count
                        {
                            print("\(i)")
                            Firstarray.add("YES")
                        }
                    }
                }
            }
        }
        catch
        {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        //Text
        self.tblview.register(UINib(nibName: "TextSenderTableCell", bundle: nil), forCellReuseIdentifier: "TextSenderTableCell")
        self.tblview.register(UINib(nibName: "TextReceiverTableCell", bundle: nil), forCellReuseIdentifier: "TextReceiverTableCell")
        //Audio
        self.tblview.register(UINib(nibName: "AudioSenderTableCell", bundle: nil), forCellReuseIdentifier: "AudioSenderTableCell")
        self.tblview.register(UINib(nibName: "AudioReceiverTableCell", bundle: nil), forCellReuseIdentifier: "AudioReceiverTableCell")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var height:CGFloat = 0.0
        if tableView.tag == 1
        {
            height = 50.0
        }
        else if tableView.tag == 2
        {
            height = 80.0
        }
        return height
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var countt:Int = 0
        if tableView.tag == 1
        {
            countt = soundArray.count
        }
        else if tableView.tag == 2
        {
            countt = loadMsgArray.count
        }
        return countt
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        if tableView.tag == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SoundTableCell", for: indexPath as IndexPath) as! SoundTableCell
            cell.celllbl.text = soundArray[indexPath.row]
            return cell
        }
        else if tableView.tag == 2
        {
            let checkType = typeArray[indexPath.row]
            if checkType == "Text"
            {
                if indexPath.row % 2 == 0
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TextSenderTableCell", for: indexPath as IndexPath) as! TextSenderTableCell
                    cell.sendernameLbl.text = "Sender"
                    cell.senderMsgLbl.text = loadMsgArray[indexPath.row]
                    cell.senderDateLbl.text = DateArray[indexPath.row]
                    return cell
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TextReceiverTableCell", for: indexPath as IndexPath) as! TextReceiverTableCell
                    cell.receivernameLbl.text = "Receiver"
                    cell.receiverMsgLbl.text = loadMsgArray[indexPath.row]
                    cell.receiverDateLbl.text = DateArray[indexPath.row]
                    return cell
                }
            }
            else if checkType == "Audio"
            {
                if indexPath.row % 2 == 0
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AudioSenderTableCell", for: indexPath as IndexPath) as! AudioSenderTableCell
                    cell.DateLbl.text = DateArray[indexPath.row]
                    cell.AudionameLbl.text = getAudioNameArray[indexPath.row] as? String
                    cell.PlayorPause.addTarget(self, action: #selector(getplay(_:)), for: UIControlEvents.touchUpInside)
                    cell.PlayorPause.accessibilityHint = "S"
                    cell.stopBtn.addTarget(self, action: #selector(getStop(_:)), for: UIControlEvents.touchUpInside)
                    cell.stopBtn.accessibilityHint = "S"
                    cell.RangeSlider.addTarget(self, action: #selector(ViewController.sliderChanged(_:)), for: UIControlEvents.valueChanged)
                    cell.RangeSlider.accessibilityHint = "S"
                    cell.PlayorPause.tag = indexPath.row
                    cell.stopBtn.tag = indexPath.row
                    cell.RangeSlider.tag = indexPath.row
                    return cell
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AudioReceiverTableCell", for: indexPath as IndexPath) as! AudioReceiverTableCell
                    cell.RdateLbl.text = DateArray[indexPath.row]
                    cell.RAudionameLbl.text = getAudioNameArray[indexPath.row] as? String
                    cell.RPlayorPause.addTarget(self, action: #selector(getplay), for: UIControlEvents.touchUpInside)
                    cell.RPlayorPause.accessibilityHint = "R"
                    cell.RstopBtn.addTarget(self, action: #selector(getStop), for: UIControlEvents.touchUpInside)
                    cell.RstopBtn.accessibilityHint = "R"
                    cell.RrangeSlider.addTarget(self, action: #selector(ViewController.sliderChanged(_:)), for: UIControlEvents.valueChanged)
                    cell.RrangeSlider.accessibilityHint = "R"
                    cell.RPlayorPause.tag = indexPath.row
                    cell.RstopBtn.tag = indexPath.row
                    cell.RrangeSlider.tag = indexPath.row
                    return cell
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.tag == 1
        {
        getSoundStr = soundArray[indexPath.row]
        self .Sound(soundFile:getSoundStr)
        urlArray.add(urlString)
        StoreAudioArray = urlArray
        self.mediaView.isHidden = true
        self.tblview.delegate = self;
        self.tblview.dataSource = self;
        self.tblview .reloadData()
        }
        else
        {
        }
    }
    func Sound (soundFile: String)
    {
        let datestring:String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy HH:mm"
        let date = Date()
        datestring = dateFormatter .string(from:date )
        soundFileName = soundFile
        let url : URL = Bundle.main.url(forResource: soundFile, withExtension: nil)! as URL
        print("\(url)")
        urlString = String.init(describing: url)
        print("\(urlString)")
        let defaults = UserDefaults.standard
        defaults.set("Test", forKey: "check")
        let name:String = "Message"
        let context = getContext()
        let entity =  NSEntityDescription.entity(forEntityName: "DB", in: context)
        let database = NSManagedObject(entity: entity!, insertInto: context)
        database.setValue(name, forKey: "name")
        database.setValue(urlString, forKey: "message")
        database.setValue(soundFile, forKey: "audioname")
        database.setValue(datestring, forKey: "date")
        database.setValue("Audio", forKey: "messageType")
        do
        {
            try context.save()
            print("saved!")
        } catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
        }
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        }
        catch let error as NSError
        {
            print(error.description)
        }
        loadMsgArray.append(urlString)
        DateArray.append(datestring)
        print("\(loadMsgArray)")
        getAudioNameArray.add(soundFile)
        typeArray.append("Audio")
        for i in 0  ..< loadMsgArray.count
        {
            print("\(i)")
            Firstarray.add("YES")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func selectAudio(_ sender: Any)
    {
        self.mediaView.isHidden = false
    }
    @IBAction func sendTxt(_ sender: Any)
    {
        let defaults = UserDefaults.standard
        defaults.set("Test", forKey: "Text")
        let name:String = "Message"
        let datestring:String
        let txtMsg:String = self.txtfld.text!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy HH:mm"
        let date = Date()
        datestring = dateFormatter .string(from:date )
        let context = getContext()
        let entity =  NSEntityDescription.entity(forEntityName: "DB", in: context)
        let database = NSManagedObject(entity: entity!, insertInto: context)
        database.setValue(name, forKey: "name")
        database.setValue(datestring, forKey: "date")
        database.setValue(txtMsg, forKey: "message")
        database.setValue("name", forKey: "audioname")
        database.setValue("Text", forKey: "messageType")
        do
        {
            try context.save()
            print("saved!")
            self.txtfld.text = ""
        }
        catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
        }
        loadMsgArray.append(txtMsg)
        getAudioNameArray.add("name")
        typeArray.append("Text")
        DateArray.append(datestring)
        self.tblview.delegate = self;
        self.tblview.dataSource = self;
        self.tblview .reloadData()
    }
    @IBAction func sliderChanged(_ sender: UISlider)
    {
        let slider = sender
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval(slider.value)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    func playSound (soundFile: String)
    {
        soundFileName = soundFile
        let url : URL = Bundle.main.url(forResource: soundFile, withExtension: nil)! as URL
        print("\(url)")
        urlString = String.init(describing: url)
        print("\(urlString)")
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        }
        catch let error as NSError { print(error.description)
        }
    }
    func getplay(_ sender : UIButton)
    {
        print("\(sender.accessibilityHint)")
        if sender.accessibilityHint == "S"
        {
            buttonRow = sender.tag
            let getarrayName : NSString = Firstarray.object(at: buttonRow) as! NSString
            let audioName = getAudioNameArray[buttonRow] as! String
            let path = NSIndexPath.init(row: buttonRow, section: 0)
            let currentCell = self.tblview.cellForRow(at: path as IndexPath) as! AudioSenderTableCell!;
            if getarrayName == "YES"
            {
                if Secondarray.contains("\(sender.tag)")
                {
                    sender.setTitle("Pause", for: .normal)
                    sliderTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
                    CheckaudioString = "S"
                    // Set the maximum value of the UISlider
                    currentCell?.RangeSlider.maximumValue = Float(audioPlayer.duration)
                    // Set the valueChanged target
                    currentCell?.RangeSlider.addTarget(self, action: #selector(self.sliderChanged), for: .valueChanged)
                    // Play the audio
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    let getObjectIndex =  Secondarray.index(of: "\(sender.tag)")
                    Secondarray.removeObject(at: getObjectIndex)
                    Firstarray.replaceObject(at: sender.tag, with: "NO")
                    
                }
                else
                {
                    sender.setTitle("Pause", for: .normal)
                    Secondarray.removeAllObjects()
                    self.playSound(soundFile: audioName)
                    audioPlayer.delegate = self
                    let path = NSIndexPath.init(row: buttonRow, section: 0)
                    let currentCell = self.tblview.cellForRow(at: path as IndexPath) as! AudioSenderTableCell!;
                    sliderTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
                    CheckaudioString = "S"
                    // Set the maximum value of the UISlider
                    currentCell?.RangeSlider.maximumValue = Float(audioPlayer.duration)
                    // Set the valueChanged target
                    currentCell?.RangeSlider.addTarget(self, action: #selector(self.sliderChanged), for: .valueChanged)
                    // Play the audio
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    let getObjectIndex  =  Firstarray.index(of: "NO")
                    if getObjectIndex != 2147483647
                    {
                        Firstarray.replaceObject(at: getObjectIndex, with: "YES")
                    }
                    Firstarray.replaceObject(at: sender.tag, with: "NO")
                }
            }
            else
            {
                sender.setTitle("Play", for: .normal)
                Secondarray.add("\(sender.tag)")
                Firstarray.replaceObject(at: sender.tag, with: "YES")
                let path = NSIndexPath.init(row: buttonRow, section: 0)
                let currentCell = self.tblview.cellForRow(at: path as IndexPath) as! AudioSenderTableCell!;
                sliderTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
                CheckaudioString = "S"
                // Set the maximum value of the UISlider
                currentCell?.RangeSlider.maximumValue = Float(audioPlayer.duration)
                // Set the valueChanged target
                currentCell?.RangeSlider.addTarget(self, action: #selector(self.sliderChanged), for: .valueChanged)
                // Play the audio
                //audioPlayer.prepareToPlay()
                // audioPlayer.play()
                audioPlayer.pause()
            }
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
            CheckaudioString = "S"
        }
        else if sender.accessibilityHint == "R"
        {
            buttonRow = sender.tag
            let getarrayName : NSString = Firstarray.object(at: buttonRow) as! NSString
            let audioName = getAudioNameArray[buttonRow] as! String
            let path = NSIndexPath.init(row: buttonRow, section: 0)
            let currentCell = self.tblview.cellForRow(at: path as IndexPath) as! AudioReceiverTableCell!;
            if getarrayName == "YES"
            {
                if Secondarray.contains("\(sender.tag)")
                {
                    sender.setTitle("Pause", for: .normal)
                    sliderTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
                    CheckaudioString = "R"
                    // Set the maximum value of the UISlider
                    currentCell?.RrangeSlider.maximumValue = Float(audioPlayer.duration)
                    // Set the valueChanged target
                    currentCell?.RrangeSlider.addTarget(self, action: #selector(self.sliderChanged), for: .valueChanged)
                    // Play the audio
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    let getObjectIndex =  Secondarray.index(of: "\(sender.tag)")
                    Secondarray.removeObject(at: getObjectIndex)
                    Firstarray.replaceObject(at: sender.tag, with: "NO")
                }
                else
                {
                    sender.setTitle("Pause", for: .normal)
                    Secondarray.removeAllObjects()
                    self.playSound(soundFile: audioName)
                    audioPlayer.delegate = self
                    let path = NSIndexPath.init(row: buttonRow, section: 0)
                    let currentCell = self.tblview.cellForRow(at: path as IndexPath) as! AudioReceiverTableCell!;
                    sliderTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
                    CheckaudioString = "R"
                    // Set the maximum value of the UISlider
                    currentCell?.RrangeSlider.maximumValue = Float(audioPlayer.duration)
                    // Set the valueChanged target
                    currentCell?.RrangeSlider.addTarget(self, action: #selector(self.sliderChanged), for: .valueChanged)
                    // Play the audio
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    let getObjectIndex  =  Firstarray.index(of: "NO")
                    if getObjectIndex != 2147483647
                    {
                        Firstarray.replaceObject(at: getObjectIndex, with: "YES")
                    }
                        Firstarray.replaceObject(at: sender.tag, with: "NO")
                }
            }
                else
                {
                    sender.setTitle("Play", for: .normal)
                    Secondarray.add("\(sender.tag)")
                    Firstarray.replaceObject(at: sender.tag, with: "YES")
                    let path = NSIndexPath.init(row: buttonRow, section: 0)
                    let currentCell = self.tblview.cellForRow(at: path as IndexPath) as!AudioReceiverTableCell!;
                    sliderTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
                    CheckaudioString = "R"
                    // Set the maximum value of the UISlider
                    currentCell?.RrangeSlider.maximumValue = Float(audioPlayer.duration)
                    // Set the valueChanged target
                    currentCell?.RrangeSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
                    // Play the audio
                    //audioPlayer.prepareToPlay()
                    // audioPlayer.play()
                    audioPlayer.pause()
                }
                    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
                    CheckaudioString = "R"
        }
       // self.tblview.reloadData()
    }
    func updateSlider()
    {
        if CheckaudioString == "S"
        {
            let path = NSIndexPath.init(row: buttonRow, section: 0)
            let currentCell = self.tblview.cellForRow(at: path as IndexPath) as! AudioSenderTableCell!
            currentCell?.RangeSlider.value = Float(audioPlayer.currentTime)
        }
        else if CheckaudioString == "R"
        {
            let path = NSIndexPath.init(row: buttonRow, section: 0)
            let currentCell = self.tblview.cellForRow(at: path as IndexPath) as! AudioReceiverTableCell!;
            currentCell?.RrangeSlider.value = Float(audioPlayer.currentTime)
        }
    }
    func updateTime()
    {
        if CheckaudioString == "S"
        {
            let path = NSIndexPath.init(row: buttonRow, section: 0)
            let currentCell = self.tblview.cellForRow(at: path as IndexPath) as! AudioSenderTableCell!;
            let TotalTime = Int(audioPlayer.duration)
            let totalMinute = TotalTime/60
            let TotalSecond = TotalTime - totalMinute * 60
            currentCell?.TotaltimeLbl.text = NSString(format: "%02d:%02d", totalMinute,TotalSecond) as String
            let currentTime = Int(audioPlayer.currentTime)
            let minutes = currentTime/60
            let seconds = currentTime - minutes * 60
            currentCell?.timeLbl.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        }
        else if CheckaudioString == "R"
        {
            let path = NSIndexPath.init(row: buttonRow, section: 0)
            let currentCell = self.tblview.cellForRow(at: path as IndexPath) as! AudioReceiverTableCell!;
            let TotalTime = Int(audioPlayer.duration)
            let totalMinute = TotalTime/60
            let TotalSecond = TotalTime - totalMinute * 60
            currentCell?.TotaltimeLbl.text = NSString(format: "%02d:%02d", totalMinute,TotalSecond) as String
            let currentTime = Int(audioPlayer.currentTime)
            let minutes = currentTime/60
            let seconds = currentTime - minutes * 60
            currentCell?.RtimeLbl.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        }
    }
    func getStop(_ sender : UIButton)
    {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        Secondarray.removeAllObjects()
        let getObjectIndex  =  Firstarray.index(of: "NO")
        if getObjectIndex != 2147483647
        {
            Firstarray.replaceObject(at: getObjectIndex, with: "YES")
        }
        //self.tblview.reloadData()
    }
    @IBAction func audio(_ sender: Any)
    {
        self.mediaView.isHidden = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contact"
        {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.isFirst = true
            
            
        }
    }

    @IBAction func Contact(_ sender: Any) {
    
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: {
            granted, error in
            
            guard granted else {
                let alert = UIAlertController(title: "Can't access contact", message: "Please go to Settings -> MyApp to enable contact permission", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            //var fullnames:String
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
            let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
            var cnContacts = [CNContact]()
            
            do {
                try store.enumerateContacts(with: request){
                    (contact, cursor) -> Void in
                    cnContacts.append(contact)
                }
            } catch let error {
                NSLog("Fetch contact error: \(error)")
            }
            
            NSLog(">>>> Contact list:")
            for contact in cnContacts {
                self.fullnames = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
                //let phoneNum = CNContactFormatter.string(from: contact, style: .p)
                NSLog("\(self.fullnames): \(contact.phoneNumbers.description)")
                self.fullNameArray.append(self.fullnames)
                print("\(self.fullNameArray)")
                self .saveContact(getname: self.fullnames)
            }
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let viewC = story.instantiateViewController(withIdentifier: "ContactsViewController")as! ContactsViewController
            self.navigationController?.pushViewController(viewC, animated: true)
            
        })

    }
    
    
    func saveContact(getname: String)
    {
        print("\(getname)")
        var setNameArray:[String] = []
        let context = self.getContext()
        let entity =  NSEntityDescription.entity(forEntityName: "ContactDB", in: context)
        let database = NSManagedObject(entity: entity!, insertInto: context)
        database.setValue(getname, forKey: "name")
        do
        {
            try context.save()
            print("saved!")
        }
        catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
        }
                
    }

    
    
}

