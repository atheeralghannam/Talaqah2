//
//  SpeachToText.swift
//  Login
//
//  Created by Atheer Alghannam on 13/06/1441 AH.
//  Copyright © 1441 Talaqah. All rights reserved.
//

import UIKit
import Firebase
import Speech

extension TrialController{
    
    
    
    
    func startRecordingFirst() throws {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .measurement, options: .interruptSpokenAudioAndMixWithOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        audioEngine.inputNode.removeTap(onBus: 0)
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            if(result?.bestTranscription.formattedString != nil){
                DispatchQueue.main.async {
                    
                    //todo textView speech
                    //                    self.textView.text =  (result?.bestTranscription.formattedString)!
                    
                }
                
            }
            
            if(result?.isFinal != nil)
            {  isFinal = (result?.isFinal)!}
            
            if isFinal || error != nil {
                let command = result?.bestTranscription.formattedString
                
                //here
                if command==nil{
                    UserDefaults.standard.set(nil, forKey: Constants.currentAnswer)
                    if #available(iOS 13.0, *) {
                        let validateImage = UIImage(systemName:"exclamationmark")
                        self.validateButton.setImage(validateImage, for: [])
                        self.validateButton.tintColor = UIColor.gray
                    } else {
                        // Fallback on earlier versions
                    }
                    self.validateButton.isHidden=false
                    return}
                
                if command != nil {
                    
                    let w1 = UserDefaults.standard.string(forKey: Constants.correcAnswer)
                    
                    let w2 = command
                    
                    UserDefaults.standard.set(command, forKey: Constants.currentAnswer)
                    
                    print(w1)
                    print(w1?.count)
                    for char in w1! {
                        print("Found character: \(char)")
                    }
                    
                    print(w2)
                    print(w2?.count)
                    for char in w2! {
                        print("Found character: \(char)")
                    }
                    
                    let substring = w2?.dropFirst(1)
                    
                    
                    let realword = String(substring!)
                    print(realword.count)
                    
                    for char in realword {
                        print("Found character: \(char)")
                    }
                    print(w1==realword)
                    if (w1==realword){
                        self.pressed = true
                        print(self.pressed)
                    }
                    
                    if (self.pressed && true){
                        self.countCoResult = self.countCoResult + 1
                        self.pressed = false
//                        self.updateProgress(answer: realword,result: "t")
                    } else {
                        
                        self.countFaResult = self.countFaResult + 1
                        self.pressed = false
//                        self.updateProgress(answer: realword,result: "f")
                    }
                    
                    
                    
                    UserDefaults.standard.set(w1==realword, forKey:Constants.isAnswerCorrect)
                    if w1 == realword  {
                        if #available(iOS 13.0, *) {
                            let validateImage = UIImage(systemName:"checkmark")
                            self.validateButton.setImage(validateImage, for: [])
                            self.validateButton.tintColor = UIColor.green
                        } else {
                            // Fallback on earlier versions
                        }
                        self.validateButton.isHidden=false
                    }
                    else if w1 != realword {
                        if #available(iOS 13.0, *) {
                            let validateImage = UIImage(systemName:"xmark")
                            self.validateButton.setImage(validateImage, for: [])
                            self.validateButton.tintColor = UIColor.red
                        } else {
                            // Fallback on earlier versions
                        }
                        self.validateButton.isHidden=false
                    }
                    self.audioEngine.inputNode.removeTap(onBus: 0)
                    
                    self.audioEngine.stop()
                    
                    self.recognitionRequest?.endAudio()
                    
                }
                
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
            
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
    }
    
    
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("", for: [])
            //            recordButton.setTitle("Start Recording", for: [])
            
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition not available", for: .disabled)
        }
    }
    
    
//
//    func updateProgress(answer: String,result: String)  {
////        var date=getDate()
//        var date="13/3/2020"
//
//        var db = Firestore.firestore()
//
//        progress = new Progress(answer: answer,result: result,date: date)
//
//        progesses.append(progress)
//        //----
//
//           db.collection("patients").whereField("uid", isEqualTo:Auth.auth().currentUser!.uid)
//                  .getDocuments {(snapshot, error) in
//
//                       if let error = error{print(error.localizedDescription)}
//                       else {
//                             if let snapshot = snapshot {
//                            for document in snapshot.documents{
//                                      let data = document.data()
//
//
//                          self.mcue = data["cue1"] as! Bool
//
//                                 }}}
//
//
//         }
//
//
////        let washingtonRef = db.collection("cities").document("DC")
////
////        // Atomically add a new region to the "regions" array field.
////        washingtonRef.updateData([
////            "regions": FieldValue.arrayUnion(["greater_virginia"])
////        ])
////
////         db.collection("cities").document("DC").update( {
////           array : firebase.firestore.FieldValue.arrayUnion(progress)
////        });
//
////
////        var washingtonRef =  db.collection("patients").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid).doc("DC");
////
////        // Atomically add a new region to the "regions" array field.
////        washingtonRef.update({
////            regions: firebase.firestore.FieldValue.arrayUnion("greater_virginia")
////        });
//
//        //----
//    }
    
}
