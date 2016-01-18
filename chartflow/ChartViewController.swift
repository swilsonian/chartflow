import UIKit
import Charts
//import CoreMotion

class ChartViewController: UIViewController, ChartViewDelegate {
  
  @IBOutlet weak var chartView: BarChartView!
  var days:[String] = []
  var stepsTaken:[Int] = [5, 10, 15, 20, 20, 25, 30]
//  let activityManager = CMMotionActivityManager()
//  let pedoMeter = CMPedometer()
  
  var cnt = 0
  override func viewDidLoad() {
    super.viewDidLoad()
    chartView.delegate = self;
    
    chartView.descriptionText = "";
    chartView.noDataTextDescription = "Data will be loaded soon."
    
    chartView.drawBarShadowEnabled = false
    chartView.drawValueAboveBarEnabled = true
    
    chartView.maxVisibleValueCount = 60
    chartView.pinchZoomEnabled = false
    chartView.drawGridBackgroundEnabled = true
    chartView.drawBordersEnabled = false
    
    getDataForLastWeek()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func dismiss(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func getDataForLastWeek() {
    
    //dispatch_sync(dispatch_get_main_queue(), { () -> Void in
      let xVals = self.days
      var yVals: [BarChartDataEntry] = []
      for idx in 0...6 {
        yVals.append( BarChartDataEntry(
          value: Double(self.stepsTaken[idx]), xIndex: idx))
      }
      print("Days :\(self.days)")
      print("Steps :\(self.stepsTaken)")
      
      let set1 = BarChartDataSet(yVals: yVals, label: "Steps Taken")
      set1.barSpace = 0.25
      
      let data = BarChartData(xVals: xVals, dataSet: set1)
      data.setValueFont(UIFont(name: "Avenir", size: 12))
      self.chartView.data = data
      self.view.reloadInputViews()
      //})
    
  }
  
    
}


