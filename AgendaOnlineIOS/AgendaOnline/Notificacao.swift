//
//  Notificacao.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 7/20/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import UIKit

class Notificacao{
    static let CATEGORIA_ALUNO = "CategoriaAluno"
    
    static func tratarNotificacaoRemota(notificacao:UILocalNotification){
        if(notificacao.category == Notificacao.CATEGORIA_ALUNO){
            Aluno.CarregarAlunos()
        }else{
            NSNotificationCenter.defaultCenter().postNotificationName(notificacao.category!, object: notificacao)
            NSNotificationCenter.defaultCenter().postNotificationName("mensagem", object: notificacao)
        }
    }
    
    static func enviarNotificacaoLocal(corpo:String, categoria:String){
        let notificacao = UILocalNotification()
        notificacao.alertBody = corpo
        notificacao.fireDate = NSDate(timeIntervalSinceNow: 0)
        
        UIApplication.sharedApplication().scheduleLocalNotification(notificacao)
    }
}