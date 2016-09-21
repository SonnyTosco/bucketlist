//
//  MissionDetailsViewController.swift
//  bucketlistsequel
//
//  Created by Clavel Tosco on 9/16/16.
//  Copyright © 2016 Clavel Tosco. All rights reserved.
//

import UIKit

class MissionDetailsViewController: UITableViewController {
    
    var missionToEdit: String?
    var missionToEditIndexPath: Int?
    
    @IBAction func cancelBarButtonPressed(sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
        print("String2")
    }
    
    @IBAction func doneBarButtonPressed(sender: UIBarButtonItem) {
        //editing
        if var mission = missionToEdit {
            mission = newMissionTextField.text!
            delegate?.missionDetailsViewController(self, didFinishEditingMission: mission, atIndexPath: missionToEditIndexPath!)
        } else {
        //adding
            let mission = newMissionTextField.text!
            delegate?.missionDetailsViewController(self, didFinishAddingMission: mission)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let editField = missionToEdit {
            newMissionTextField.text = editField 
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var newMissionTextField: UITextField!
    weak var cancelButtonDelegate: CancelButtonDelegate?
    weak var delegate: MissionDetailsViewControllerDelegate?
    
}
