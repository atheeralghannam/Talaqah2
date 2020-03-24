//
//  SLPSettingsViewController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 24/03/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase

class SLPSettingsViewController: UIViewController {

    let db = Firestore.firestore()
       var categories = [""]
       var settings = [3,2,2,2]
    var uid = ""
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
          // Do any additional setup after loading the view.
      }
    
    @IBAction func ChoiceSelected(_ sender: UIButton) {
        if (sender.currentTitle! == "تحديد التصنيفات" ){
                   self.performSegue(withIdentifier: "toCat", sender: self)
               }
               
               //Verb
               if sender.currentTitle! == "تعيين مستوى التعقيد"{
                   self.performSegue(withIdentifier: "toCom", sender: self)
               }
        if sender.currentTitle! == "تفعيل/ إيقاف المحفزات"{
            //cues
             self.performSegue(withIdentifier: "cues", sender: self)
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "back", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "back"{
               let destnationVC = segue.destination as! DetailViewController
               destnationVC.modalPresentationStyle = .fullScreen
           }
           if segue.identifier == "toCat"{
               let destnationVC = segue.destination as! CatSLpViewController
               destnationVC.categories = categories
                destnationVC.settings = settings
            destnationVC.uid = uid
               destnationVC.modalPresentationStyle = .fullScreen
           }
           if segue.identifier == "toCom"{
               let destnationVC = segue.destination as! ComSLpViewController
               destnationVC.Settings = settings
            destnationVC.categories = categories
            destnationVC.uid = uid

            print(settings)
               destnationVC.modalPresentationStyle = .fullScreen
           }
        if segue.identifier == "cues"{
            let destnationVC = segue.destination as! SLPCuesViewController
                          destnationVC.settings = settings
                       destnationVC.cat = categories
                       destnationVC.uid = uid

                       print(settings)
                          destnationVC.modalPresentationStyle = .fullScreen
        }
    }

}
