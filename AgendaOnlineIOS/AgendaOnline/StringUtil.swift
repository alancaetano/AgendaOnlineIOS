//
//  StringUtil.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 7/24/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import UIKit

class StringUtil{
    static func RecuperarPrimeiroNome(nomeCompleto:String)->String{        
        let array = nomeCompleto.characters.split{$0 == " "}.map(String.init)
        
        return array[0]
    }
}