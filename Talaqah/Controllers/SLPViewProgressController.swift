//
//  SLPViewProgressController.swift
//  Talaqah
//
//  Created by Horiah on 28/07/1441 AH.
//  Copyright © 1441 Talaqah. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import SCLAlertView
class SLPViewProgressController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet var send: UIBarButtonItem!
    let db = Firestore.firestore()
    var pEmail = String()
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
                           print("email")
                       let mail = MFMailComposeViewController()
                       mail.mailComposeDelegate = self
                       db.collection("slps").whereField("uid", isEqualTo:Auth.auth().currentUser!.uid).getDocuments { (snapshot, error) in
                           if let error = error {
                               print(error.localizedDescription)
                           } else {
                               if let snapshot = snapshot {
                                   
                                   for document in snapshot.documents {
                                       let data = document.data()
                                       self.pEmail = data["email"] as! String
                                    print(self.pEmail)
                                       //print("I send email")
                                   }
                               }
                           }
                           // from talagah to SLP check
                           //mail.setToRecipients(["horalfaisal2016@gmail.com"])
                           //mail.setToRecipients([self.pEmail])
                           //mail.setToRecipients(["horalfaisal2016@gmail.com","horalfaisal2016@gmail.com"])
                       }
                        //message.append(Auth.auth().currentUser!.email!)
            mail.setToRecipients([pEmail])
                           mail.setSubject("تقدم حالة المريض")
                           mail.setMessageBody("هنا سيكون تقدم حالة المريض", isHTML: false)
                           self.present(mail, animated: true)
                           
                       } else {
                           // show failure alert
                       
                                   print("Cannot send email")
               // create the alert
            SCLAlertView().showInfo("", subTitle: "لم يتم ربط هذا الجهاز بحساب البريد الإلكتروني. يرجى تسجيل الدخول إلى بريدك الإلكتروني في برنامج Mail,Gmail,...", closeButtonTitle: "حسنا")

                       }
           
              func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
               switch result.rawValue {
                           case MFMailComposeResult.cancelled.rawValue:
                               print("Cancelled")
                           case MFMailComposeResult.saved.rawValue:
                               print("Saved")
                           case MFMailComposeResult.sent.rawValue:
                               print("Sent")
                           case MFMailComposeResult.failed.rawValue:
                               print("Error: \(String(describing: error?.localizedDescription))")
                           default:
                               break
                           }
              controller.dismiss(animated: true)
    }
}
}
