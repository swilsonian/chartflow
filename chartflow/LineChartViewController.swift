//
//  LineChartViewController.swift
//  chartflow
//
//  Created by swilson on 1/15/16.
//  Copyright © 2016 tarokosoft. All rights reserved.
//

import Charts
import BAFluidView
import UIKit

let BLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"

//https://github.com/danielgindi/ios-charts/issues/485
//class  MyLineChartView: LineChartView {
 extension BarLineChartViewBase{
  
  func tapGestureRecognized(recognizer: UITapGestureRecognizer) {
    print("hey!")
    if (super.data == nil)// ._dataNotSet)
    {
      return
    }
    
    if (recognizer.state == UIGestureRecognizerState.Ended)
    {
      let h = getHighlightByTouchPoint(recognizer.locationInView(self))
      
      if (h === nil || h!.isEqual(self.lastHighlighted))
      {
        self.highlightValue(highlight: nil, callDelegate: true)
        self.lastHighlighted = nil
      }
      else
      {
        self.lastHighlighted = h
        self.highlightValue(highlight: h, callDelegate: true)
      }
      
      let connectionDetails = ["isConnected": h!.xIndex]
      NSNotificationCenter.defaultCenter().postNotificationName(
        BLEServiceChangedStatusNotification, object: self, userInfo: connectionDetails)
      
    }
   

  }
  
}

class LineChartViewController: UIViewController, ChartViewDelegate  {
  @IBOutlet weak var lineChartView: LineChartView!
  var fluidView:BAFluidView? = nil

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
  let months = ["Jan" , "Feb", "Mar", "Apr", "May", "June", "July", "August", "Sept", "Oct", "Nov", "Dec"]
  
  let dollars1 = [1453.0,2352,5431,1442,5451,6486,1173,5678,9234,1345,9411,2212]
  
  func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
    print(entry)
    //self.lineChartView.data?.getDataSetByIndex(0).entryForXIndex(userInfo["isConnected"]!)
  }
  
  func connectionChanged(notification: NSNotification) {
    // Connection status changed. Indicate on GUI.
    let userInfo = notification.userInfo as! [String: Int]
    
    dispatch_async(dispatch_get_main_queue(), {
      // Set image based on connection status
      //if let isConnected: Bool = userInfo["isConnected"] {
        //if let index: Bool = userInfo["index"] {
        print(self.lineChartView.data?.getDataSetByIndex(0).entryForXIndex(userInfo["isConnected"]!))
        print(userInfo["isConnected"])
        
//        self.sensorsCollectionView.setNeedsLayout()
//        self.sensorsCollectionView.reloadData()
        //}
     // }
    });
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("connectionChanged:"), name: BLEServiceChangedStatusNotification, object: nil)
    
    // 1
    self.lineChartView.fillFormatter = myBarLineChartFillFormatter(chart: self.lineChartView)
    self.lineChartView.delegate = self
    
    var marker:BalloonMarker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1.0), font: UIFont.systemFontOfSize(12.0), insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0))

    marker.minimumSize = CGSizeMake(80, 40);
    lineChartView.marker = marker;
    
    lineChartView.animate(yAxisDuration: 1.0,easingOption: ChartEasingOption.EaseInCubic)
    //animateWithYAxisDuration(3.0, easingOption:ChartEasingOption.EaseInCubic)
    //self.lineChartView.leftAxis.enabled = false
    //self.lineChartView.rightAxis.enabled = false
    lineChartView.borderColor = UIColor.blueColor()
        lineChartView.xAxis.labelTextColor = UIColor.whiteColor()
            lineChartView.rightAxis.labelTextColor = UIColor.whiteColor()
    lineChartView.leftAxis.labelTextColor = UIColor.grayColor()
    lineChartView.borderLineWidth = 5.0
    
    
    
    self.lineChartView.xAxis.drawGridLinesEnabled = true
        self.lineChartView.xAxis.drawLimitLinesBehindDataEnabled = false
    
    // 2
    self.lineChartView.descriptionText = "Tap node for details"
    // 3
    self.lineChartView.descriptionTextColor = UIColor.whiteColor()
