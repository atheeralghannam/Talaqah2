//
//  ProgressViewController.swift
//  Talaqah
//
//  Created by Horiah on 21/07/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import MessageUI

//class ProgressViewController: UIViewController, MFMailComposeViewControllerDelegate{
class ProgressViewController: UIViewController, MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    

    



//    class ProgressViewController: UITableViewController, MFMailComposeViewControllerDelegate {

        @IBOutlet var tableView: UITableView!
        
    
    @IBOutlet weak var sendButton: UIBarButtonItem!
    
    var progressArray = [Progress]()
    var db: Firestore!
    
    
    //    var progress : Progress
    //    var answer = ""
    //    var result = ""
    //    var date = ""
    
    var pEmail = String()
    var uID = String()

        
    
    
     //Tableview setup
        func numberOfSections(in tableView: UITableView) -> Int {
    
            return 1
        }
    //
    //            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //
    //                        print("Tableview setup \(progressArray.count)")
    //                return progressArray.count
    //            }
    //
    //            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //                let cell = tableView.dequeueReusableCell(withIdentifier: "progressCell", for: indexPath) as! ProgressCell
    //
    //          cell.configurateTheCell(progressArray[indexPath.row])
    //                print("Array is populated \(progressArray)")
    //        //        cell.accessoryType.
    //
    //
    //                return cell
    //            }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                              print("Tableview setup \(progressArray.count)")
                          return progressArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                  let cell = tableView.dequeueReusableCell(withIdentifier: "progressCell", for: indexPath) as! ProgressCell
           
                     cell.configurateCell(progressArray[indexPath.row])
                           print("Array is populated \(progressArray)")
                   //        cell.accessoryType.
           
           
                           return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
                       tableView.dataSource = self
                       tableView.delegate = self
        
        db = Firestore.firestore()
        loadData()
    }
    
    func loadData() {
        
        
        var progresses = [String()]
        
        let db = Firestore.firestore()

   if (UserDefaults.standard.bool(forKey: Constants.isUserLoggedIn) == true) {
    uID = Auth.auth().currentUser!.uid
   }else {
    uID = UserDefaults.standard.string(forKey: Constants.selectedPatient)!
        }
    
        
        db.collection("patients").whereField("uid", isEqualTo: uID ).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let snapshot = snapshot {
                    
                    for document in snapshot.documents {
                        
                        let data = document.data()
                        
                        //set one progress
                        progresses = data["progress"] as! [String]
                        
                        ////-----------
                        for singleProgress in progresses {
                            let fullTrail = singleProgress
                            let p : [Progress] = self.setProgress(singleProgress : fullTrail)
                            
                            self.progressArray.append(contentsOf: p)
                        }
                        
                    }
                    
                    
                    
                    self.tableView.reloadData()
                    
                    
                }
            }
        }
        
        
        
        
    }


    
    @IBOutlet weak var sendEmail: UIBarButtonItem!
    
    
    @IBAction func sendEmailPressed1(_ sender: Any) {
    
            if MFMailComposeViewController.canSendMail() {
                print("email")
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                db.collection("patients").whereField("uid", isEqualTo:Auth.auth().currentUser!.uid).getDocuments { (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        var progresses = [String()]
                        if let snapshot = snapshot {
                           
                            for document in snapshot.documents {
                                let data = document.data()
                                self.pEmail = data["Email"] as! String
                                progresses = data["progress"] as! [String]
                                print (self.pEmail)
                                print (progresses)
                                
                                for singleProgress in progresses {
                                    let fullTrail = singleProgress
                                    let p : [Progress] = self.setProgress(singleProgress : fullTrail)
                                    
                                    self.progressArray.append(contentsOf: p)
                                    
                                    
                                }
                            }
                        }
                    }
                    
                    //mail.setToRecipients(["horalfaisal2016@gmail.com","horalfaisal2016@gmail.com"])
                }
                var messageBody = String()
                for eachProgress in progressArray{
                
                    if (eachProgress.result == "f"){
                       // progress.result = "إجابة خاطئة"
                        print(eachProgress.answer,",",eachProgress.date,",","إجابة خاطئة","\n")
                        messageBody += eachProgress.answer + ","
                        messageBody += eachProgress.date + ","
                        messageBody += "إجابة خاطئة"
                        messageBody += "\n"
                        }
                    else{
                        print(eachProgress.answer, ",",eachProgress.date,",","إجابة صحيحة","\n")
                        messageBody += eachProgress.answer + ","
                        messageBody += eachProgress.date + ","
                        messageBody += "إجابة صحيحة"
                        messageBody += "\n"
                        }
                }
                
                //message.append(Auth.auth().currentUser!.email!)
                print(progressArray)
                mail.setToRecipients([self.pEmail])
                mail.setSubject("تقدم حالة المريض")
                mail.setMessageBody(messageBody, isHTML: false)
                self.present(mail, animated: true)
                
            } else {
                // show failure alert
                
                print("Cannot send email")
                // create the alert
                let alert = UIAlertController(title:"" , message: "لم يتم ربط هذا الجهاز بحساب البريد الإلكتروني. يرجى تسجيل الدخول إلى بريدك الإلكتروني في برنامج Mail,Gmail,...", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                
                alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    
    @IBAction func sendEmailPressed(_ sender: Any) {
        
        if MFMailComposeViewController.canSendMail() {
            print("email")
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            db.collection("patients").whereField("uid", isEqualTo:Auth.auth().currentUser!.uid).getDocuments { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let snapshot = snapshot {
                        
                        for document in snapshot.documents {
                            let data = document.data()
                            self.pEmail = data["Email"] as! String
                            print (self.pEmail)
                            //print("I send email")
                        }
                    }
                }
               
            }
            //message.append(Auth.auth().currentUser!.email!)
            mail.setToRecipients([self.pEmail])
            mail.setSubject("تقدم حالة المريض")
            mail.setMessageBody("هنا سيكون تقدم حالة المريض", isHTML: false)
            self.present(mail, animated: true)
            
        } else {
            // show failure alert
            
            print("Cannot send email")
            // create the alert
            let alert = UIAlertController(title:"" , message: "لم يتم ربط هذا الجهاز بحساب البريد الإلكتروني. يرجى تسجيل الدخول إلى بريدك الإلكتروني في برنامج Mail,Gmail,...", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            
            alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }
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
    
    
    func setProgress(singleProgress : String) -> [Progress] {
        var tProgress = [Progress]()
        var progress : Progress
        let trialProgress = singleProgress.components(separatedBy: ",")
        
        let trialAnswers = trialProgress[0]
        let trialResults = trialProgress[1]
        let trialDate = trialProgress[2]
        //                                    for trialData in trialProgress{
        //                                        print("\(trialData) ")
        //                                    }
        //                                           print("-------")
        let answers = trialAnswers.components(separatedBy: "-")
        
        //                                                                 for trialData in answers{
        //                                                                            print("\(trialData) ")
        //                                                                        }
        print("-------")
        let results = trialResults.components(separatedBy: "-")
        
        //                                                  for trialData in results{
        //                                                             print("\(trialData) ")
        //                                                         }
        print("----=========---")
        
        
        var index = 0
        while index < answers.count {
            //                                        self.answer = answers[index]
            //                                        self.result = results[index]
            //                                        self.date = trialDate
            
            progress = Progress ( answer: answers[index] , result: results[index] , date: trialDate )
            
            print("\(answers[index])    \(results[index])    \(trialDate)")
            index += 1
            tProgress.append( progress  )
            
            print("        -------")
        }
        
        print("----=========---")
        //------------
        
        //            var progress = Progress (answers, answer,results result,date date)
        return tProgress
    }
    
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
    
    
    // ------------for disable rotate > portrait view only
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //       override open var shouldAutorotate: Bool {
    //           return false
    //       }
    
}
