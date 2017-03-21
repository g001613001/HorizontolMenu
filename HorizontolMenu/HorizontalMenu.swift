//
//  HorizontalMenu.swift
//  iTVCloud
//
//  Created by 丁偉哲 on 2017/3/20.
//  Copyright © 2017年 丁偉哲. All rights reserved.
//

import UIKit
extension HorizontalMenu : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return titles.count * defaultInfiniteValue
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HorizontalMenu4CVCell
        cell.label4Title.text = titles[indexPath.row % titles.count]
        cell.label4Title.tag = 100 //用來辨識變色處理
        return cell
    }
}
extension HorizontalMenu : UICollectionViewDelegateFlowLayout {
    //設置集合視圖單元格大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: screenWidth / 3, height: 44)
    }
    
    // 設置cell和視圖邊的間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // 設置每一個cell最小 行 間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 設置每一個cell的 列 間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    // 設置Header的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: 0, height: 0)
    }
    
    // 設置Footer的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return CGSize(width: 0, height: 0)
    }
}
extension HorizontalMenu : UICollectionViewDelegate{
    //MARK:- 點擊的項目移動到中間的處理以及變色處理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        collectionView.scrollToItem(at: indexPath , at: .centeredHorizontally, animated: true)//點擊的項目移動到中間的處理
        //改變所有的cell為deSelectCellColor
        for (_, indexPath) in indexPaths.enumerated() {
            setCellBackColorAndTitleColor(index: indexPath, cellBGColor: deSelectCellColor, cellTitleBGColor: deSelectCellTitleColor)
        }
        //處理點擊到的Cell變色處理
        setCellBackColorAndTitleColor(index: indexPath, cellBGColor: selectCellColor, cellTitleBGColor: selectCellTitleColor)
    }
}
//MARK:- 滾動＋拖動的項目移動到中間的處理
extension HorizontalMenu : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkScrollViewPoint(scrollView: scrollView)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        checkScrollViewPoint(scrollView: scrollView)
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        checkScrollViewPoint(scrollView: scrollView)
    }
    fileprivate func checkScrollViewPoint(scrollView: UIScrollView){
        if scrollView == collectionView {
            var currentCellOffset = collectionView.contentOffset
            currentCellOffset.x += collectionView.frame.size.width / 2
            guard let indexPath = collectionView.indexPathForItem(at: currentCellOffset) else { return }
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            //改變所有cell的原色為deSelectColor
            for (_, indexPath) in indexPaths.enumerated() {
                setCellBackColorAndTitleColor(index: indexPath, cellBGColor: deSelectCellColor, cellTitleBGColor: deSelectCellTitleColor)
            }
            //改變label顏色
            setCellBackColorAndTitleColor(index: indexPath, cellBGColor: selectCellColor, cellTitleBGColor: selectCellTitleColor)
        }
    }
}
class HorizontalMenu: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    //使用者自定義的部份
    fileprivate var titles = ["頻道","最新消息"]
    var selectCellColor = UIColor.darkGray//選擇到的cell顏色
    var deSelectCellColor = UIColor.black//取消選擇的cell顏色
    var selectCellTitleColor = UIColor.white//選擇到的title顏色
    var deSelectCellTitleColor = UIColor.gray//取消選擇的title顏色
    //
    let screenWidth = UIScreen.main.bounds.width
    fileprivate var defaultInfiniteValue = 5000//用來設定傻瓜版無限滾動
    fileprivate var defaultIndexPath:IndexPath! {
        return IndexPath(row: self.defaultInfiniteValue / 2, section: 0)
    }
    fileprivate var indexPaths: [IndexPath] = []//用來取得所有的indexPath
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllIndexPath()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //因為是傻瓜版的無限滾動，所以需要先移動到所有indexPath的中間
        collectionView.scrollToItem(at: defaultIndexPath, at: .centeredHorizontally, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //在畫面顯示後，讓123行的cell改變顏色成為選擇的顏色
            setCellBackColorAndTitleColor(index: defaultIndexPath, cellBGColor: selectCellColor, cellTitleBGColor: selectCellTitleColor)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 用來改變cell background color & cell中的label background color
    ///
    /// - Parameters:
    ///   - index: <#index description#>
    ///   - cellBGColor: <#cellBGColor description#>
    ///   - cellTitleBGColor: <#cellTitleBGColor description#>
    fileprivate func setCellBackColorAndTitleColor(index:IndexPath, cellBGColor:UIColor, cellTitleBGColor:UIColor){
        //改變Cell Background color
        guard let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: index) else { return }
        selectedCell.contentView.backgroundColor = cellBGColor
        //改變label顏色
        guard let cell = collectionView.cellForItem(at: index) else { return }
        let label = cell.viewWithTag(100) as? UILabel
        label?.textColor = cellTitleBGColor
    }
    /// 取得所有的indexPath 存到 陣列中供後續處理變色
    fileprivate func getAllIndexPath(){
        for s in 0..<collectionView.numberOfSections {
            for i in 0..<collectionView.numberOfItems(inSection: s) {
                indexPaths.append(IndexPath(row: i, section: s))
            }
        }
    }
    
}
