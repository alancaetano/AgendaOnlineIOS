//
//  Aluno.swift
//  AgendaOnline
//
//  Created by João Fabio Lourenço dos Santos on 07/02/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import Foundation

class Aluno	: NSObject {
	
    var Id:String = ""
	var Nome:String = ""
    var Observacao:String = ""
    var Turma:String = ""
    var Periodo:String = ""
    
    override init(){
        
    }
    
    init(dic:NSDictionary){
        self.Id = dic.valueForKey("Id") as! String
        self.Nome = dic.valueForKey("Nome") as! String
        self.Observacao = dic.valueForKey("Observacao") as! String
        self.Turma = dic.valueForKey("Turma") as! String
        self.Periodo = dic.valueForKey("Periodo") as! String
    }
    
    func toDictionary() -> NSDictionary{
        let dic:NSDictionary = ["Id":self.Id,"Nome":self.Nome,"Observacao":self.Observacao, "Turma":self.Turma, "Periodo":self.Periodo]
        return dic
    }
    
    static func CarregarAlunos(){
        let idUsuario = Contexto.Recuperar(Contexto.CHAVE_ID_USUARIO)!
        let url: String =  "\(Servico.API_GETALUNOS)\(idUsuario)/"
        
        Servico.ChamarServico(url, httpMethod: Servico.HTTPMethod_GET, json:nil, callback: carregarAlunosCallback)
    }
    
    static func carregarAlunosCallback(response:NSURLResponse?, data: NSData?, error: NSError?){
        if(error != nil)
        {
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
            
        }catch{
            return
        }
    }
}