//
//  LoginViewController.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 3/27/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
    @IBOutlet weak var TextLogin: UITextField!
    
    @IBOutlet weak var TextSenha: UITextField!
    
    
    @IBAction func Entrar(sender: AnyObject) {
        do{
            let str = TextLogin.text! + ";" + TextSenha.text!
            let base64 = Base64.Codificar(str)

            let url = NSURL(string: Constantes.API_LOGIN + base64)
            let request = NSMutableURLRequest(URL: url!)
            
            var idUsuario:String = ""
            
            request.HTTPMethod = "GET"
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{(response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                
                do{
                    
                    let usuario: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary

                    idUsuario = usuario.valueForKey("id") as! String
                    
                    Contexto.Salvar(Contexto.CHAVE_ID_USUARIO, valor: idUsuario)
                
                }catch{
                    dispatch_async(dispatch_get_main_queue(), {
                        
                    })
                    print(error)
                }

                })
            
        }catch{
            print(error)
        }
    }
    
    func carregarAlunos(idUsuario:String){
        let url: String =  Constantes.API_GETALUNOS + idUsuario
        let request: NSMutableURLRequest = NSMutableURLRequest()
        
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            do{
                let jsonResult: NSArray! = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSArray
                
                for item in jsonResult {
                    let obj = item as! NSDictionary
                    let aluno:Aluno = Aluno()
                    aluno.Id = obj["IdAluno"] as! String
                    aluno.Nome = obj["Nome"] as! String
                    aluno.Observacao = obj["Observacao"] as! String
                    aluno.Periodo = obj["Periodo"] as! String
                    aluno.Turma = obj["Turma"] as! String
                    
                    Contexto.AdicionarNaLista(Contexto.CHAVE_ALUNOS, aluno)

                }
                
                dispatch_async(dispatch_get_main_queue(), {self.dismissViewControllerAnimated(true, completion: nil)})
                
            }catch{
                print(error)
            }
            
        });
    }
    
}