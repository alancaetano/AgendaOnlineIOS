//
//  Contexto.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 5/26/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import Foundation

class Contexto{
    static let CHAVE_ALUNOS = "alunos"
    
    static let CHAVE_ID_USUARIO = "IdUsuario"
    static let CHAVE_NOME_USUARIO = "NomeUsuario"
    static let CHAVE_SENHA_USUARIO = "SenhaUsuario"
    
    static let CHAVE_ACCESS_TOKEN = "acess_token"
    static let CHAVE_TOKEN_TYPE = "token_type"
    static let CHAVE_EXPIRES_IN = "expires_in"
    
    static func Salvar(chave:String!, valor:NSObject!){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(valor , forKey: chave)
    }
    
    static func Recuperar(chave:String!) -> AnyObject? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.valueForKey(chave)
    }
    
    static func AdicionarAluno(aluno:Aluno!){
        let defaults = NSUserDefaults.standardUserDefaults()

        var temp:NSMutableArray! = NSMutableArray()
        
        let objeto = defaults.valueForKey(Contexto.CHAVE_ALUNOS)
        if(objeto != nil){
            temp = NSMutableArray(array: (objeto as! NSArray!))
        }
        
        temp.addObject(aluno.toDictionary())
        
        let array:NSArray! = NSArray(array: temp)
        
        defaults.setObject(array , forKey: Contexto.CHAVE_ALUNOS)
    }
    
    static func AlterarAluno(aluno:Aluno!){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var temp:NSMutableArray! = NSMutableArray()
        
        let objeto = defaults.valueForKey(Contexto.CHAVE_ALUNOS)
        if(objeto == nil){
            return
        }
        
        temp = NSMutableArray(array: (objeto as! NSArray!))
        
        for i in 0...(temp.count-1){
            let alunoTemp = Aluno(dic: temp[i] as! NSDictionary)
            if(alunoTemp.Id == aluno.Id){
                temp.replaceObjectAtIndex(i, withObject: aluno.toDictionary())
            }
        }
        
        let array:NSArray! = NSArray(array: temp)
        
        defaults.setObject(array , forKey: Contexto.CHAVE_ALUNOS)
    }
    
    static func RecuperarAlunos()->NSArray{
        let defaults = NSUserDefaults.standardUserDefaults()
        let array:NSArray! = defaults.valueForKey(Contexto.CHAVE_ALUNOS) as! NSArray!
        let alunos:NSMutableArray! = NSMutableArray()
        
        for i in 0...array.count-1{
            alunos.addObject(Aluno(dic: array[i] as! NSDictionary))
        }
        
        return alunos
    }
    
    static func Limpar(chave:String!){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(chave)
    }
}