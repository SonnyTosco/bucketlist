//
//  MissionDetailsViewControllerDelegate.swift
//  bucketlistsequel
//
//  Created by Clavel Tosco on 9/16/16.
//  Copyright © 2016 Clavel Tosco. All rights reserved.
//

import Foundation

protocol MissionDetailsViewControllerDelegate: class {
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishAddingMission mission: String)
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishEditingMission mission: String, atIndexPath indexPath: Int)
}