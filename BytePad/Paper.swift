//
//  Paper.swift
//  BytePad
//
//  Created by Utkarsh Bansal on 07/04/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import Foundation


class Paper {
    fileprivate var _name : String
    fileprivate var _exam : String
    fileprivate var _url: String
    fileprivate var _detail: String
    
    init(name: String, exam: String, url:String, detail: String) {
        self._exam = exam
        self._name = name
        self._url = url
        self._detail = detail
    }
    
    var name: String {
        return self._name
    }
    
    var exam: String {
        return self._exam
    }
    
    var url: String {
        return self._url
    }
    
    var detail: String {
        return self._detail
    }
    
    
}
