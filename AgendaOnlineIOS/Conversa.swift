//
//  Conversa.swift
//  AgendaOnline
//
//  Created by João Fabio Lourenço dos Santos on 07/02/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import Foundation

class Conversa: NSObject {
	
    static var TIPOCONVERSA_CONVERSA = "C"
    static var TIPOCONVERSA_COMUNICADO_SIMPLES = "A"
    static var TIPOCONVERSA_COMUNICADO_CONFIRMACAO = "L"
    static var TIPOCONVERSA_COMUNICADO_SIMOUNAO = "R"
    
    static var RESPOSTA_COMUNICADO_SIM = "S"
    static var RESPOSTA_COMUNICADO_NAO = "N"
    static var RESPOSTA_COMUNICADO_LIDO = "L"
    
	var Id:String = ""
	var Tipo:String = ""
    var NomeProfessor:String = ""
    var NomeAluno:String = ""
    var DataUltimaMensagem:NSDate = NSDate()
    var TextoUltimaMensagem:String = ""
    var IdProfessor:String = ""
    var IdAluno:String = ""
    var RespostaComunicado:String = ""
	
}