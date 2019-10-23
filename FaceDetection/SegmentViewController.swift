//
//  SegmentViewController.swift
//  FaceDetection
//
//  Created by Synoptek Mac 2 on 16/10/19.
//  Copyright © 2019 Synoptek Mac 2. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SegmentViewController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var PagerScrollView: UIScrollView!
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [FaceRecognizationViewController(), TranslateTextViewController()]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
