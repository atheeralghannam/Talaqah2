//
//  StartViewController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 26/04/2020.
//  Copyright © 2020 Talaqah. All rights reserved.
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

}
