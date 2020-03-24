//
//  ComSLpViewController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 24/03/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase
class ComSLpViewController: UIViewController {

    @IBOutlet weak var zeroSyla: UIButton!
    @IBOutlet weak var oneSyla: UIButton!
    @IBOutlet weak var towSyla: UIButton!
    @IBOutlet weak var threeSyla: UIButton!
    @IBOutlet weak var zeroFrq: UIButton!
    @IBOutlet weak var oneFrq: UIButton!
    @IBOutlet weak var towFrq: UIButton!
    @IBOutlet weak var zeroTran: UIButton!
    @IBOutlet weak var oneInTran: UIButton!
    @IBOutlet weak var towTran: UIButton!
    @IBOutlet weak var zeroCon: UIButton!
    @IBOutlet weak var oneAbs: UIButton!
    @IBOutlet weak var towCon: UIButton!
    
    var uid = ""
    var Settings = [3,2,2,2]
    let db = Firestore.firestore()
    var isCat = false
    var categories = [""]
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
                 return .landscapeLeft
             }
             override var shouldAutorotate: Bool {
                 return true
             }
          override func viewDidLoad() {
              super.viewDidLoad()
              let value = UIInterfaceOrientation.landscapeLeft.rawValue
                 UIDevice.current.setValue(value, forKey: "orientation")
                 let tal = UIColor(named: "Tala")
                 let gradientLayer = CAGradientLayer()
                 gradientLayer.frame = self.view.bounds
                 gradientLayer.colors = [tal!.cgColor, UIColor.white.cgColor]
                 self.view.layer.insertSublayer(gradientLayer, at: 0)
                   initCheckedBoxes()
          }
    
    @IBAction func Syla(_ sender: UIButton) {
        switch sender.currentTitle {
         case "0":
             zeroSyla.isSelected = true
             oneSyla.isSelected = false
             towSyla.isSelected = false
             threeSyla.isSelected = false
         case "1":
             zeroSyla.isSelected = false
             oneSyla.isSelected = true
             towSyla.isSelected = false
             threeSyla.isSelected = false
         case "2":
             zeroSyla.isSelected = false
             oneSyla.isSelected = false
             towSyla.isSelected = true
             threeSyla.isSelected = false
         default:
             zeroSyla.isSelected = false
             oneSyla.isSelected = false
             towSyla.isSelected = false
             threeSyla.isSelected = true
         }
         fillSettings(setting: Int(sender.currentTitle!)!,index: 0)
    }
    @IBAction func Freq(_ sender: UIButton) {
        switch sender.currentTitle {
        case "0":
            zeroFrq.isSelected = true
            oneFrq.isSelected = false
            towFrq.isSelected = false
        case "1":
            zeroFrq.isSelected = false
            oneFrq.isSelected = true
            towFrq.isSelected = false
        default:
            zeroFrq.isSelected = false
            oneFrq.isSelected = false
            towFrq.isSelected = true
        }
        fillSettings(setting: Int(sender.currentTitle!)!,index: 1)
    }
    @IBAction func Tran(_ sender: UIButton) {
        switch sender.currentTitle {
               case "0":
                   zeroTran.isSelected = true
                   oneInTran.isSelected = false
                   towTran.isSelected = false
               case "1":
                   zeroTran.isSelected = false
                   oneInTran.isSelected = true
                   towTran.isSelected = false
               default:
                   zeroTran.isSelected = false
                   oneInTran.isSelected = false
                   towTran.isSelected = true
               }
               fillSettings(setting: Int(sender.currentTitle!)!,index: 2)
    }
    @IBAction func Con(_ sender: UIButton) {
        switch sender.currentTitle {
        case "0":
            zeroCon.isSelected = true
            oneAbs.isSelected = false
            towCon.isSelected = false
        case "1":
            zeroCon.isSelected = false
            oneAbs.isSelected = true
            towCon.isSelected = false
        default:
            zeroCon.isSelected = false
            oneAbs.isSelected = false
            towCon.isSelected = true
        }
        fillSettings(setting: Int(sender.currentTitle!)!,index: 3)
    }
    @IBAction func Save(_ sender: UIButton) {
        updateSettings()
    }
    @IBAction func back(_ sender: UIButton) {
        if isCat{
                   self.performSegue(withIdentifier: "toCat", sender: self)
               }else{ self.performSegue(withIdentifier: "back", sender: self)
                   
               }
    }
    func fillSettings(setting: Int, index : Int){
         
         Settings[index] = setting
       
     }
     private func updateSettings(){
            //fill patient settings in firestore with the chocen ones
            db.collection("patients")
                .whereField("uid", isEqualTo : self.uid)
                .getDocuments() { (querySnapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if querySnapshot!.documents.count != 1 {
                        print("More than one documents or none")
                    } else {
                        let document = querySnapshot!.documents.first
                        document!.reference.updateData([
                            "settings" : self.Settings
                        ])
                    }
            }
            let alertController = UIAlertController(title: "تم الحفظ", message:
                "تم حفظ التغييرات بنجاح!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "حسنًا", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        
        func initCheckedBoxes(){
            var i = 0
            while i < Settings.count {
                if i == 0 {
                    switch Settings[i] {
                    case 0:
                        zeroSyla.isSelected = true
                    case 1:
                        oneSyla.isSelected = true
                    case 2:
                        towSyla.isSelected = true
                    default:
                        threeSyla.isSelected = true
                    }
                } else if i == 1 {
                    switch Settings[i] {
                    case 0:
                        zeroFrq.isSelected = true
                    case 1:
                        oneFrq.isSelected = true
                    default:
                        towFrq.isSelected = true
                    }
                }else if i == 2 {
                    switch Settings[i] {
                    case 0:
                        zeroTran.isSelected = true
                    case 1:
                        oneInTran.isSelected = true
                    default:
                        towTran.isSelected = true
                    }
                }else if i == 3 {
                    switch Settings[i] {
                    case 0:
                        zeroCon.isSelected = true
                    case 1:
                        oneAbs.isSelected = true
                    default:
                        towCon.isSelected = true
                    }
                }
                i+=1
            }
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "back"{
              let destnationVC = segue.destination as! SLPSettingsViewController
                       destnationVC.settings = Settings
                         destnationVC.categories = categories
            destnationVC.uid = uid
              destnationVC.modalPresentationStyle = .fullScreen
          }
          if segue.identifier == "toCat"{
              let destnationVC = segue.destination as! CatSLpViewController
                   destnationVC.settings = Settings
            destnationVC.uid = uid
                   destnationVC.categories = categories
              destnationVC.modalPresentationStyle = .fullScreen
          }
      }
}
