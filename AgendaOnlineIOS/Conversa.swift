//
//  Conversa.swift
//  AgendaOnline
//
//  Created by João Fabio Lourenço dos Santos on 07/02/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import Foundation

class Conversa: NSObject {
	
	var Id:String!
	var Tipo:String!
    var NomeProfessor:String!
    var UltimaMensagem:String!
    var IdProfessor:String!
	
    init(Id:String, NomeProfessor:String, UltimaMensagem:String, IdProfessor: String, Tipo: String) {
		self.Id = Id
        self.NomeProfessor = NomeProfessor
        self.UltimaMensagem = UltimaMensagem
		self.Tipo = Tipo
        self.IdProfessor = IdProfessor
        
	}
    
    
}