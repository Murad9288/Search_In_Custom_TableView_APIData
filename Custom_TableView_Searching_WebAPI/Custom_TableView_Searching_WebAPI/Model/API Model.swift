//
//  API Model.swift
//  Custom_TableView_Searching_WebAPI
//
//  Created by Md Murad Hossain on 10/12/22.
//

import Foundation

struct ToDo : Decodable{
    let localized_name: String
    let img: String
    let name: String
}
