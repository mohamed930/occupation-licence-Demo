//
//  BaseURL.swift
//  occupation
//
//  Created by Mohamed Ali on 09/10/2021.
//

import Foundation

let baseurl = "http://197.51.200.51:3001/" /* http://197.51.200.51:3001/ */
let userEndPoint = "Users"
let occupationEndPoint = "Occupations"
let tempEndPoint = "Temp"

var tocken = ""
var userId = 0
var email = ""
let currentUser = "userData"
let AvatarImage = "UsersImage/"

var occupationDetalis: OccupationModel!

//enum namrAR: String, Codable {
//    return  "بنك وفاترينه"
//    return  "تجمع"
//    return  "فاترينة"
//    return  "كشك"
//    return  "كارافانات"
//    return "كشك وتلاجة"
//    return  "فاترينة و تلاجة"
//    return  "كشك و فاترينة"
//    return  "أمن غذائى"
//    return  "فرش أمام الغير"
//    return  "منفذ"
//}

enum namrAR: String, Codable {
    case A = "A"
    case B = "B"
    case C = "C"
    case D = "D"
    case E = "E"
    case F = "F"
    case G = "G"
    case H = "H"
    case J = "J"
    case K = "K"
    case L = "L"
    case empty = ""
}
