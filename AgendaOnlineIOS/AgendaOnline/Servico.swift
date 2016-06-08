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
    static let API_TOKEN = "\(API_HOST)Token"
    
    static func ChamarServico(url:String, httpMethod:String, json:AnyObject?, callback:((response:NSURLResponse?, data: NSData?, error: NSError?) -> Void)){
        let nsurl = NSURL(string: url)
        let request = NSMutableURLRequest(URL: nsurl!)
        request.HTTPMethod = httpMethod
        
        
        if(httpMethod == HTTPMethod_POST && json != nil){
            let jsonData = try? NSJSONSerialization.dataWithJSONObject(json!, options: .PrettyPrinted)
            request.HTTPBody = jsonData
        }
        
        Autenticar()
        
        let token = Contexto.Recuperar(Contexto.CHAVE_ACCESS_TOKEN) as! String!
        let token_type = Contexto.Recuperar(Contexto.CHAVE_TOKEN_TYPE) as! String!
        request.setValue("\(token_type) \(token)", forHTTPHeaderField: "Authorization")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:callback)

    }
    
    static func Autenticar(){
        let expiracaoToken = Contexto.Recuperar(Contexto.CHAVE_EXPIRES_IN)
        
        if(expiracaoToken != nil){
            let dataExpiracaoToken = expiracaoToken as! NSDate!
            if(dataExpiracaoToken.compare(NSDate()) == NSComparisonResult.OrderedDescending){
                return
            }
        }
        
        let nomeUsuario:String!  = Contexto.Recuperar(Contexto.CHAVE_NOME_USUARIO) as! String!
        let senhaUsuario:String! = Contexto.Recuperar(Contexto.CHAVE_SENHA_USUARIO) as! String!
        
        let request = NSMutableURLRequest(URL: NSURL(string:API_TOKEN)!)
        request.HTTPMethod = HTTPMethod_POST
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //request.setValue("password", forHTTPHeaderField: "grant_type")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        
        let strAutenticacao = "username=\(nomeUsuario!)&password=\(senhaUsuario!)&grant_type=password".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        request.HTTPBody = strAutenticacao!.dataUsingEncoding(NSUTF8StringEncoding)
        
        let data:NSData = try! NSURLConnection.sendSynchronousRequest(request, returningResponse:nil)
        
        let retorno: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
        if(retorno.valueForKey("access_token") == nil){
            return
        }
        
        Contexto.Salvar(Contexto.CHAVE_ACCESS_TOKEN, valor: retorno.valueForKey("access_token") as! NSObject)
        Contexto.Salvar(Contexto.CHAVE_TOKEN_TYPE, valor: retorno.valueForKey("token_type") as! NSObject)
        Contexto.Salvar(Contexto.CHAVE_EXPIRES_IN, valor: NSDate().dateByAddingTimeInterval(retorno.valueForKey("expires_in") as! Double))
        
    }
}