//    self.lineChartView.backgroundColor = UIColor.blueColor()
    self.lineChartView.gridBackgroundColor = UIColor.clearColor()
    self.view.backgroundColor = UIColor.grayColor()

    //var left = UIView(frame: lineChartView.leftAxis.requiredSize())
    ///self.lineChartView.layer
    self.lineChartView.layer.backgroundColor = UIColor.clearColor().CGColor
    // 4
    self.lineChartView.noDataText = "No data provided"
    // 5
    setChartData(months)



    //lineChartView.layer.insertSublayer(fluidView.layer, atIndex: 0)
    //lineChartView.sendSubviewToBack(fluidView)

  }
  
  override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        fluidView?.startElavation = -0.3
    fluidView?.backgroundColor = UIColor.grayColor()
    lineChartView.animate(yAxisDuration: 1,easingOption: ChartEasingOption.EaseInCubic)
    fluidView!.startAnimation();
  }
  
  override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
//        fluidView?.startElavation = 0.0
    fluidView?.backgroundColor = UIColor.orangeColor()
    var gridSize = CGRectMake(lineChartView.frame.minX, lineChartView.frame.minY, lineChartView.viewPortHandler.contentRect.width, lineChartView.viewPortHandler.contentRect.height)
    gridSize.offsetInPlace(dx: lineChartView.viewPortHandler.offsetLeft , dy: lineChartView.viewPortHandler.offsetTop  )
    fluidView!.frame = gridSize
       //fluidView!.startAnimation();
    
  }
  
  override func viewDidAppear(animated: Bool) {
    // ADD OFFSET
    //var gridSize = CGRectMake(lineChartView.layer.contentsRect.minX, lineChartView.layer.contentsRect.minY, lineChartView.viewPortHandler.chartWidth, lineChartView.viewPortHandler.chartHeight)
    var gridSize = CGRectMake(lineChartView.frame.minX, lineChartView.frame.minY, lineChartView.viewPortHandler.contentRect.width, lineChartView.viewPortHandler.contentRect.height)
//    var gridSize = lineChartView.viewPortHandler.contentRect
    print(lineChartView.contentRect.width - lineChartView.layer.contentsRect.width / 2)
    print(lineChartView.viewPortHandler.contentRect)
    
    //lineChartView.xAxisRenderer.viewPortHandler.offsetLeft
    print(lineChartView.viewPortHandler.offsetLeft)
    //gridSize.offsetInPlace(dx: lineChartView.layer.contentsRect.width - lineChartView.contentRect.width , dy: 0)
    gridSize.offsetInPlace(dx: lineChartView.viewPortHandler.offsetLeft , dy: lineChartView.viewPortHandler.offsetTop  )
     fluidView = BAFluidView.init(frame: gridSize , startElevation: -0.3)
    //var fluidView:BAFluidView = BAFluidView.init(frame: lineChartView.frame, startElevation: 0.3)

    fluidView!.fillAutoReverse = false;
    fluidView!.backgroundColor = UIColor.orangeColor()
    fluidView!.fillRepeatCount = 1;
    fluidView!.fillColor = UIColor(hex:0x397ebe);
    fluidView!.fillTo(1.0);
    fluidView!.layer.zPosition = -1
        fluidView!.fillDuration = 3.0
    fluidView!.strokeColor = UIColor.whiteColor()
    fluidView!.userInteractionEnabled = false
    view.addSubview(fluidView!)
    //fluidView.addSubview(lineChartView)
    lineChartView.layoutIfNeeded()
    lineChartView.layer.needsDisplay()

    
        //var gridSize = lineChartView.viewForLastBaselineLayout.bounds//lineChartView.xAxisRenderer.viewPortHandler.contentRect
    //var gridSize = lineChartView.contentRect//lineChartView.xAxisRenderer.viewPortHandler.contentRect
//    print(lineChartView.xAxisRenderer.viewPortHandler.offsetLeft)
//    print(lineChartView.xAxisRenderer.viewPortHandler.offsetRight)
//    print(lineChartView.layoutMargins)
    //lineChartView.contentRect.origin.x
    
    //gridSize.offsetInPlace(dx: lineChartView.leftAxis.requiredSize().width - lineChartView.layoutMargins.left - 2.5, dy: (lineChartView.layer.bounds.height - lineChartView.viewPortHandler.contentHeight)/2 + 10)
//    var fluidView:BAFluidView = BAFluidView.init(frame: gridSize , startElevation: 0.1)
//    //var fluidView:BAFluidView = BAFluidView.init(frame: lineChartView.frame, startElevation: 0.3)
//    fluidView.fillAutoReverse = false;
//    fluidView.fillRepeatCount = 1;
//    fluidView.fillColor = UIColor(hex:0x397ebe);
//    fluidView.fillTo(1.0);
    
    fluidView!.startAnimation();
    
    var maskingImage:UIImage =  UIImage(named: "icon")!;
    var maskingLayer:CALayer = CALayer();
    
    
    //maskingLayer.frame = CGRectMake(CGRectGetMidX(fluidView.frame) - maskingImage.size.width/2, 70, maskingImage.size.width, maskingImage.size.height);
    //maskingLayer.contents = maskingImage.CGImage;
    //fluidView.layer.mask = maskingLayer;
    //fluidView.layer.mask = self.view.layer.mask
    
    
    

    print(lineChartView.layer.sublayers)
    //self.lineChartView.layer.insertSublayer(fluidView.layer, below: lineChartView.layer)
    //self.view.layer.insertSublayer(fluidView.layer, below: lineChartView.layer)
    //print(lineChartView.getChartImage(transparent: true).CGImage)
    
    ////view.insertSubview(fluidView, atIndex: 0)
    
    //lineChartView.getChartImage(transparent: true)
    
    //add to fill formatter
    
    //lineChartView.insertSubview(fluidView, atIndex: 0)
    //lineChartView.layer.insertSublayer(fluidView.layer, atIndex: 0)
    
//    lineChartView.viewPortHandler.offsetLeft
//    lineChartView.viewForLastBaselineLayout.sendSubviewToBack(fluidView)
//    lineChartView.layer.layoutSublayers()
    
    

  }
  
  func setChartData(months : [String]) {
    // 1 - creating an array of data entries
    var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
    for var i = 0; i < months.count; i++ {
      yVals1.append(ChartDataEntry(value: dollars1[i], xIndex: i))
    }
    
    // 2 - create a data set with our array
    let set1: LineChartDataSet = LineChartDataSet(yVals: yVals1, label: "First Set")
    
    set1.axisDependency = .Left // Line will correlate with left axis values
    set1.setColor(UIColor.whiteColor().colorWithAlphaComponent(0.5)) // our line's opacity is 50%
    set1.setCircleColor(UIColor.blueColor()) // our circle will be dark red

    set1.lineWidth = 2.0
    set1.circleRadius = 6.0 // the radius of the node circle
    set1.fillAlpha = 255.0 / 255.0
    set1.fillColor = UIColor.blackColor()
    set1.drawFilledEnabled = true
    set1.highlightColor = UIColor.whiteColor()
    set1.drawCircleHoleEnabled = true
    set1.drawCubicEnabled = true
    set1.label = "SET 1 DATA"
    
    //3 - create an array to store our LineChartDataSets
    var dataSets : [LineChartDataSet] = [LineChartDataSet]()
    dataSets.append(set1)
    
    //4 - pass our months in for our x-axis label value along with our dataSets
    let data: LineChartData = LineChartData(xVals: months, dataSets: dataSets)
    data.setValueTextColor(UIColor.whiteColor())
    data.setValueFont(UIFont(name: "Arial", size: 12.0))
    
    //5 - finally set our data
    self.lineChartView.data = data
  }


  /// Default formatter that calculates the position of the filled line.
