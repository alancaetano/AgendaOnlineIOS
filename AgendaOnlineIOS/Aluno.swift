//
//  Aluno.swift
//  AgendaOnline
//
//  Created by João Fabio Lourenço dos Santos on 07/02/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import Foundation

class Aluno	: NSObject {
	
	var Id:Int!
	var Nome:String!
	var IdUsuarioResponsavel:Int!
	
	init (Id:Int, Nome:String, IdUsuarioResponsavel:Int) {
		self.Id = Id
		self.Nome = Nome
		self.IdUsuarioResponsavel = IdUsuarioResponsavel
	}
}