//
//  BaseViewController.swift
//  Talaqah
//
//  Created by Atheer Alghannam on 30/06/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase


class BaseViewController: UIViewController {
    var isLoad = false// to avoid redudnet trials
    var fcheck = false
    var scheck = false
    var tcheck = false
    var lcheck = false
    var patient : Patient?
    let db = Firestore.firestore()
    var trials = [Trial]()
    var categories = ["male","female", "adj", "animal", "body","personal", "family", "cloths", "food", "drinks", "vegetables", "fruits", "pots", "house", "furniture", "devices", "public", "transportation", "jobs", "shapes","colors"]
    var documents = ["names", "verbs", "adjectives"]
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewDidLoad() {
        //        super.viewDidLoad()
        if let pat = patient {
            //goood
            print("good", pat.FirstName)
        }else{
            getCurrentPatient()
        }
        //getCurrentPatient()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        let tal = UIColor(named: "Tala")
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [tal!.cgColor, UIColor.white.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startTrial" {
            let destnationVC = segue.destination as! SelsectWordsController
            destnationVC.trials = trials
            destnationVC.patient = patient
            destnationVC.modalPresentationStyle = .fullScreen
        }
        else if segue.identifier == "ViewProfile" {
            let destnationVC = segue.destination as! AccountViewController
            
            destnationVC.modalPresentationStyle = .fullScreen
        }else if segue.identifier == "toSettings"{ let destnationVC = segue.destination as! SettingsViewController
            destnationVC.categories = patient!.categories
            destnationVC.settings = patient!.settings
            destnationVC.patinet = patient
            destnationVC.modalPresentationStyle = .fullScreen
            
        }
    }
    
