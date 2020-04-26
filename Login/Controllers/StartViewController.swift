//
//  StartViewController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 26/04/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit


class StartViewController: UIViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
          return .portrait
      }
      override var shouldAutorotate: Bool {
          return true
      }
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        // Do any additional setup after loading the view.
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "loginPatient"{
//            let destnationVC = segue.destination as! LoginViewController
//            destnationVC.modalPresentationStyle = .fullScreen
//        }else if segue.identifier == "loginSLP"{
//            let destnationVC = segue.destination as! slpLoginViewController
//            destnationVC.modalPresentationStyle = .fullScreen
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
