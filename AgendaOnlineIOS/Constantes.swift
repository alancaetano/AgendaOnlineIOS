//
//  Constantes.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 4/24/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import Foundation


class Constantes{

    static var TIPOCONVERSA_CONVERSA = "C"
    static var TIPOCONVERSA_COMUNICADO_SIMPLES = "A"
    static var TIPOCONVERSA_COMUNICADO_CONFIRMACAO = "L"
    static var TIPOCONVERSA_COMUNICADO_SIMOUNAO = "R"
    
    static var API_HOST = "http://agendaonlinerestapi.azurewebsites.net/"
    static var WEBAPP_HOST = "http://agendaonlinewebapp.azurewebsites.net/"
    static var API_GETCONVERSAS = API_HOST + "api/Conversas/GetConversas/"
    static var API_GETALUNOS = API_HOST + "api/Alunos/GetAlunos/"
    static var API_GETCONTATOSESCOLA = API_HOST + "api/Usuarios/GetContatosEscola/"
    static var API_GETMENSAGENS = API_HOST + "api/Mensagens/GetMensagens/"
    static var API_ENVIARMENSAGEM = WEBAPP_HOST + "services/MensagemService.ashx"
    static var API_LOGIN = API_HOST + "api/Usuarios/Login/"
    static var API_ENVIARNOVACONVERSA = WEBAPP_HOST + "services/ConversaService.ashx"
    
}