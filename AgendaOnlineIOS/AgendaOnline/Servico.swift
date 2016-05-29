//
//  Servico.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 5/26/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import Foundation

class Servico{
    
    static let HTTPMethod_GET = "GET"
    static let HTTPMethod_POST = "POST"
    
    static let API_HOST = "http://agendaonlinerestapi.azurewebsites.net/"
    static let WEBAPP_HOST = "http://agendaonlinewebapp.azurewebsites.net/"
    
    static let API_GETCONVERSAS = "\(API_HOST)api/Conversas/GetConversasResponsavel/"
    static let API_GETALUNOS = "\(API_HOST)api/Alunos/GetAlunos/"
    static let API_GETCONTATOSESCOLA = "\(API_HOST)api/Usuarios/GetContatosEscola/"
    static let API_GETMENSAGENS = "\(API_HOST)api/Mensagens/GetMensagens/"
    static let API_ENVIARMENSAGEM = "\(WEBAPP_HOST)services/MensagemService.ashx"
    static let API_LOGIN = "\(API_HOST)api/Usuarios/LoginApp/"
    static let API_ENVIARNOVACONVERSA = "\(WEBAPP_HOST)services/ConversaService.ashx"
    
    static func ChamarServico(url:String, httpMethod:String, json:AnyObject?, callback:((response:NSURLResponse?, data: NSData?, error: NSError?) -> Void)){
        let nsurl = NSURL(string: url)
        let request = NSMutableURLRequest(URL: nsurl!)
        request.HTTPMethod = httpMethod
        
        if(httpMethod == HTTPMethod_POST && json != nil){
            let jsonData = try? NSJSONSerialization.dataWithJSONObject(json!, options: .PrettyPrinted)
            request.HTTPBody = jsonData
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:callback)

    }
}
