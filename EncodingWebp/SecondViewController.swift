//
//  SecondViewController.swift
//  EncodingWebp
//
//  Created by InitialC on 2017/6/28.
//  Copyright © 2017年 InitialC. All rights reserved.
//

import UIKit
import YYImage

class SecondViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    var backgroundPath : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backgroundImageView.image = YYImage.init(contentsOfFile: backgroundPath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
