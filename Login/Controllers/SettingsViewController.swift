//
//  SettingsViewController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 24/03/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    let db = Firestore.firestore()
    var categories = [""]
    var settings = [3,2,2,2]
    var patinet : Patient?
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
    @IBAction func Home(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toHome", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "toHome"{
               let destnationVC = segue.destination as! BaseViewController
                destnationVC.patient = patinet
               destnationVC.modalPresentationStyle = .fullScreen
           }
           if segue.identifier == "toCat"{
               let destnationVC = segue.destination as! CategoriesViewController
               destnationVC.categories = categories
                destnationVC.settings = settings
                destnationVC.patient = patinet

               destnationVC.modalPresentationStyle = .fullScreen
           }
           if segue.identifier == "toCom"{
               let destnationVC = segue.destination as! ComplixityViewController
               destnationVC.Settings = settings
            destnationVC.categories = categories
            destnationVC.patient = patinet

            print(settings)
               destnationVC.modalPresentationStyle = .fullScreen
           }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
