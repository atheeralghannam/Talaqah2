//
//  TrialController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 20/02/2020.
//  Copyright © 2020 Talaqah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import Speech
import AVFoundation
import AVKit
import SCLAlertView

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
    var isLoad = false
    
    
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
            destnationVC.patient = patient
            destnationVC.modalPresentationStyle = .fullScreen
        }
        else if segue.identifier == "help"{
            let destnationVC = segue.destination as! HelpViewController
            destnationVC.trials = trials
            destnationVC.patient = patient
            destnationVC.mcue = mcue
            destnationVC.scue = scue
            destnationVC.tcue = tcue
            destnationVC.frcue = frcue
            destnationVC.fvcue = fvcue
            destnationVC.sxcue = sxcue
            destnationVC.svcue = svcue
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
        // create the alert
        var result = String()
        result = "عدد الإجابات الصحيحة  " + String(countCoResult) + "\n" + "عدد الإجابات الخاطئة  " + String(countFaResult)
        if countCoResult > countFaResult {
        SCLAlertView().showCustom("احسنت", subTitle: "معظم الاجابات كانت صحيحه"+"\n" + result, color: UIColor(named: "Gold")! , icon: UIImage(named: "gold")!, closeButtonTitle: "حسنًا")
        } else if countFaResult == countCoResult {
        SCLAlertView().showCustom("كدت تصل", subTitle: "الاجابات الخاطئه والصحيحه متساويه"+"\n" + result, color: UIColor(named: "Silver")! , icon: UIImage(named: "silver")!, closeButtonTitle: "حسنًا")
        } else {
        SCLAlertView().showCustom("تمرن أكثر", subTitle: "معظم الاجابات كانت خاطئه"+"\n" + result, color: UIColor(named: "Bronze")! , icon: UIImage(named: "bronze")!, closeButtonTitle: "حسنًا")
        }
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
        //if nill ..... no answer
        if UserDefaults.standard.string(forKey: Constants.currentAnswer) == nil{
             SCLAlertView().showCustom("لا توجد إجابة", subTitle: "حاول مجددًا", color: UIColor(named: "Silver")! , icon: UIImage(named: "excmark")!, closeButtonTitle: "حسنًا")
            self.playSound(filename: "NoAnswer", ext: "mp3")

            return;
        }
       else if (UserDefaults.standard.bool(forKey: Constants.isAnswerCorrect) == true){
             SCLAlertView().showSuccess("إجابة صحيحة", subTitle: "أحسنت!", closeButtonTitle: "حسنًا")
            self.playSound(filename: "Correct", ext: "mp3")
            setProgress( answer: trials[count].answer ,result: "t")
        }
        else{
            SCLAlertView().showError("إجابة خاطئة", subTitle: "حظ أوفر", closeButtonTitle: "حسنًا")
            self.playSound(filename: "Wrong", ext: "mp3")
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
        
        if mcue == false
        { self.cue1.isUserInteractionEnabled = false
            self.cue1.setTitleColor(.gray, for: .normal)
            self.cue1.alpha = 0.54
        }
        
        
        if scue == false
        { self.cue2.isUserInteractionEnabled = false
            self.cue2.setTitleColor(.gray, for: .normal)
            self.cue2.alpha = 0.54
        }
        
        
        
        if tcue == false
        { self.cue3.isUserInteractionEnabled = false
            self.cue3.setTitleColor(.gray, for: .normal)
            self.cue3.alpha = 0.54
        }
        
        
        if frcue == false
        { self.cue4.isUserInteractionEnabled = false
            self.cue4.setTitleColor(.gray, for: .normal)
            self.cue4.alpha = 0.54
        }
        
        
        if fvcue == false
        { self.cue5.isUserInteractionEnabled = false
            self.cue5.setTitleColor(.gray, for: .normal)
            self.cue5.alpha = 0.54
        }
        
        if sxcue == false
        { self.cue6.isUserInteractionEnabled = false
            self.cue6.setTitleColor(.gray, for: .normal)
            self.cue6.alpha = 0.54
        }
        
        
        if svcue == false
        { self.cue7.isUserInteractionEnabled = false
            self.cue7.setTitleColor(.gray, for: .normal)
            self.cue7.alpha = 0.54
        }
        
        print(mcue, scue, tcue, frcue,fvcue, sxcue, svcue)
        // if it not okay to disabled
        var notOk2 = false
        var notOk3 = false
        var notOk4 = false
        var notOk5 = false
        var notOk6 = false
        print(trials, count)
        if scue == true && mcue == true{
            cue2.isEnabled = false
            cue2.alpha = 0.54
        }else if scue == false && mcue == false{
            notOk2 = true
        }
        if tcue == true && notOk2 == false{
            cue3.isEnabled = false
            cue3.alpha = 0.54
        }else if tcue == false && scue == false && mcue == false {
          notOk3 = true
        }
        if frcue == true && notOk3 == false {
            cue4.isEnabled = false
            cue4.alpha = 0.54
        }else if frcue == false && tcue == false && scue == false && mcue == false{
            notOk4 = true
        }
        if fvcue == true && notOk4 == false {
            cue5.isEnabled = false
            cue5.alpha = 0.54
        }else if fvcue == false && frcue == false && tcue == false && scue == false && mcue == false {
            notOk5 = true
        }
        if sxcue == true && notOk5 == false{
            cue6.isEnabled = false
            cue6.alpha = 0.54
        }else if sxcue == false && fvcue == false && frcue == false && tcue == false && scue == false && mcue == false  {
            notOk6 = true
        }
        if svcue == true && notOk6 == false {
            cue7.isEnabled = false
            cue7.alpha = 0.54
        }
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
            self.playSound(filename: "canYouNaming", ext: "mp3")
           
        }
         trials[self.count].isShown = true
        // Perform operation.
        //audio
        
        if count == trials.count-1 {
             nextButton.isHidden = true
        }
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
            if (count < trials.count-1){
            prevButton.isHidden = false
            count += 1
            showCurrentTrial()
            }
            else {
//                showCurrentTrial()
                nextButton.isHidden = true
//                nextButton.isEnabled = false
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
                if scue{
                    cue2.isEnabled = true
                    cue2.alpha = 1
                } else if tcue {
                    cue3.isEnabled = true
                    cue3.alpha = 1
                } else if frcue {
                    cue4.isEnabled = true
                    cue4.alpha = 1
                } else if fvcue {
                    cue5.isEnabled = true
                    cue5.alpha = 1
                }else if sxcue {
                    cue6.isEnabled = true
                    cue6.alpha = 1
                }else if svcue {
                    cue7.isEnabled = true
                    cue7.alpha = 1
                }
            } else if sender.currentTitle == "جملة"{
                let text = trials[count].writtenCues[0]
                writtenCue.text = text
                if tcue {
                    cue3.isEnabled = true
                    cue3.alpha = 1
                } else if frcue {
                    cue4.isEnabled = true
                    cue4.alpha = 1
                } else if fvcue {
                    cue5.isEnabled = true
                    cue5.alpha = 1
                }else if sxcue {
                    cue6.isEnabled = true
                    cue6.alpha = 1
                }else if svcue {
                    cue7.isEnabled = true
                    cue7.alpha = 1
                }
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
                if frcue {
                    cue4.isEnabled = true
                    cue4.alpha = 1
                } else if fvcue {
                    cue5.isEnabled = true
                    cue5.alpha = 1
                }else if sxcue {
                    cue6.isEnabled = true
                    cue6.alpha = 1
                }else if svcue {
                    cue7.isEnabled = true
                    cue7.alpha = 1
                }
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
                if fvcue {
                    cue5.isEnabled = true
                    cue5.alpha = 1
                }else if sxcue {
                    cue6.isEnabled = true
                    cue6.alpha = 1
                }else if svcue {
                    cue7.isEnabled = true
                    cue7.alpha = 1
                }
            } else if sender.currentTitle == "الحرف الأول"{
                let text = trials[count].writtenCues[1]
                writtenCue.text = text
                if sxcue {
                    cue6.isEnabled = true
                    cue6.alpha = 1
                }else if svcue {
                    cue7.isEnabled = true
                    cue7.alpha = 1
                }
            } else if sender.currentTitle == "الكلمة مكتوبة" {
                let text = trials[count].answer
                writtenCue.text = text
                if svcue {
                    cue7.isEnabled = true
                    cue7.alpha = 1
                }
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
    
    
    func playSound(filename:String, ext:String) {
        
        // Getting the url
        let url = Bundle.main.url(forResource: filename, withExtension: ext)
        
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
    
        let date=Date.getCurrentDate()
            
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
