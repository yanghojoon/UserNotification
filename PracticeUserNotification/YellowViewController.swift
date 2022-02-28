//
//  YellowViewController.swift
//  EnterWithNotifications
//
//  Created by 양호준 on 2022/02/28.
//

import UIKit

class YellowViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var notificationTitle: String?
    var notificationBody: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = notificationTitle
        bodyLabel.text = notificationBody
    }

    func setupData(title: String, body: String) {
        notificationTitle = title
        notificationBody = body
    }
}
