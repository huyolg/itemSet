//
//  HSocketConnectPage.swift
//  Project
//
//  Created by 胡某人 on 2023/10/10.
//

import UIKit

class HSocketConnectPage: HBaseViewController {
    let viewModel = HSocketViewModel()

    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var SendBtn: UIButton!
    @IBOutlet weak var disconnectBtn: UIButton!
    @IBOutlet weak var connectBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Net Connect"
        backView()
        
        viewModel.runTCP()
        viewModel.checkPingPong()
    }
    
    @IBAction func handlerSend(_ sender: Any) {
        view.endEditing(true)
        viewModel.sendMsg(textInput.text ?? "")
    }
    @IBAction func handlerConnect(_ sender: Any) {
        viewModel.connect()
    }
    @IBAction func handlerDisconnect(_ sender: Any) {
        viewModel.disconnect()
    }
    
}
