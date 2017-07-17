//
//  ViewController.swift
//  EncodingWebp
//
//  Created by InitialC on 2017/6/28.
//  Copyright © 2017年 InitialC. All rights reserved.
//

import UIKit
import DACircularProgress
import YYImage

class ViewController: UIViewController {

    @IBOutlet weak var inputPathTextField: UITextField!
    @IBOutlet weak var showWebPBtn: UIButton!
    @IBOutlet weak var progressView: DALabeledCircularProgressView!
    var largePicPath : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        progressView.roundedCorners = 6
        progressView.progressTintColor = UIColor.orange
        progressView.trackTintColor = UIColor.lightGray
        progressView.progressLabel.textColor = UIColor.lightGray
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        encodingPicture()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! SecondViewController
        destination.backgroundPath = inputPathTextField.text!
    }
    func encodingPicture() {
        let pathString = Bundle.main.bundlePath.appending("/Sources.bundle")
        let fileMgr = FileManager.default
        if !fileMgr.fileExists(atPath: pathString) {
            return
        }
        // 要保存的webp路径
        let kPathDocu = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first?.appending("/WebPFiles")
        do {
            try fileMgr.createDirectory(atPath: kPathDocu!, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("创建WebPFiles文件夹失败")
        }
        print("保存位置:==\n\(String(describing: kPathDocu))")
        if let pathArr = fileMgr.subpaths(atPath: pathString) {
            var allFileSize = pathArr.count
            for subPath in pathArr {
//                print("访问的地址目录\(subPath)\n")
                if let indexFromArr = pathArr.index(of: subPath) {
                    let progress = CGFloat(indexFromArr + 1) / CGFloat(allFileSize)
                    progressView.progress = progress
                    progressView.progressLabel.text = String.init(format: "%.1f%%", progress * 100)
                }
                if subPath.contains(".DS_Store") {
                    allFileSize -= 1
                    continue
                }
                var picName : String = ""
                let pngStr = ".png"
                let jpgStr = ".jpg"
                if subPath.contains(pngStr) || subPath.contains(jpgStr) {
                    if subPath.contains("@3x") || subPath.contains("@2x") {
                        if subPath.contains(pngStr) {
                            picName = subPath.replacingOccurrences(of: "@3x\(pngStr)", with: "")
                        } else {
                            picName = subPath.replacingOccurrences(of: "@2x\(pngStr)", with: "")
                        }
                    } else {
                        if subPath.contains(pngStr) {
                            picName = subPath.replacingOccurrences(of: pngStr, with: "")
                        } else {
                            picName = subPath.replacingOccurrences(of: jpgStr, with: "")
                        }
                    }
                }
                let picPath = pathString.appendingFormat("/%@", subPath)
                if let picData = NSData.init(contentsOfFile: picPath) {
                    if let cfPicData = CFDataCreate(kCFAllocatorDefault, picData.bytes.assumingMemoryBound(to: UInt8.self), picData.length) {
                        let picType = YYImageDetectType(cfPicData)
                        switch picType {
                        case .PNG:
                            print("\(subPath)==PNG图")
                            break
                        case .JPEG:
                            print("\(subPath)==JPEG图")
                            break
                        case .webP:
                            print("\(subPath)==webP图")
                            break
                        default:
                            break
                        }
                        let webPEncoder = YYImageEncoder.init(type: .webP)
                        webPEncoder?.quality = 0.6
                        webPEncoder?.addImage(with: picData as Data, duration: 0.0)
                        let webPData = webPEncoder?.encode()
                        if let saveWebPFilePath = kPathDocu?.appending("/\(picName).webp") {
                            if picName == "top_mine" {
                                self.largePicPath = saveWebPFilePath
                                showWebPBtn.isHidden = false
                            }
                            do {
                                try webPData?.write(to: URL.init(fileURLWithPath: saveWebPFilePath), options: .atomicWrite)
                            } catch {
                                print("保存webp失败")
                            }
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

