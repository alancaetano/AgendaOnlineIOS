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

        TextLogin.text = "pedrosouza@email.com"
        TextSenha.text = "admin123"
        
        let str = "\(TextLogin.text!);\(TextSenha.text!)"
        let base64 = Base64.Codificar(str)
        
        Contexto.Salvar(Contexto.CHAVE_NOME_USUARIO, valor: TextLogin.text!)
        Contexto.Salvar(Contexto.CHAVE_SENHA_USUARIO, valor: TextSenha.text!)

        Servico.ChamarServico(Servico.API_LOGIN + base64, httpMethod: Servico.HTTPMethod_GET, json:nil, callback: loginCallback)
            
    }
    
    func loginCallback(response:NSURLResponse?, data: NSData?, error: NSError?) -> Void
    {
        if(error != nil){
            Alerta.MostrarAlerta("Erro", mensagem: "Ocorreu um problema ao realizar o login.", estilo: UIAlertControllerStyle.Alert, tituloAcao: "Ok", callback: {}, viewController: self)
            return
        }
        
        do{
    
            let login: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
    
            let autenticou:Bool = (login.valueForKey("Autenticado") as! Bool)
            var idUsuario:String! = ""
            
            if(autenticou){
                idUsuario = login.valueForKey("IdUsuario") as! String
                
                Contexto.Salvar(Contexto.CHAVE_ID_USUARIO, valor: idUsuario)

                
                self.CarregarAlunos(idUsuario)
                
            }else{
                Alerta.MostrarAlerta("Login incorreto", mensagem: "Login ou senha incorretos.", estilo: UIAlertControllerStyle.Alert, tituloAcao: "Ok", callback: {}, viewController: self)
            }

        }catch{
            Alerta.MostrarAlerta("Erro", mensagem: "Ocorreu um problema ao realizar o login.", estilo: UIAlertControllerStyle.Alert, tituloAcao: "Ok", callback: {}, viewController: self)
        }
    }
    
    func CarregarAlunos(idUsuario:String){
        let url: String =  "\(Servico.API_GETALUNOS)\(idUsuario)/"
        
        Servico.ChamarServico(url, httpMethod: Servico.HTTPMethod_GET, json:nil, callback: carregarAlunosCallback)
    }
        
    func carregarAlunosCallback(response:NSURLResponse?, data: NSData?, error: NSError?){
        if(error != nil)
        {
            Alerta.MostrarAlerta("Erro", mensagem: "Ocorreu um problema ao recuperar os alunos.", estilo: UIAlertControllerStyle.Alert, tituloAcao: "Ok", callback: {}, viewController: self)
            
            return
        }
        
        do{
            Contexto.Limpar(Contexto.CHAVE_ALUNOS)
            
            let jsonResult: NSArray! = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSArray
            
            if(jsonResult != nil && jsonResult.count > 0){
                for item in jsonResult {
                    let obj = item as! NSDictionary
                    let aluno:Aluno = Aluno()
                    aluno.Id = obj["IdAluno"] as! String
                    aluno.Nome = obj["Nome"] as! String
                    aluno.Observacao = obj["Observacao"] as! String
                    aluno.Periodo = obj["Periodo"] as! String
                    aluno.Turma = obj["Turma"] as! String
                    
                    Contexto.AdicionarAluno(aluno)
                }
            }
                
            dispatch_async(dispatch_get_main_queue(), {self.dismissViewControllerAnimated(true, completion: nil)})
                
        }catch{
            Alerta.MostrarAlerta("Erro", mensagem: "Ocorreu um problema ao recuperar os alunos.", estilo: UIAlertControllerStyle.Alert, tituloAcao: "Ok", callback: {}, viewController: self)
        }
    }
}
