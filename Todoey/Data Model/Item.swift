//
//  Item.swift
//  Todoey
//
//  Created by umudy on 16.01.2019.
//  Copyright © 2019 Umut Emre. All rights reserved.
//

import Foundation

class Item: Codable {  //Encodable into a plist or Json yapıyoruz. * Encodable , Decodable yerine ikisini de istoyorsak Codable yapıyoruz.
    var title: String = ""  // Bir classın Encodable olabilmesi için böyle string,bool gibi typler olması lazım, custom bir class olsa olmaz.
    // mesela böyle; var a : B() ( B class objesini var a ya atarsak Item class I encodable olmaz.)
    var done: Bool = false
}
