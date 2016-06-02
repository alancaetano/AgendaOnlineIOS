//
//  Alerta.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 5/26/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import Foundation
import UIKit

class Alerta{
    static func MostrarAlerta(titulo:String, mensagem:String, estilo:UIAlertControllerStyle, tituloAcao:String, callback:(() ->Void), viewController:UIViewController){
        let alert = UIAlertController(title: mensagem, message: mensagem, preferredStyle: estilo)
        alert.addAction(UIAlertAction(title: tituloAcao, style: UIAlertActionStyle.Default, handler: nil))
        dispatch_async(dispatch_get_main_queue(), {
            viewController.presentViewController(alert, animated: true, completion: callback)
        })
    }
    
}