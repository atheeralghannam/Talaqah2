//
//  LViewController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 06/05/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit

class LViewController: UIViewController {

    @IBOutlet weak var animatingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        animatingLabel.text = ""
       
//         Timer.invalidate()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(animateAppName), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   @objc func finish() {
           performSegue(withIdentifier: "main", sender: self)
    }
    @objc func animateAppName() {
        animatingLabel.text = ""
        
        let appName = "(وَاحْلُلْ عُقْدَةً مِّن لِّسَانِي)"

        // New code using Timer class
         for char in appName {
                  animatingLabel.text! += "\(char)"
                  RunLoop.current.run(until: Date()+0.12)
              }
        
        /**
        // Older Code using Run loop to block the UI
        for char in appName {
            animatingLabel.text! += "\(char)"
            RunLoop.current.run(until: Date()+0.12)
        }
        */
         Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(finish), userInfo: nil, repeats: false)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "main"{
        let destinationViewController = segue.destination as! StartViewController
        destinationViewController.modalPresentationStyle = .fullScreen
            
        }
    }
}
