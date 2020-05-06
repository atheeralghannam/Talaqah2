//
//  SLPCuesViewController.swift
//  Talaqah
//
//  Created by Atheer Alghannam on 22/03/2020.
//  Copyright © 2020 Talaqah. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
class SLPCuesViewController: UIViewController {
    
    @IBOutlet var cue1: UISwitch!
    @IBOutlet var cue2: UISwitch!
    @IBOutlet var cue3: UISwitch!
    @IBOutlet var cue4: UISwitch!
    @IBOutlet var cue5: UISwitch!
    @IBOutlet var cue6: UISwitch!
    @IBOutlet var cue7: UISwitch!
    var settings = [0]
    var cat = [""]
    var uid = ""
    var patient : Patient?
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSwitches()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "back", sender: self)
    }
    
    @IBAction func save(_ sender: UIButton) {
    }
    func updateCues(){
        self.db.collection("patients").whereField("uid", isEqualTo :Auth.auth().currentUser!.uid)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    SCLAlertView().showCustom( "لم يتم حفظ التغييرات", subTitle: "تاكد من اتصالك ثم انقر حفظ ليتم حفظ التغييرات", color: UIColor(named: "Silver")! , icon: UIImage(named: "excmark")!, closeButtonTitle: "حسنًا")
                    print(error.localizedDescription)
                } else if querySnapshot!.documents.count != 1 {
                    print("More than one documents or none")
                } else {
                    let document = querySnapshot!.documents.first
                    document!.reference.updateData([
                        "cue1": self.cue1.isOn,
                        "cue2": self.cue2.isOn,
                        "cue3": self.cue3.isOn,
                        "cue4": self.cue4.isOn,
                        "cue5": self.cue5.isOn,
                        "cue6": self.cue6.isOn,
                        "cue7": self.cue7.isOn
                    ])
                }
        }
        SCLAlertView().showCustom("تم الحفظ", subTitle: "تم حفظ تغييراتك بنجاح!", color: UIColor(named: "Done")! , icon: UIImage(named: "saved")!, closeButtonTitle: "حسنًا")
        
    }
    func setupSwitches(){
        
        db.collection("patients").whereField("uid", isEqualTo:UserDefaults.standard.string(forKey: Constants.selectedPatient)).getDocuments {(snapshot, error) in
            if let error = error{print(error.localizedDescription)}
            else {
                if let snapshot = snapshot {
                    for document in snapshot.documents{
                        let data = document.data()
                        
                        self.cue1.isOn = data["cue1"] as! Bool
                        self.cue2.isOn = data["cue2"] as! Bool
                        self.cue3.isOn = data["cue3"] as! Bool
                        self.cue4.isOn = data["cue4"] as! Bool
                        self.cue5.isOn = data["cue5"] as! Bool
                        self.cue6.isOn = data["cue6"] as! Bool
                        self.cue7.isOn = data["cue7"] as! Bool
                        
                    }}}}
        
    }
    
    @IBAction func cue1Clicked(_ sender: Any) {
        if cue1.isOn {
            
            cue1.setOn(true, animated:true)
        } else {
            
            cue1.setOn(false, animated:true)
        }
    }
    
    @IBAction func cue2Clicked(_ sender: Any) {
        if cue2.isOn {
            
            cue2.setOn(true, animated:true)
        } else {
            
            cue2.setOn(false, animated:true)
        }
    }
    @IBAction func cue3Clicked(_ sender: Any) {
        if cue3.isOn {
            
            cue3.setOn(true, animated:true)
        } else {
            
            cue3.setOn(false, animated:true)
        }
    }
    @IBAction func cue4Clicked(_ sender: Any) {
        if cue4.isOn {
            
            cue4.setOn(true, animated:true)
        } else {
            
            cue4.setOn(false, animated:true)
        }
    }
    @IBAction func cue5Clicked(_ sender: Any) {
        if cue5.isOn {
            
            cue5.setOn(true, animated:true)
        } else {
            
            cue5.setOn(false, animated:true)
        }
    }
    @IBAction func cue6Clicked(_ sender: Any) {
        if cue6.isOn {
            
            
            cue6.setOn(true, animated:true)
        } else {
            
            
            cue6.setOn(false, animated:true)
        }
        
    }
    @IBAction func cue7Clicked(_ sender: Any) {
        if cue7.isOn {
            
            cue7.setOn(true, animated:true)
        } else {
            
            cue7.setOn(false, animated:true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back"{
            let destnationVC = segue.destination as! SLPSettingsViewController
            destnationVC.settings = settings
            destnationVC.categories = cat
            destnationVC.uid = uid
            destnationVC.patient = patient
            print(settings)
            destnationVC.modalPresentationStyle = .fullScreen
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override var shouldAutorotate: Bool {
        return true
    }
}
