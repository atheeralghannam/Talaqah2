//
//  HelpViewController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 06/03/2020.
//  Copyright © 2020 Talaqah. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    var  mcue = false,scue = false,tcue = false, frcue = false, fvcue = false , sxcue = false, svcue = false
    var trials = [Trial]()
    var patient : Patient?
       override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewDidLoad() {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        // Do any additional setup after loading the view.
    }
    @IBAction func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "back", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          let destnationVC = segue.destination as! TrialController
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
