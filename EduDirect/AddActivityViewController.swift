//
//  AddActivityViewController.swift
//  EduDirect
//
//  Created by Megan Tjandrasuwita on 7/2/17.
//  Copyright © 2017 MMT. All rights reserved.
//

import UIKit
import SCLAlertView
protocol AddActivityControllerDelegate:class {
    func didFinishAddingActivity(form: AddActivityViewController, activity: Extracurricular)
    
}

class AddActivityViewController: UIViewController {
    
    @IBOutlet weak var activityName: UITextField!
    
    @IBOutlet weak var activityCommitment: UITextField!

    @IBOutlet weak var activityGrade: UITextField!
    
    @IBOutlet weak var activityDescription: UITextField!
    weak var delegate: AddActivityControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func donePressed(_ sender: Any) {
        let name = activityName.text
        let commitment = activityCommitment.text
        let grade = Int(activityGrade.text!)
        let description = activityDescription.text
        if name == nil {
            SCLAlertView().showError("Required Field", subTitle: "Please fill in the name of the course")
            return;
        }
        var num = Int(grade!)
        if  num == nil {
            activityGrade.endEditing(true)
            SCLAlertView().showError("Incorrect Grade Input.", subTitle: "Grade must be  a number between 9 and 12.")
            return;
        }
        if (grade! < 9 || grade! > 12)
        {
            activityGrade.endEditing(true)
            SCLAlertView().showError("Incorrect Grade Input.", subTitle: "Grade must be between 9 and 12.")
            return;
        }

        
        let newActivity = Extracurricular(name!, commitment: commitment!, description: description!, grade: grade!)
        delegate?.didFinishAddingActivity(form: self, activity: newActivity)
        dismiss(animated: true, completion: nil)

       
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
