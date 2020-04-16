//
//  TrialController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 20/02/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import Speech
import AVFoundation
import AVKit

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

class TrialController: UIViewController,SFSpeechRecognizerDelegate {
    
   
    
    
    //speech vaars
    var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: Language.instance.setlanguage()))!
    
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    var recognitionTask: SFSpeechRecognitionTask?
    
    let audioEngine = AVAudioEngine()
    @IBOutlet weak var recordButton: UIButton!
    
    var  mcue = false,scue = false,tcue = false, frcue = false, fvcue = false , sxcue = false, svcue = false

    
    @IBOutlet var playButton: UIButton!
    
    @IBOutlet var trialResult: UIButton!
    
    
    @IBOutlet var validateButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    
    
    
    var audioPlayerFirst:AVAudioPlayer?
    
    //Vars
    let db = Firestore.firestore()
    var count = 0
    var trials = [Trial]()
    var countCoResult = 0
    var countFaResult = 0
    var pressed = false
    var patient : Patient?
//    var answers: String? = nil
//    var results: String? = nil
    var progresses = [Progress]()
    
    
    //Outlet
    @IBOutlet weak var writtenCue: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cue1: UIButton!
    @IBOutlet weak var cue2: UIButton!
    @IBOutlet weak var cue3: UIButton!
    @IBOutlet weak var cue4: UIButton!
    @IBOutlet weak var cue5: UIButton!
    @IBOutlet weak var cue6: UIButton!
    @IBOutlet weak var cue7: UIButton!
    
    
    
    
    
    let storageRef = Storage.storage().reference()
    
    //play storage audio
    var playerAt = AVPlayer()
    
    //essintial function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHome"{
            let destnationVC = segue.destination as! BaseViewController
            destnationVC.trials = trials
            destnationVC.patient = patient
            destnationVC.modalPresentationStyle = .fullScreen
        }
        else if segue.identifier == "help"{
            let destnationVC = segue.destination as! HelpViewController
            destnationVC.trials = trials
            destnationVC.patient = patient
            destnationVC.modalPresentationStyle = .fullScreen
        }
        
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewDidLoad() {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record!
        }
        if(count == 0){
            prevButton.isHidden = true
        }
        if trials.count == 1 {
            nextButton.isHidden = true
        }
        writtenCue.text = ""
        showCurrentTrial()
    }
    
    
    func loadRecordingUI() {
        playButton.isHidden = true
        validateButton.isHidden=true
        
        recordButton.isHidden = false
        recordButton.setTitle("", for: .normal)
    }
    
    @IBAction func viewResult(_ sender: UIButton) {
        
        print(pressed)
        print (countCoResult)
        print(countFaResult)
        
        func goToHomePage(alert: UIAlertAction){
            print("go to home page")
            
            
            let sampleStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let homeView  = sampleStoryBoard.instantiateViewController(withIdentifier: "HomeViewController") as! BaseViewController
            self.present(homeView, animated: true, completion: nil)
            
            
        }
        
        // create the alert
        var result = String()
        result = "عدد الإجابات الصحيحة  " + String(countCoResult) + "\n" + "عدد الإجابات الخاطئة  " + String(countFaResult)
        
        let alert = UIAlertController(title: "النتيجة", message: result, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        
        alert.addAction(UIAlertAction(title: "رجوع", style: UIAlertAction.Style.default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "إنهاء التمرين", style: UIAlertAction.Style.default, handler: goToHomePage))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        updateProgress()
        
        
    }
    
    
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if audioRecorder == nil {
            startRecording()
            
            //when done
            playButton.isHidden = true
            validateButton.isHidden=true
            
            if #available(iOS 13.0, *) {
                let playImage = UIImage(systemName:"stop.fill")
                sender.setImage(playImage, for: [])
                
            } else {
                // Fallback on earlier versions
            }
            
        } else {
            finishRecording(success: true)
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if audioPlayer == nil {
            startPlayback()
        } else {
            finishPlayback()
        }
    }
    
    
    @IBAction func validateButtonPressed(_ sender: UIButton) {
        
        //maybe move comparing code here
        
        //if nill ..... no answer
        if UserDefaults.standard.string(forKey: Constants.currentAnswer) == nil{
            
            // create the alert
            let alert = UIAlertController(title: "لا توجد إجابة", message: "حاول مجددًا", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "حسنًا", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            
            
            
            
            
            return;
        }
        
        
        
        if (UserDefaults.standard.bool(forKey: Constants.isAnswerCorrect) == true){
            
            // create the alert
            let alert = UIAlertController(title: "إجابة صحيحة", message: "أحسنت!", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "حسنًا", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            setProgress( answer: trials[count].answer ,result: "t")
        }
            
            
        else{
            // create the alert
            let alert = UIAlertController(title: "إجابة خاطئة", message: "حظ أوفر", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "حسنًا", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        setProgress( answer: trials[count].answer ,result: "f")
        }
    }
    
    
    
    
    
    // MARK: - Recording
    func startRecording() {
        
        
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            try recordingSession.setCategory(.record, mode: .default)
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            
            if  audioEngine.isRunning {
                
                recognitionRequest?.shouldReportPartialResults = false
                audioEngine.inputNode.removeTap(onBus: 0)
                audioEngine.stop()
                recognitionRequest?.endAudio()
                
                
                recordButton.isEnabled = true
                
                recordButton.setTitle("", for: [])
                
                
            } else {
                
                try! startRecordingFirst()
                
                recordButton.setTitle("", for: [])
                
            }
            
            
            audioRecorder.record()
            
            
            recordButton.setTitle("", for: .normal)
            
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        
        //when done
        if #available(iOS 13.0, *) {
            let playImage = UIImage(systemName:"mic.fill")
            recordButton.setImage(playImage, for: [])
        } else {
            // Fallback on earlier versions
        }
        playButton.isHidden = false
//        validateButton.isHidden=false
        
        audioEngine.stop()
        
        recognitionRequest?.endAudio()
        
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("", for: .normal)
            playButton.setTitle("", for: .normal)
            
            playButton.isHidden = false
            //validateButton.isHidden=false
            
            
            
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            playButton.isHidden = true
            // recording failed :(
        }
    }
    
    
    // MARK: - Playback
    
    func startPlayback() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        do {
            try recordingSession.setCategory(.playback, mode: .default)
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer.delegate = self
            audioPlayer.play()
            playButton.setTitle("", for: .normal)
        } catch {
            playButton.isHidden = true
            // unable to play recording!
        }
    }
    
    func finishPlayback() {
        audioPlayer = nil
        playButton.setTitle("", for: .normal)
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        requestAuthorization()
    }
    
    
    @objc func showCurrentTrial(){
        
        
          db.collection("patients").whereField("uid", isEqualTo:Auth.auth().currentUser!.uid)
                 .getDocuments {(snapshot, error) in
        
                      if let error = error{print(error.localizedDescription)}
                      else {
                            if let snapshot = snapshot {
                           for document in snapshot.documents{
                                     let data = document.data()
        
        
                         self.mcue = data["cue1"] as! Bool
                            self.scue = data["cue2"] as! Bool
                                self.tcue = data["cue3"] as! Bool
                                    self.frcue = data["cue4"] as! Bool
                                        self.fvcue = data["cue5"] as! Bool
                                              self.sxcue = data["cue6"] as! Bool
                                                    self.svcue = data["cue7"] as! Bool
        
        if self.mcue == false
        { self.cue1.isUserInteractionEnabled = false
            self.cue1.setTitleColor(.gray, for: .normal)}
                           
                            
                            if self.scue == false
                              { self.cue2.isUserInteractionEnabled = false
                              self.cue2.setTitleColor(.gray, for: .normal)}
                                  
                                          
                                          
                              if self.tcue == false
                              { self.cue3.isUserInteractionEnabled = false
                              self.cue3.setTitleColor(.gray, for: .normal)}
                            
                                          
                              if self.frcue == false
                                  { self.cue4.isUserInteractionEnabled = false
                                  self.cue4.setTitleColor(.gray, for: .normal)}
                              
                                          
                             if self.fvcue == false
                                { self.cue5.isUserInteractionEnabled = false
                                self.cue5.setTitleColor(.gray, for: .normal)}
                                          
                                  if self.sxcue == false
                                   { self.cue6.isUserInteractionEnabled = false
                                   self.cue6.setTitleColor(.gray, for: .normal)}
                                    
                                          
                            if self.svcue == false
                              { self.cue7.isUserInteractionEnabled = false
                              self.cue7.setTitleColor(.gray, for: .normal)}
                                
                            
                            
                                }}}
                     
          
        }
        
        
        
        
        //image
        print(trials, count)
        cue2.isEnabled = false
        cue2.alpha = 0.54
        cue3.isEnabled = false
        cue3.alpha = 0.54
        cue4.isEnabled = false
        cue4.alpha = 0.54
        cue5.isEnabled = false
        cue5.alpha = 0.54
        cue6.isEnabled = false
        cue6.alpha = 0.54
        cue7.isEnabled = false
        cue7.alpha = 0.54
        validateButton.isHidden = true
        playButton.isHidden = true
        writtenCue.text = ""
        let url = "images/"+trials[count].name+".jpg"
        let reference = storageRef.child(url)
        
        // UIImageView in your ViewController
        let imageView: UIImageView = self.imageView
        
        // Placeholder image
        let placeholderImage = UIImage(named: "placeholder.jpg")
        
        // Load the image using SDWebImage
        imageView.sd_setImage(with: reference, placeholderImage: placeholderImage) { (image, error, cache, url) in
            self.playSound(filename: "canYouNaming")
        }
        
        // Perform operation.
        //audio
        
        
        //answer
        //here put the trial answer instead of Atheer
        UserDefaults.standard.set(trials[count].answer, forKey: Constants.correcAnswer)
        print(count)
    }
    
    
    
    //Conection function
    @IBAction func goTohome(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toHome", sender: self)
    }
    
    @IBAction func helpPage(_ sender: UIButton) {
        self.performSegue(withIdentifier: "help", sender: self)
    }
    @IBAction func SkipPressed(_ sender: UIButton) {
        if(sender.currentTitle! == "Next"){
            prevButton.isHidden = false
            count += 1
            showCurrentTrial()
            if (count == trials.count){
                nextButton.isHidden = true
            }
        }
        else{
            nextButton.isHidden = false
            count -= 1
            showCurrentTrial()
            if(count == 0){
                prevButton.isHidden = true
            }
        }
    }
    
    @IBAction func cuesPressed(_ sender: UIButton) {
        if sender.currentTitle == "المعنى" {
            let audPath = "audios/"+trials[count].audiosNames[0]+".mp3"
            let starsRef = storageRef.child(audPath)
            starsRef.downloadURL { url, error in
                if error != nil {
                    // Handle any errors
                    print("error")
                } else {
                    // Get the download URL for 'images/stars.jpg'
                    let playerItem = AVPlayerItem(url: URL(string: url!.absoluteString)!)
                    self.playerAt = AVPlayer(playerItem: playerItem)
                    self.playerAt.play()
                }
                
            }
            cue2.isEnabled = true
            cue2.alpha = 1
        } else if sender.currentTitle == "جملة"{
            let text = trials[count].writtenCues[0]
            writtenCue.text = text
            cue3.isEnabled = true
            cue3.alpha = 1
        } else if sender.currentTitle == "الصوت الأول" {
            let audPath = "audios/"+trials[count].audiosNames[1]+".mp3"
            let starsRef = storageRef.child(audPath)
            starsRef.downloadURL { url, error in
                if error != nil {
                    // Handle any errors
                } else {
                    // Get the download URL for 'images/stars.jpg'
                    let playerItem = AVPlayerItem(url: URL(string: url!.absoluteString)!)
                    self.playerAt = AVPlayer(playerItem: playerItem)
                    self.playerAt.play()
                }
                
            }
            writtenCue.text = ""
            cue4.isEnabled = true
            cue4.alpha = 1
        } else if sender.currentTitle == "المقطع الأول"{
            let audPath = "audios/"+trials[count].audiosNames[2]+".mp3"
            let starsRef = storageRef.child(audPath)
            starsRef.downloadURL { url, error in
                if error != nil {
                    // Handle any errors
                } else {
                    // Get the download URL for 'images/stars.jpg'
                    let playerItem = AVPlayerItem(url: URL(string: url!.absoluteString)!)
                    self.playerAt = AVPlayer(playerItem: playerItem)
                    self.playerAt.play()
                }
            }
            cue5.isEnabled = true
            cue5.alpha = 1
        } else if sender.currentTitle == "الحرف الأول"{
            let text = trials[count].writtenCues[1]
            writtenCue.text = text
            cue6.isEnabled = true
            cue6.alpha = 1
        } else if sender.currentTitle == "الكلمة مكتوبة" {
            let text = trials[count].answer
            writtenCue.text = text
            cue7.isEnabled = true
            cue7.alpha = 1
        } else if sender.currentTitle == "الكلمة منطوقة"{
            let audPath = "audios/"+trials[count].audiosNames[3]+".mp3"
            let starsRef = storageRef.child(audPath)
            starsRef.downloadURL { url, error in
                if error != nil {
                    // Handle any errors
                } else {
                    // Get the download URL for 'images/stars.jpg'
                    let playerItem = AVPlayerItem(url: URL(string: url!.absoluteString)!)
                    self.playerAt = AVPlayer(playerItem: playerItem)
                    self.playerAt.play()
                }
            }
            writtenCue.text = ""
        }
    }
    
    //Utility functions
    
    
    func playSound(filename:String) {
        
        // Getting the url
        let url = Bundle.main.url(forResource: filename, withExtension: "mp3")
        
        // Make sure that we've got the url, otherwise abord
        guard url != nil else {
            return
        }
        
        // Create the audio player and play the sound
        do {
            audioPlayerFirst = try AVAudioPlayer(contentsOf: url!)
            audioPlayerFirst?.play()
        }
        catch {
            print("error")
        }
    }
    
}
extension TrialController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
}

