//
//  ViewController.swift
//  tPageViewController
//
//  Created by tyobigoro_i on 2019/12/27.
//  Copyright © 2019 tyobigoro_i. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var upperPageViewController: UIPageViewController!
    var lowerPageViewController: UIPageViewController!
    
    var upperPageViewArray: [String] = ["A", "B", "C", "D", "E"]
    var lowerPageViewArray: [String] = ["あ", "か", "さ", "た", "な"]
    
    var upperPageViewIndex: Int = 0
    var lowerPageViewIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // pageViewControllerの設定 -> prepareへ
        // pageControlの設定
        setUpperPageViewController()
        setLowerPageViewController()

        upperPageViewController?.delegate   = self
        upperPageViewController?.dataSource = self
        lowerPageViewController?.delegate   = self
        lowerPageViewController?.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "EmbedUpperPVC":
            upperPageViewController = (segue.destination as! UIPageViewController)
        case "EmbedLowerPVC":
            lowerPageViewController = (segue.destination as! UIPageViewController)
        default: fatalError("prepare")
        }
    }
    
}



extension ViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool)
    {
         
        if completed {
           switch pageViewController {
            case upperPageViewController:
                guard let vc = upperPageViewController?.viewControllers?.first as? ContentsVC else { return }
                let index = vc.dataSource.index
                self.upperPageViewIndex = index
            case lowerPageViewController:
                guard let vc = lowerPageViewController?.viewControllers?.first as? ContentsVC else { return }
                let index = vc.dataSource.index
                self.lowerPageViewIndex = index
                default: fatalError("pageViewController/didFinishAnimating/fatalError")
            }
        }
    }
}

extension ViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        var index: Int
        let str: String
        
        switch pageViewController {
        case upperPageViewController:
            index = upperPageViewIndex
            if index == 0 { return nil }
            index -= 1
            str = upperPageViewArray[index]
        case lowerPageViewController:
            index = lowerPageViewIndex
            if index == 0 { return nil }
            index -= 1
            str = lowerPageViewArray[index]
        default: fatalError("viewControllerBefore/fatalError")
        }
        guard let vc = createContentsVC(index: index, str: str) else { return nil }
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        var index: Int
        let str: String
        
        switch pageViewController {
        case upperPageViewController:
            index = upperPageViewIndex
            if index >= upperPageViewArray.count - 1 { return nil }
            index += 1
            str = upperPageViewArray[index]
        case lowerPageViewController:
            index = lowerPageViewIndex
            if index >= lowerPageViewArray.count - 1 { return nil }
            index += 1
            str = lowerPageViewArray[index]
        default: fatalError("viewControllerBefore/fatalError")
        }
        guard let vc = createContentsVC(index: index, str: str) else { return nil }
        
        return vc
    }
    
}

// setPageViewController
extension ViewController {
    
    func setUpperPageViewController(direction: UIPageViewController.NavigationDirection = .forward) {
        
        let index = upperPageViewIndex
        let str   = upperPageViewArray[index]
        
        guard let vc = createContentsVC(index: index, str: str) else { return }
       
        self.upperPageViewController?.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
    }
    
    func setLowerPageViewController(direction: UIPageViewController.NavigationDirection = .forward) {
        
        let index = lowerPageViewIndex
        let str   = lowerPageViewArray[index]
        
        guard let vc = createContentsVC(index: index, str: str) else { return }
        
        self.lowerPageViewController?.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
    }
    
    func createContentsVC(index: Int, str: String) -> UIViewController? {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ContentsVC") as! ContentsVC
        vc.dataSource = ContentsVCDataStore.init(index: index, str: str)
        
        return vc
    }
    
}


class ContentsVC: UIViewController {
    
    var dataSource: ContentsVCDataStore!
    
    @IBOutlet weak var tLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tLabel.text = dataSource.str
    }
}

class ContentsVCDataStore {
    
    var index: Int
    var str: String
    
    init(index: Int, str: String) {
        self.index = index
        self.str = str
    }
}


//class UpperPageViewController: UIPageViewController {}

//class LowerPageViewController: UIPageViewController {}
