//
//  IntroModel.swift
//  Msuom
//
//  Created by MGAbouarab on 25/10/2022.
//

import Foundation

struct IntroData: Codable {
    let intros: [Intro]
}

struct Intro: Codable {
    let title: String?
    let description: String?
    let image: String?
}
