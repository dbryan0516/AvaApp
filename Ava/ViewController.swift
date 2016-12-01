//
//  ViewController.swift
//  Ava
//
//  Created by Dylan Bryan on 11/30/16.
//  Copyright © 2016 Dylan Bryan. All rights reserved.
//

import UIKit
import SwiftSocket

class ViewController: UIViewController {
    
    var statusJson = "{\"system\":{\"get_sysinfo\":null}}"
    var outletIP = "192.168.0.19"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func switchLights(_ sender: UIButton) {
        let outlet = TCPClient(address: outletIP, port: 9999)
        switch outlet.connect(timeout: 1) {
            
        case .success:
            let request = encrypt(data: statusJson)
            switch outlet.send(string: request ) {
            case .success:
                guard let data = outlet.read(2048) else { return }
                
                if let response = String(bytes: data, encoding: .utf8) {
                    print(response)
                }
            case .failure(let error):
                print(error)
            }
            
        case .failure(let error):
            print(error)
        }
        outlet.close()
        
    }
    
//    def encrypt(string):
//    key = 171
//    result = "\0\0\0\0"
//    for i in string:
//    a = key ^ ord(i)
//    key = a
//    result += chr(a)
//    return result
    
    
    
    func encrypt(data: String) -> String{
        var key: UInt8 = 171
        var result = ""
        for i in data.utf8 {
            
            let a = key ^ i
            key = a
            let temp = UnicodeScalar(a)
            result += String(Character(temp))
        }

        return result
    }

    func decrypt(data: String) -> String{
        return ""
    }
}