    @IBAction func Profile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ViewProfile", sender: self)
    }
    @IBAction func Start(_ sender: UIButton) {
        if (trials.isEmpty && !isLoad){
                   getTrials()
                   isLoad = true
               }
        if trials.isEmpty {
            let alertController = UIAlertController(title: "فضلًا انتظر", message:
                "يتم تحميل البيانات", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "حسنًا", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }else{
            self.performSegue(withIdentifier: "startTrial", sender: self)
        }
    }

    @IBAction func Settings(_ sender: UIButton) {
   if let pat = patient{
    
    if pat.slpUid != ""{
        let alertController = UIAlertController(title: "عذرًا لا تستطيع تخصيص الإعدادات", message:
            "يوجد إخصائي لديك لذا لا تستطيع تخصيص الإعدادات", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "حسنًا", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }else{
         self.performSegue(withIdentifier: "toSettings", sender: self)
    }
   }else {
            getCurrentPatient()
            let alertController = UIAlertController(title: "فضلًا انتظر", message:
                       "يتم تحميل البيانات", preferredStyle: .alert)
                   alertController.addAction(UIAlertAction(title: "حسنًا", style: .default))
                   
                   self.present(alertController, animated: true, completion: nil)
               }
//        else if patient!.slpUid != ""{
//            let alertController = UIAlertController(title: "عذرًا لا تستطيع تخصيص الإعدادات", message:
//                "يوجد إخصائي لديك لذا لا تستطيع تخصيص الإعدادات", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "حسنًا", style: .default))
//
//            self.present(alertController, animated: true, completion: nil)
//        }else{
//             self.performSegue(withIdentifier: "toSettings", sender: self)
//        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        
        
        let refreshAlert = UIAlertController(title: "تسجيل الخروج", message: "هل أنت متأكد من أنك تريد تسجيل الخروج؟", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "نعم", style: .default, handler: { (action: UIAlertAction!) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print ("signing out DONE")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            print("Handle Ok logic here")
            UserDefaults.standard.set(false, forKey:Constants.isUserLoggedIn)
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "startingScreen") as! UIViewController
            
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDel.window?.rootViewController = loginVC
            
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "لا", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func getCurrentPatient()  {
        var pEmail = String(), fName = String(), lName = String(), pGender = String(), pnID = String(), phoneNumber = String(), puid = String(), pcateg = [String](),psettings = [Int](), pslpuid = String()
        let db = Firestore.firestore()
        db.collection("patients").whereField("uid", isEqualTo:Auth.auth().currentUser!.uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if querySnapshot!.documents.count != 1 {
                print("More than one documents or none")
            }
                
            else {
                
                let document = querySnapshot!.documents.first
                let data = document!.data()
                
                //self.pEmail = data["Email"] as? String ?? ""
                pEmail = data["Email"] as! String
                fName = data["FirstName"] as! String
                lName = data["LastName"] as! String
                pGender = data["Gender"] as! String
                pnID = data["NID"] as! String
                phoneNumber = data["PhoneNumber"] as! String
                puid = data["uid"] as! String
                pcateg = data["categories"] as! [String]
                psettings = data["settings"] as! [Int]
                pslpuid = data["slpUid"] as! String
                
                let patient = Patient(NID: pnID, FirstName: fName, LastName: lName, Gender: pGender, PhoneNumber: phoneNumber, Email: pEmail, uid: puid, categories: pcateg, settings: psettings, slpUid: pslpuid)
                self.patient = patient
            }
            
        }
        
    }
    func getTrials(){
        for document in documents{
            let docRef = db.collection("trials").document(document)
            if document == "names"{
                categories = ["animal", "body","personal", "family", "cloths", "food", "drinks", "vegetables", "fruits", "pots", "house", "furniture", "devices", "public", "transportation", "jobs", "shapes","colors"]
                if let pat = patient {
                    if !pat.categories.isEmpty {
                for ctegory in categories {
                    let ix = categories.firstIndex(of: ctegory)
                        if !pat.categories.contains(ctegory){
                            categories.remove(at: ix!)
                        }
                }
            }
                }
            }
            else if document == "verbs"{
                if let pat = patient{
                    categories = [pat.Gender]
                    print(categories)
                }
            } else {
                categories = ["adj"]
            }
            for category in categories {
                let doc = docRef.collection(category)
                doc.getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            if !data.isEmpty   {
                                let s = data["settings"] as! Array<Int>
                                if let pat = self.patient{
//                                    print("Settings: " +  String(s.elementsEqual(patient.settings)))
                                    var i = 0
                                    for set in pat.settings {
                                        self.settings(a: set, b: s[i], index : i)
                                        i += 1
                                    }
                                    if !self.fcheck && !self.scheck && !self.tcheck && !self.lcheck{
                                        self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                            , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                                Array<String>, settings: data["settings"] as! Array<Int>, category: category, type: data["type"] as! String))
                                    } //end of if no one need check
                                    else if self.fcheck{
                                        if s[0] == pat.settings[0]{
                                            if !self.scheck && !self.tcheck && !self.lcheck {
                                                self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                                    , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                                        Array<String>, settings: data["settings"] as! Array<Int>, category: category , type: data["type"] as! String))
                                            }// end of if just first one need check
                                            else if self.scheck {
                                                if s[1] == pat.settings[1]{
                                                    if  !self.tcheck && !self.lcheck {
                                                        self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                                            , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                                                Array<String>, settings: data["settings"] as! Array<Int>, category: category , type: data["type"] as! String))
                                                    }// end of just second and one need check
                                                    else if self.tcheck {
                                                        if s[2] == pat.settings [2] || s[2] == -1{
                                                            if !self.lcheck {
                                                                self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                                                    , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                                                        Array<String>, settings: data["settings"] as! Array<Int>, category: category , type: data["type"] as! String))
                                                            }// just first 3 needs check
                                                            else if self.lcheck {
                                                                if s[3] == pat.settings[3] || s[3] == -1{
                                                                    self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                                                        , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                                                            Array<String>, settings: data["settings"] as! Array<Int>, category: category , type: data["type"] as! String))
                                                                }// all right
                                                            }// all needs check
                                                        }// if third and 2nd and 1st are right
                                                    }// end of third and second and first needs check
                                                    else if self.lcheck {
                                                        if s[3] == pat.settings[3] || s[3] == -1{
                                                            self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                                                , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                                                    Array<String>, settings: data["settings"] as! Array<Int>, category: category , type: data["type"] as! String))
                                                        }//end of last are right
                                                    }// end of 1st and 2nd and 4th need check
                                                    
                                                }// end of if second and first are right
                                            }// end of second and one need check
                                            else if self.tcheck {
                                                if s[2] == pat.settings[2] || s[2] == -1{
                                                    if !self.lcheck{
                                                        self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                                            , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                                                Array<String>, settings: data["settings"] as! Array<Int>, category: category , type: data["type"] as! String))
                                                    }// end of 4th and 2nd dont need check
                                                    else if self.lcheck{
                                                        if s[3] == pat.settings[3] || s[3] == -1{
                                                            self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                                                , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                                                    Array<String>, settings: data["settings"] as! Array<Int>, category: category , type: data["type"] as! String))
                                                        }// end of 4th is right
                                                    }/// end of all need check exept 2nd
                                                }//end of  3rd check is right
                                            }// end of 1st and 3rd need check 2nd dont need
                                            else if self.lcheck {
                                                if s[3] == pat.settings[3] || s[3] == -1{
                                                    self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                                        , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                                            Array<String>, settings: data["settings"] as! Array<Int>, category: category , type: data["type"] as! String))
                                                }// end of 4th is right
                                            }// end of 4th and 1st just need check
                                        }// end of if first is right
                                    }//end of if first one need check
                                    else if self.scheck {
                                        if s[1] == pat.settings[1]{
                                            if  !self.tcheck && !self.lcheck {
                                                self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                                    , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                                        Array<String>, settings: data["settings"] as! Array<Int>, category: category , type: data["type"] as! String))
                                            }// end of just second need check
                                            else if self.tcheck {
                                                if s[2] == pat.settings [2] || s[2] == -1 {
                                                    if !self.lcheck {
                                                        self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                                            , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                                                Array<String>, settings: data["settings"] as! Array<Int>, category: category , type: data["type"] as! String))
                                                    }// just 2nd and 3rd needs check
                                                    else if self.lcheck {
                                                        if s[3] == pat.settings[3] || s[3] == -1{
                                                            self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                                                , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                                                    Array<String>, settings: data["settings"] as! Array<Int>, category: category , type: data["type"] as! String))
                                                        }// all right
                                                    }// all needs check
                                                }// if third and 2nd are right
                                            }// end of third and second needs check
                                            else if self.lcheck {
                                                if s[3] == pat.settings[3] || s[3] == -1{
                                                    self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                                        , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                                            Array<String>, settings: data["settings"] as! Array<Int>, category: category , type: data["type"] as! String))
                                                }//end of last are right
                                            }// end of 2nd and 4th need check
                                        }// end of if second is right
                                    }// end of second check first not
                                    else if self.tcheck {
                                        if s[2] == pat.settings [2] || s[2] == -1{
                                            if !self.lcheck {
                                                self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                                    , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                                        Array<String>, settings: data["settings"] as! Array<Int>, category: category , type: data["type"] as! String))
                                            }// just 2nd and 3rd needs check
                                            else if self.lcheck {
                                                if s[3] == pat.settings[3] || s[3] == -1{
                                                    self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                                        , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                                            Array<String>, settings: data["settings"] as! Array<Int>, category: category , type: data["type"] as! String))
                                                }// all right
                                            }// all needs check
                                        }// if third and 2nd are right
                                    }// end of third and second needs check
                                    else if self.lcheck {
                                        if s[3] == pat.settings[3] || s[3] == -1{
                                            self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                                , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                                    Array<String>, settings: data["settings"] as! Array<Int>, category: category , type: data["type"] as! String))
                                        }//end of last are right
                                    }// end of 2nd and 4th need check
                                } // end of if succesfull read patint
                            }// end of if data not empty
                        }// end of read snapshpt
                    }// end pf each trial
                }//end of each doucemnt
            }// end of categories
        }// end document (verbs, names, adj)
    }// end trials
    
    func settings(a : Int , b: Int, index : Int){
        // a == 3 at index 0 (all syllable)
        if a == 3 && index == 0 {
            fcheck = false
        }
            //a == 2 at index != 0
        else if a == 2 && index != 0 {
            switch index {
            case 1:
                scheck = false
            case 2:
                tcheck = false
            default:
                lcheck = false
            }
        }
            //a != 3 at index 0 (spesfice)
        else if index == 0 && a != 3 {
            fcheck = true
        }
            // a!=2 at index != 0
        else if index != 0 && a != 2 {
            switch index {
            case 1:
                scheck = true
            case 2:
                tcheck = true
            default:
                lcheck = true
            }
        }
    }
    
}