extension TrialController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        finishPlayback()
    }
    
    
    // MARK: - Progess
    
        func setProgress(answer: String,result: String)  {
        //---
//            var progress : Progress
//
        var date=Date.getCurrentDate()
//            let date="13/3/2020"
//
//
//           progress = Progress ( answer: answer , result: result , date: date )
//
//            self.progresses.append( progress)
            
        //---
            
//            var answers: String? = nil
//            var results: String? = nil
//
//          //        var date=getDate()
//            if(answers ?? "").isEmpty{
//                       answers=answer
//            }
//            else   {
//                       answers = "\(answers)-\(answer)"
//            }
//
//             if(results ?? "").isEmpty{
//                                       results=result
//                      }
//                      else   {
//
//                      results = "\(results)-\(result)"
//                      }
//           //print for test
//            print("\(answers)")
            
            //-------
//            if UserDefaults.standard.string(forKey: Constants.currentAnswer) == nil{
//            db.collection("patients")
//                      .whereField("uid", isEqualTo :Auth.auth().currentUser!.uid)
//                      .getDocuments() { (querySnapshot, error) in
//                          if let error = error {
//                                  print(error.localizedDescription)
//                          } else if querySnapshot!.documents.count != 1 {
//                                  print("More than one documents or none")
//                          } else {
//                              let document = querySnapshot!.documents.first
//                              document!.reference.updateData([
//                                "progress": FieldValue.arrayUnion(["\(UserDefaults.standard.string(forKey: Constants.correcAnswer)),\(UserDefaults.standard.string(forKey: Constants.isAnswerCorrect))"])
//
//                              ])
//
//
//
//                        }}
            
            
            db.collection("patients")
                      .whereField("uid", isEqualTo :Auth.auth().currentUser!.uid)
                      .getDocuments() { (querySnapshot, error) in
                          if let error = error {
                                  print(error.localizedDescription)
                          } else if querySnapshot!.documents.count != 1 {
                                  print("More than one documents or none")
                          } else {
                              let document = querySnapshot!.documents.first
                              document!.reference.updateData([
                                "progress": FieldValue.arrayUnion(["\(answer),\(result),\(date)"])
                                 
                              ])
            
            
            
                        }}
            
            
    }
    
    
    func updateProgress() {
//       //----
////             let db = Firestore.firestore()
//
//        //update progress in DB with "progresses"
//                let uID = "SAYOVleHD3XWWMphbXTMtsPQaYg2"
//
//
//        //        let uID = UserDefaults.standard.string(forKey: Constants.selectedPatient)
//
//
//        let progressRef = db.collection("patients").document(uID)
//
//        // Atomically add a new region to the "regions" array field.
//        progressRef.updateData([
//            "progress": FieldValue.arrayUnion(["\(answers)"])
//        ])
//
//        print("-------------\(answers)")
//
//
//
//
////        var setWithMerge = progressRef.set({
////            capital: true
////        }, { merge: true });
//
//
                   //----
    }
    
    
}