internal   class myBarLineChartFillFormatter: NSObject, ChartFillFormatter
  {
    private weak var _chart: BarLineChartViewBase!
    
    internal init(chart: BarLineChartViewBase)
    {
      _chart = chart
      
    }
    
    internal func getFillLinePosition(dataSet dataSet: LineChartDataSet, data: LineChartData, chartMaxY: Double, chartMinY: Double) -> CGFloat
    {
      var swap = chartMaxY
      var thechartMaxY = chartMinY
      var thechartMinY = swap
      
      
      thechartMinY = chartMinY
      thechartMaxY = chartMaxY
      
      return CGFloat(chartMaxY)
      
      var thedataSet_yMax = dataSet.yMin
        var    thedataSet_yMin = dataSet.yMax
      
      var fillMin = CGFloat(0.0)
      
      if (thedataSet_yMax > 0.0 && thedataSet_yMin < 0.0)
      {
        fillMin = 0.0
      }
      else
      {
        if (!_chart.getAxis(dataSet.axisDependency).isStartAtZeroEnabled)
        {
          var max: Double, min: Double
          
          if (thedataSet_yMax > 0.0)
          {
            max = 0.0
          }
          else
          {
            max = thechartMaxY
          }
          
          if (thedataSet_yMin < 0.0)
          {
            min = 0.0
          }
          else
          {
            min = thechartMinY
          }
          
          fillMin = CGFloat(thedataSet_yMin >= 0.0 ? min : max)
        }
        else
        {
          fillMin = 0.0
        }
      }
      
      print(fillMin)
      return fillMin
    }
  }

}
