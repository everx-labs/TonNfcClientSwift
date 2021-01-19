//
//  ViewController.swift
//  TonNfcClientSwift
//
//  Created by alinaT95 on 01/19/2021.
//  Copyright (c) 2021 alinaT95. All rights reserved.
//

import UIKit
import TonNfcClientSwift

@available(iOS 13.0, *)
class ViewController: UIViewController {
    
    var cardCoinManagerNfcApi: CardCoinManagerNfcApi = CardCoinManagerNfcApi()

    override func viewDidLoad() {
        super.viewDidLoad()
        cardCoinManagerNfcApi.getMaxPinTries()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

