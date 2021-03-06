//
//  FormatacaoData.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 5/29/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import UIKit

class FormatacaoData {
    
    static let DIAS_DA_SEMANA = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sab", "Dom"]
    static let FORMATO_API = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    static let FORMATO_API_COM_MILISSEGUNDOS = "yyyy-MM-dd'T'HH:mm:ss"
    static let FORMATO_APENAS_HORAS = "hh:mm"
    static let FORMATO_DATA_E_HORA = "dd/MM/yyyy hh:mm"
    
    static func Formatar(data:NSDate)->String{
        let dateFormatter = NSDateFormatter()
        let segundosDeDiferenca = NSDate().timeIntervalSinceDate(data)
        let horas:Int = Int(segundosDeDiferenca)/60/60
        
        if(horas < 24){
            dateFormatter.dateFormat = "hh:mm"
            return dateFormatter.stringFromDate(data)
        }
        
        let dias:Int = horas/24
        
        if(dias < 7){
            dateFormatter.dateFormat = "hh:mm"
            
            let calendario = NSCalendar(calendarIdentifier: NSGregorianCalendar)
            let component = calendario?.components(.WeekdayOrdinal, fromDate: data)
            component?.weekdayOrdinal
            return "\(DIAS_DA_SEMANA[(component?.weekdayOrdinal)!]), \(dateFormatter.stringFromDate(data))"
        }
        
        dateFormatter.dateFormat = FORMATO_DATA_E_HORA
        return dateFormatter.stringFromDate(data)
    }
    
    static func StringParaData(dataStr:String!)->NSDate{
        let formatacaoComMilissegundos = NSDateFormatter()
        formatacaoComMilissegundos.dateFormat = FORMATO_API
        
        let formatacaoSemMilissegundos = NSDateFormatter()
        formatacaoSemMilissegundos.dateFormat = FORMATO_API_COM_MILISSEGUNDOS
        
        if let data = formatacaoComMilissegundos.dateFromString(dataStr){
            return data
        }else{
            return formatacaoSemMilissegundos.dateFromString(dataStr)!
        }
    }
}