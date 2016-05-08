//
//  MensagemCellViewController.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 3/8/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import UIKit

class MensagemCell: UITableViewCell {
    @IBOutlet weak var Texto:UILabel! = UILabel()
    @IBOutlet weak var Data:UILabel! = UILabel()
    
    func MensagemCell(texto:String!, data:NSDate!){
        Texto.text = texto
        Data.text = ""
    
    }
    
    
}
