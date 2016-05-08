//
//  UsuarioConversa.swift
//  AgendaOnline
//
//  Created by João Fabio Lourenço dos Santos on 07/02/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import Foundation

class UsuarioConversa: NSObject {

	var IdUsuairo:Int!
	var IdConversa:Int!
	
	init(IdUsuario:Int, IdConversa:Int) {
		self.IdUsuairo = IdUsuario
		self.IdConversa = IdConversa
	}
}