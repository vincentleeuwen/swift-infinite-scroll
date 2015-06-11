//
//  ViewController.swift
//  SwiftInfiniteScroll
//
//  Created by Yan Wye Huong on 31/8/14.
//  Copyright (c) 2014 Sprubix. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    let numPages: Int = 3
    var mainScrollView: UIScrollView?
    
    var views = [UIView]()
    var viewArray = [UIView]()
    
    var prevIndex: Int = 0, currIndex: Int = 0, nextIndex: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // create array of views
        for (var i = 0; i < 10; i++) {
            let colorView = UIView()
            var fm: CGRect = UIScreen.mainScreen().bounds
            colorView.frame = CGRectMake(0, 0, fm.size.width, 200)
            if i % 2 == 0 {
                colorView.backgroundColor = UIColor.whiteColor()
            } else {
                colorView.backgroundColor = UIColor.blueColor()
            }
            // let label
            let label = UILabel()
            label.frame = CGRectMake(10, 10, 150, 150)
            label.text = "Number \(i)"
            if i % 2 == 0 {
                label.textColor = UIColor.blueColor()
            } else {
                label.textColor = UIColor.whiteColor()
            }
            colorView.addSubview(label)
            
            viewArray.insert(colorView, atIndex: i)
        }
        
        initSubviews()
        
        view.backgroundColor = UIColor.lightGrayColor()
        
        view.addSubview(mainScrollView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSubviews() {
        var fm: CGRect = UIScreen.mainScreen().bounds
        
        self.mainScrollView = UIScrollView(frame:CGRectMake(0, 100, fm.size.width, 200))
        self.mainScrollView!.contentSize = CGSizeMake(self.mainScrollView!.frame.size.width * CGFloat(numPages), self.mainScrollView!.frame.size.height)
        self.mainScrollView!.backgroundColor = UIColor.greenColor()
        self.mainScrollView!.pagingEnabled = true
        self.mainScrollView!.bounces = false
        self.mainScrollView!.showsHorizontalScrollIndicator = false;
        self.mainScrollView!.scrollRectToVisible(CGRectMake(mainScrollView!.frame.size.width, 0, mainScrollView!.frame.size.width, mainScrollView!.frame.size.height), animated: false)

        self.mainScrollView!.delegate = self
        
        for i in 0...numPages {
            
            var tempView = UIView(frame:  CGRectMake(self.mainScrollView!.frame.size.width * CGFloat(i), 0, fm.size.width, 100))
            views.insert(tempView, atIndex: i)
            
            self.mainScrollView!.addSubview(views[i]);
        }
        
        loadPageWithId(9, onPage: 0)
        loadPageWithId(0, onPage: 1) // starting page
        loadPageWithId(1, onPage: 2)
    }
    
    func loadPageWithId(index: Int, onPage page: Int) {
        switch(page) {
        case 0:
            views[0].addSubview(viewArray[index])
            break
        case 1:
            views[1].addSubview(viewArray[index])
            break
        case 2:
            views[2].addSubview(viewArray[index])
            break
        default:
            break
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //println("scrolling...")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // moving forward
        if(scrollView.contentOffset.x > mainScrollView!.frame.size.width) {
            // load current doc data on first page
            loadPageWithId(currIndex, onPage: 0)
            
            // add one to current index or reset to 0 if reached end
            currIndex = (currIndex >= viewArray.count - 1) ? 0 : currIndex + 1
            loadPageWithId(currIndex, onPage: 1)
            
            // last page contains either next time in array or first if we reached the end
            nextIndex = (currIndex >= viewArray.count - 1) ? 0 : currIndex + 1
            loadPageWithId(nextIndex, onPage: 2)
        }
        
        // moving backward
        if(scrollView.contentOffset.x < mainScrollView!.frame.size.width) {
            // load current doc data on last page
            loadPageWithId(currIndex, onPage: 2)
            
            // subtract one from current index or go to the end if we have reached the beginning
            currIndex = (currIndex == 0) ? viewArray.count - 1 : currIndex - 1
            loadPageWithId(currIndex, onPage: 1)
            
            // first page contains either the prev item in array or the last item if we have reached the beginning
            prevIndex = (currIndex == 0) ? viewArray.count - 1 : currIndex - 1
            loadPageWithId(prevIndex, onPage: 0)
        }
        
        // reset offset to the middle page
        self.mainScrollView!.scrollRectToVisible(CGRectMake(mainScrollView!.frame.size.width, 0, mainScrollView!.frame.size.width, mainScrollView!.frame.size.height), animated: false)
    }
    
}

