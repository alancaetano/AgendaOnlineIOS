//
//  DropdownDelegate.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 6/12/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import Foundation
import UIKit

class DropdownDelegate: NSObject, UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}