//
//  EventEmitter.swift
//  EventEmitter
//
//  Created by Fernando Oliveira on 12/10/15.
//  Copyright © 2015 FCO. All rights reserved.
//

import Foundation

public class EventEmitter {
    private var listeners : [String:[String:[Any]]] = [:]
    private var onceListeners : [String:[String:[Any]]] = [:]
    
    public init() {
    }
    
    public func on<T>(event: String, cb: (T) -> Void) -> EventEmitter {
        if listeners[event] == nil {
            listeners[event] = [String(T.self):[]]
        }
        addListener(&listeners[event]!, cb: cb)
        return self
    }
    
    public func once<T>(event: String, cb: (T) -> Void) -> EventEmitter {
        if onceListeners[event] == nil {
            onceListeners[event] = [String(T.self):[]]
        }
        addListener(&onceListeners[event]!, cb: cb)
        return self
    }
    
    private func addListener<T>(inout list : [String:[Any]], cb: (T) -> Void) {
        
        if list[String(T.self)] == nil {
            list[String(T.self)] = []
        }
        list[String(T.self)]!.append(cb as Any)
    }
    
    /*
    func removeListener<T>(event : String, cb : ((T) -> Void)?) {
    if cb == nil {
    listeners.removeValueForKey(event)
    } else {
    let index = listeners[event]?.indexOf(cb!)
    listeners[event]?.removeAtIndex(index)
    }
    }
    */
    
    public func emit(event: String) {
        emit(event, data: ())
    }
    
    public func emit<T>(event: String, data: T) {
        print("emit \(event): \(data)")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            var funcs : [Any] = []
            if self.listeners[event]?[String(T.self)]?.count > 0 {
                funcs += self.listeners[event]![String(T.self)]!
            }
            if self.onceListeners[event]?[String(T.self)]?.count > 0 {
                funcs += self.onceListeners[event]!.removeValueForKey(String(T.self))!
            }
            self.emitFuncs(data, funcList: funcs)
        }
    }
    
    private func emitFuncs<T>(data: T, funcList : [Any]) {
        for cb in (funcList) {
            dispatch_async(dispatch_get_main_queue()) {
                (cb as! (T) -> Void)(data)
            }
        }
    }
}






