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
}