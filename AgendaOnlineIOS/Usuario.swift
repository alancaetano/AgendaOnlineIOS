//
//  Usuario.swift
//  AgendaOnline
//
//  Created by João Fabio Lourenço dos Santos on 07/02/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import Foundation

class Usuario : NSObject {
	
	var Id:String!
	var Nome:String!
	var Email:String!
	var Senha:String!
	var Tipo:String!
	
	init (Id:String, Nome:String, Email:String, Senha:String, Tipo:String) {
		self.Id = Id
		self.Nome = Nome
		self.Email = Email
		self.Senha = Senha
		self.Tipo = Tipo
	}
	
	func encodeWithCoder(aCoder: NSCoder!) {
		aCoder.encodeObject(Id, forKey: "Id")
		aCoder.encodeObject(Nome, forKey: "Nome")
		aCoder.encodeObject(Email, forKey: "Email")
		aCoder.encodeObject(Senha, forKey: "Senha")
		aCoder.encodeObject(Tipo, forKey: "Tipo")
	}
	
	required convenience init(coder aDecoder: NSCoder) {
		let Id = aDecoder.decodeObjectForKey("Id") as! String
		let Nome = aDecoder.decodeObjectForKey("Nome") as! String
		let Email = aDecoder.decodeObjectForKey("Email") as! String
		let Senha = aDecoder.decodeObjectForKey("Senha") as! String
		let Tipo = aDecoder.decodeObjectForKey("Tipo") as! String
		
		self.init(Id: Id, Nome: Nome, Email: Email, Senha: Senha, Tipo: Tipo)
	}
}