//
//  Contexto.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 5/26/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import Foundation

class Contexto{
    static var CHAVE_ALUNOS = "alunos"
    static var CHAVE_ID_USUARIO = "IdUsuario"
    
    static func Salvar(chave:String!, valor:NSObject!){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(valor , forKey: chave)
    }
    
    static func Recuperar(chave:String!) -> AnyObject? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.valueForKey(chave)
    }
    
    static func AdicionarNaLista(chave:String!, valor:NSObject!){
        let defaults = NSUserDefaults.standardUserDefaults()

        var lista:NSMutableArray! = NSMutableArray()
        
        let objeto = defaults.valueForKey(chave)
        if(objeto != nil){
            lista = objeto as! NSMutableArray!
        }
        
        lista.addObject(valor)
        
        defaults.setObject(lista , forKey: chave)
    }
}