//
//  MemeManager.swift
//  Mememe20
//
//  Created by Jan Gundorf on 10/04/2019.
//  Copyright © 2019 Jan Gundorf. All rights reserved.
//

import Foundation

class MemeManager
{
    
    var memesLib = [MemeStruct]()

    static let shared = MemeManager()
    
    init(){}
    
    func LoadMemeLib() -> [MemeStruct]
    {
        return memesLib
    }
    
    func AddToMemeLib(item: MemeStruct)
    {
        memesLib.append(item)
    }

    func DeleteFromMemeLib(place: Int)
    {
        memesLib.remove(at: place)
    }
}
