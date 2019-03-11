//
//  SlidingViewController.swift
//  UIScrollerControl_Swift
//
//  Created by auger on 2019/3/11.
//  Copyright © 2019 HuaSuan. All rights reserved.
//

/// 滑动控制层

import UIKit

class SlidingViewController: UIViewController {

    var ishasNavigationBar = true
    
    var selectedIndex: Int = 0
    
    var topBar = SlidingTopBar()
    
    fileprivate var currentIndex = 0 {
        didSet {
            resetTitleViewContentOffset()
            postIndexChangedNotification()
        }
    }
    
    fileprivate var titleItemArray = [SlidingTopLabel]()
    /// 底部线条
    fileprivate lazy var slider: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.bounds = CGRect(x: 0, y: 0, width: 0, height: 3)
        view.layer.cornerRadius = 1
        view.clipsToBounds = true
        view.backgroundColor = UIColor.red
        return view
    }()
    
    fileprivate lazy var titleView: UIScrollView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let view = UIScrollView(frame: CGRect.zero)
        view.delegate = self
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    fileprivate lazy var separateLine = UIImageView()
    fileprivate lazy var contentView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
}

//MARK: - public func(外部刷新使用)
extension SlidingViewController {
    /// reload everything
    @objc func reload() {
        view.setNeedsLayout()
        contentView.reloadData()
        addTitles()
    }
}

//MARK: life cycle
extension SlidingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectedTitleItem(at: selectedIndex)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let orient = UIDevice.current.orientation
        var toTop: CGFloat = 0
        switch orient {
        /// 处理旋转
        case .landscapeLeft, .landscapeRight:
            toTop = ishasNavigationBar ? 32 : 0
        /// 动态获取高度状态栏和导航栏的高度
        default:
            let statusHeight = UIApplication.shared.statusBarFrame.size.height
            let navigationHeight = self.navigationController?.navigationBar.frame.size.height ?? 44.0
            toTop = ishasNavigationBar ? (statusHeight + navigationHeight) : 20
        }
        let titlex: CGFloat = 0
        let titley: CGFloat = toTop
        let titlew: CGFloat = view.bounds.size.width
        let titleh: CGFloat = topBar.height
        titleView.frame = CGRect(x: titlex, y: titley, width: titlew, height: titleh)
        
        let linex: CGFloat = 0
        let liney: CGFloat = titley + titleh
        let linew: CGFloat = titlew
        let lineh: CGFloat = 0.5
        separateLine.backgroundColor = topBar.separateLineColor
        separateLine.frame = CGRect(x: linex, y: liney, width: linew, height: lineh)
        
        let contentx: CGFloat = 0
        let contenty: CGFloat = liney + lineh
        let contentw: CGFloat = linew
        let contenth: CGFloat = view.bounds.size.height - contenty
        contentView.frame = CGRect(x: contentx, y: contenty, width: contentw, height: contenth)
        
    }
}

//MARK: - private
extension SlidingViewController {
    
    /// Baisc config
    fileprivate func config() {
        view.addSubview(titleView)
        view.addSubview(separateLine)
        view.addSubview(contentView)
        titleView.addSubview(slider)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    fileprivate func postIndexChangedNotification() {
        NotificationCenter.default.post(name: .topBarControllerDidChangeIndex, object: children[currentIndex])
        NotificationCenter.default.post(name: .topBarControllerDidChangeToIndex, object: children[currentIndex], userInfo: ["index": currentIndex])
    }
}

//MARK: - title view
extension SlidingViewController {
    
    fileprivate func addTitles() {
        _ = titleItemArray.map { $0.removeFromSuperview() }
        titleItemArray.removeAll()
        if children.count == 0 {
            slider.isHidden = true
            return
        }
        slider.isHidden = !topBar.isHasSlider
        var lastX: CGFloat = 0
        for i in 0..<children.count {
            let title = children[i].title ?? ""
            
            let x = lastX
            let y: CGFloat = 0
            let height = topBar.height
            var width: CGFloat = 0
            if topBar.isScrollEnable {
                width = CGFloat(Int(title.width(font: topBar.item.normalFont, maxHeight: height) + topBar.itemSpace * 2))
            }else {
                width = view.frame.size.width / CGFloat(children.count)
            }
            width += 1
            let label = SlidingTopLabel(frame: CGRect(x: x, y: y, width: width, height: height))
            label.text = title
            label.tag = i + 100
            label.item = topBar.item
            label.isSelected = currentIndex == i
            label.backgroundColor = topBar.item.normalBackgroundColor
            titleView.addSubview(label)
            titleItemArray.append(label)
            lastX = x + width - 1
            
            /// 标题点击事件
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapTitleItem))
            label.addGestureRecognizer(tap)
            
