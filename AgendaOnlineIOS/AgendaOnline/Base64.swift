//
//  Base64.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 5/26/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import Foundation

class Base64{
    static func Codificar(texto:String) -> String{
        let utf8str = texto.dataUsingEncoding(NSUTF8StringEncoding)
        return utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
}