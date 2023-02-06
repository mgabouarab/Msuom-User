//
//  UploadData.swift
//
//  Created by MGAbouarab®
//

import Foundation

struct UploadData {
    var data: Data
    var fileName: String
    var mimeType: mimeType
    var name: String
}


enum mimeType: String {
    case jpeg = "image/jpeg"
    case pdf = "application/pdf"
    case m4a = "audio/x-m4a"
    case mp4 = "video/mp4"
}
