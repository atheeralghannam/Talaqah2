//
//  SelsectWordsController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 21/02/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase

class SelsectWordsController: UIViewController {
    var adj = false
    var name = false
    var isthere = [false,false,false]
    var patient : Patient?
    let db = Firestore.firestore()
    var trials = [Trial]()
    var array = [Trial]()
    var  mcue = false,scue = false,tcue = false, frcue = false, fvcue = false , sxcue = false, svcue = false
    @IBOutlet weak var NamesButton: UIButton!
    @IBOutlet weak var VerbsButton: UIButton!
    @IBOutlet weak var AdjButton: UIButton!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    override func viewDidLoad() {
       // patint = getCurrentPatient()
        isThere()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        let tal = UIColor(named: "Tala")
               let gradientLayer = CAGradientLayer()
               gradientLayer.frame = self.view.bounds
               gradientLayer.colors = [tal!.cgColor, UIColor.white.cgColor]
               self.view.layer.insertSublayer(gradientLayer, at: 0)
        setUpButtons()
    }
    override var shouldAutorotate: Bool {
        return true
    }
    func setUpButtons(){
        Utilities.styleFilledButton(button: NamesButton)
        Utilities.styleFilledButton(button: VerbsButton)
        Utilities.styleFilledButton(button: AdjButton)
    }
    @IBAction func wordButtonPressed(_ sender: UIButton) {
         if sender.currentTitle! == "الصفات"{
                   if !isthere[1]{
                       let alertController = UIAlertController(title: "نأسف", message:
                                                 "حسب إعداداتك لا يوجد تمرين مناسب هنا", preferredStyle: .alert)
                                             alertController.addAction(UIAlertAction(title: "حسنًا", style: .default))
                                             
                                             self.present(alertController, animated: true, completion: nil)
                   }
                   else{
                   adj = true
                   self.performSegue(withIdentifier: "fromWordsToTrials", sender: self)
                   }
               }
               else if sender.currentTitle! == "الأفعال"{
                   if !isthere[2]{
                       let alertController = UIAlertController(title: "نأسف", message:
                                                                "حسب إعداداتك لا يوجد تمرين مناسب هنا", preferredStyle: .alert)
                                                            alertController.addAction(UIAlertAction(title: "حسنًا", style: .default))
                                                            
                                                            self.present(alertController, animated: true, completion: nil)
                   }else{
                   adj = false
                   self.performSegue(withIdentifier: "fromWordsToTrials", sender: self)
                   }
               }else if sender.currentTitle! == "الأسماء"{
                   if !isthere[0]{
                       let alertController = UIAlertController(title: "نأسف", message:
                                                                "حسب إعداداتك لا يوجد تمرين مناسب هنا", preferredStyle: .alert)
                                                            alertController.addAction(UIAlertAction(title: "حسنًا", style: .default))
                                                            
                                                            self.present(alertController, animated: true, completion: nil)
                   }
                   else if patient!.categories.isEmpty {
                       self.performSegue(withIdentifier: "fromWtoC", sender: self)}
                   else {
                       name = true
                       self.performSegue(withIdentifier: "fromWordsToTrials", sender: self)
                   }
                   
               }
           }
           func isThere(){
               for trial in trials {
                   if trial.type == "name"{
                       isthere[0] = true
                   }else if trial.type == "adj"{
                       isthere[1] = true
                   } else if trial.type == "verb" {
                       isthere[2] = true
                   }
               }
    }
    
    @IBAction func Home(_ sender: UIButton) {
        self.performSegue(withIdentifier: "Home", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "fromWordsToTrials" {
                   let destnationVC = segue.destination as! TrialController
                   if adj{
                       for trial in trials{
                           if trial.category == "adj"{
                               array.append(trial)
                           }
                       }
                       destnationVC.trials = array
                       destnationVC.modalPresentationStyle = .fullScreen
                   } else if !adj && !name {
                       for trial in trials{
                        if let pat = patient {
                        if trial.category == pat.Gender {
                               array.append(trial)
                           }
                       }else{
                           array.append(trial)
                       }
                    }
                       destnationVC.trials = array
                       destnationVC.modalPresentationStyle = .fullScreen
                   } else{
                       for trial in trials {
                        print(patient!.categories)
                        for category in patient!.categories {
                               if trial.category == category {
                                   print("category, trial")
                                   array.append(trial)
                           }
                       }
                       }
                       print(array)
                    destnationVC.trials = array
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
               else if segue.identifier == "fromWtoC"{
                   let destnationVC = segue.destination as! SelectCategoriesController
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
               else if segue.identifier == "Home" {
                   let destnationVC = segue.destination as! BaseViewController
                   destnationVC.trials = trials
                   destnationVC.patient = patient
                    destnationVC.mcue = mcue
                    destnationVC.scue = scue
                    destnationVC.tcue = tcue
                    destnationVC.frcue = frcue
                    destnationVC.fvcue = fvcue
                    destnationVC.sxcue = sxcue
                    destnationVC.svcue = svcue
                    destnationVC.cue = true
                   destnationVC.modalPresentationStyle = .fullScreen
               }
    }
}
