//
//  ConversaCell.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 5/28/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import UIKit

class ConversaCell: UITableViewCell {
    @IBOutlet weak var NomeProfessor:UILabel! = UILabel()
    @IBOutlet weak var NomeAluno:UILabel! = UILabel()
    @IBOutlet weak var TextoUltimaMensagem:UILabel! = UILabel()
    @IBOutlet weak var DataUltimaMensagem:UILabel! = UILabel()
    
    @IBOutlet weak var Icone: UIImageView!
}

