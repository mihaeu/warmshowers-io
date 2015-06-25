//
//  MessageRepository.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 24/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import BrightFutures

class MessageRepository
{
    let api = API.sharedInstance
    
    func save(message: Message)
    {
        // TODO: implement
    }
    
    func getAll() -> Future<[Message]>
    {
        return api.getAllMessages()
    }
}
