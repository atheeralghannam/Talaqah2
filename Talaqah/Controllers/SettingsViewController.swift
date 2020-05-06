//
//  SettingsViewController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 24/03/2020.
//  Copyright © 2020 Talaqah. All rights reserved.
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
    
    @IBAction func toCom(_ sender: UIButton) {
         self.performSegue(withIdentifier: "toCom", sender: self)
    }
    @IBAction func toCat(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toCat", sender: self)
    }
    @IBAction func toCues(_ sender: UIButton) {
        self.performSegue(withIdentifier: "cues", sender: self)
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
        if segue.identifier == "cues"{
            let destnationVC = segue.destination as! patientCuesViewController
            destnationVC.settings = settings
            destnationVC.categories = categories
            destnationVC.patient = patinet
            
            print(settings)
            destnationVC.modalPresentationStyle = .fullScreen
        }
    }
    
   
}
