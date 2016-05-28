//
//  IndicadorCarregamento.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 5/26/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import UIKit

class IndicadorCarregamento{
    var indicator:UIActivityIndicatorView! = nil
    var view:UIView! = nil
    
    init(view:UIView!){
        self.view = view
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        self.view.addSubview(indicator)
    }
    
    func Iniciar(){
        indicator.startAnimating()
    }
    
    func Parar(){
        indicator.stopAnimating()
    }
}