            if currentIndex == i {
                var frame = slider.frame
                frame.size.width = sliderWidth(with: title)
                slider.frame = frame
                var center = label.center
                center.y = height - 5
                slider.center = center
            }
        }
        titleView.contentSize = CGSize(width: lastX, height: topBar.height)
        titleView.bringSubviewToFront(slider)
    }
    
    fileprivate func resetTilteItem(at index: Int, offset: CGFloat) {
        titleItemArray[index].setOffset(offset)
    }
    
    /// tapGestureRecognizer hanlder
    @objc fileprivate func tapTitleItem(_ tap: UITapGestureRecognizer) {
        guard let tapView = tap.view else { return }
        let tag = tapView.tag - 100
        let value = abs(tag - currentIndex)
        if value == 0 {
            return
        }else if value == 1 {
            let contentOffset = CGPoint(x: CGFloat(tag) * contentView.bounds.size.width, y: 0)
            contentView.setContentOffset(contentOffset, animated: true)
        }else {
            selectedTitleItem(at: tag)
        }
    }
    
    fileprivate func selectedTitleItem(at index: Int) {
        let oldIndex = currentIndex
        currentIndex = index
        titleItemArray[oldIndex].isSelected = false
        titleItemArray[currentIndex].isSelected = true
        resetSlider(at: currentIndex, offset: 0)
        
        let contentOffsetX = contentView.bounds.size.width * CGFloat(currentIndex)
        contentView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: false)
    }
    
    fileprivate func resetTitleViewContentOffset() {
        selectedIndex = currentIndex
        if topBar.isScrollEnable {
            let item = titleItemArray[currentIndex]
            let frame = item.convert(item.bounds, to: view)
            let value = frame.origin.x + frame.size.width * 0.5 - titleView.bounds.size.width * 0.5
            var offsetX = titleView.contentOffset.x + value
            let maxOffsetX = titleView.contentSize.width - titleView.bounds.size.width
            offsetX = offsetX > maxOffsetX ? maxOffsetX : offsetX
            offsetX = offsetX < 0 ? 0 : offsetX
            titleView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
        
    }
}

//MARK: - slider
extension SlidingViewController {
    fileprivate func resetSlider(at index: Int, offset: CGFloat) {
        if topBar.isHasSlider == false { return }
        if offset == 0 {
            var center = slider.center
            center.x = titleItemArray[index].center.x
            slider.center = center
            var frame = slider.frame
            frame.size.width = sliderWidth(with: titleItemArray[index].text ?? "")
            slider.frame = frame
        }else if index + 1 < titleItemArray.count {
            let preLabel = titleItemArray[index]
            let nextLabel = titleItemArray[index + 1]
            let beganCenterX = preLabel.center.x
            let endCenterX = nextLabel.center.x
            let beganTitle = preLabel.text ?? ""
            let endTitle = nextLabel.text ?? ""
            let beganWidth = sliderWidth(with: beganTitle)
            let endWidth = sliderWidth(with: endTitle)
            
            var center = slider.center
            center.x = beganCenterX + (endCenterX - beganCenterX) * offset
            slider.center = center
            var frame = slider.frame
            frame.size.width = beganWidth + (endWidth - beganWidth) * offset
            slider.frame = frame
        }
    }
    
    fileprivate func sliderWidth(with text: String) -> CGFloat {
        return text.width(font: topBar.item.normalFont, maxHeight: topBar.height) + 8
    }
    
}

//MARK: - CollectionView datasource
extension SlidingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.children.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let view = children[indexPath.row].view
        cell.contentView.addSubview(view!)
        view?.frame = cell.bounds
    }
    
}

//MARK: - CollectionView delegate flowlayout
extension SlidingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return contentView.bounds.size
    }
    
}

//MARK: - UIScrollerViewDelegate
extension SlidingViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == contentView else { return }
        let totalOffsetValue = contentView.contentOffset.x / contentView.bounds.size.width
        let pageoOffset = totalOffsetValue.truncatingRemainder(dividingBy: 1.0)
        let index = Int(totalOffsetValue)
        resetSlider(at: index, offset: pageoOffset)
        for i in index-2...index+2 {
            if i >= 0 && i < titleItemArray.count {
                let offset = abs(totalOffsetValue - CGFloat(i))
                resetTilteItem(at: i, offset: offset)
            }
        }
    }
    
    /// 设置contentOffset,并开启动画时触发
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard scrollView == contentView else { return }
        scrollViewDidEndScroll(scrollView)
    }
    
    /// 滚动scrollView松开停止后触发
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == contentView else { return }
        scrollViewDidEndScroll(scrollView)
    }
    
    /// 自定义方法
    func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        guard index <= children.count else { return }
        if index != currentIndex {
            currentIndex = index
        }
    }
    
}

extension NSNotification.Name {
    static let topBarControllerDidChangeIndex = NSNotification.Name(rawValue: "topBarControllerDidChangeIndex")
    static let topBarControllerDidChangeToIndex = NSNotification.Name(rawValue: "topBarControllerDidChangeToIndex")
}

