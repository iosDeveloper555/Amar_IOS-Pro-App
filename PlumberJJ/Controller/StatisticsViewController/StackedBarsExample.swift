//
//  StackedBarsExample.swift
//  Examples
//
//  Created by ischuetz on 15/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit
import SwiftCharts


class StackedBarsExample: RootBaseViewController {
    var barArrSet:NSMutableArray=[]
    var barTitleArrset:NSMutableArray=[]
    var maxEarnings:NSInteger!
    var interval:NSInteger!
    var currencyCode:NSString!
    fileprivate var chart: Chart? // arc
    
    let sideSelectorHeight: CGFloat = 50

    fileprivate func chart(horizontal: Bool) -> Chart {
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
       
        let color2 = PlumberThemeColor.withAlphaComponent(0.8)
       
        
        let zero = ChartAxisValueDouble(0)
        let barModels = [
            ChartStackedBarModel(constant: ChartAxisValueString(barTitleArrset.object(at: 5) as! String, order: 1, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: Double("\(barArrSet.object(at: 5))")!, bgColor: color2)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(barTitleArrset.object(at: 4) as! String, order: 2, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: Double("\(barArrSet.object(at: 4))")!, bgColor: color2)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(barTitleArrset.object(at: 3) as! String, order: 3, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: Double("\(barArrSet.object(at: 3))")!, bgColor: color2)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(barTitleArrset.object(at: 2) as! String, order: 4, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: Double("\(barArrSet.object(at: 2))")!, bgColor: color2)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(barTitleArrset.object(at: 1) as! String, order: 5, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: Double("\(barArrSet.object(at: 1))")!, bgColor: color2)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(barTitleArrset.object(at: 0) as! String, order: 6, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: Double("\(barArrSet.object(at: 0))")!, bgColor: color2)
                ])
        ]
        
        let (axisValues1, axisValues2) = (
            stride(from: 0, through: maxEarnings, by: interval).map{ChartAxisValueDouble.init($0, formatter: NumberFormatter() , labelSettings: labelSettings)},
            [ChartAxisValueString("", order: 0, labelSettings: labelSettings)] + barModels.map{$0.constant} + [ChartAxisValueString("", order: 7, labelSettings: labelSettings)])
        
         print((axisValues1, axisValues2))
        let (xValues, yValues) = horizontal ? (axisValues1, axisValues2) : (axisValues2, axisValues1)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: Language_handler.VJLocalizedString("months", comment: nil), settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "\(Language_handler.VJLocalizedString("earning_in", comment: nil)) \(currencyCode!)", settings: labelSettings.defaultVertical()))
        print(yModel)
        
        let frame = ExamplesDefaults.chartFrame(containerBounds: self.view.bounds)
        let chartFrame = self.chart?.frame ?? CGRect(x: frame.origin.x, y: frame.origin.y-60, width: frame.size.width, height: frame.size.height-70)
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxisLayer.axis, coordsSpace.yAxisLayer.axis, coordsSpace.chartInnerFrame)
        
        let chartStackedBarsLayer = ChartStackedBarsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, barModels: barModels, horizontal: horizontal, barWidth: 30, settings:ChartBarViewSettings())
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: coordsSpace.xAxisLayer, yAxisLayer: coordsSpace.yAxisLayer, axis: ChartGuideLinesLayerAxis.xAndY, settings: settings)
        
//        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        
        return Chart(frame: chartFrame, settings: ExamplesDefaults.chartSettings, layers: [
            coordsSpace.xAxisLayer,
            coordsSpace.yAxisLayer,
            guidelinesLayer,
            chartStackedBarsLayer
            ])
    }
    
     func showChart(horizontal: Bool) {
        self.chart?.clearView()
        
        let chart = self.chart(horizontal: horizontal)
        self.view.addSubview(chart.view)
        self.chart = chart
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.showChart(horizontal: false)
       
    }
    
    class DirSelector: UIView {
        
        let horizontal: UIButton
        let vertical: UIButton
        
        weak var controller: StackedBarsExample?
        
        fileprivate let buttonDirs: [UIButton : Bool]
        
        init(frame: CGRect, controller: StackedBarsExample) {
            
            self.controller = controller
            
            self.horizontal = UIButton()
            self.horizontal.setTitle("Horizontal", for: UIControl.State())
            self.vertical = UIButton()
            self.vertical.setTitle("Vertical", for: UIControl.State())
            
            self.buttonDirs = [self.horizontal : true, self.vertical : false]
            
            super.init(frame: frame)
            
            self.addSubview(self.horizontal)
            self.addSubview(self.vertical)
            
            for button in [self.horizontal, self.vertical] {
                button.titleLabel?.font = ExamplesDefaults.fontWithSize(size: 14)
                button.setTitleColor(UIColor.blue, for: UIControl.State())
                button.addTarget(self, action: #selector(DirSelector.buttonTapped(_:)), for: .touchUpInside)
            }
        }
        
        @objc func buttonTapped(_ sender: UIButton) {
            let horizontal = sender == self.horizontal ? true : false
            controller?.showChart(horizontal: horizontal)
        }
        
        override func didMoveToSuperview() {
            let views = [self.horizontal, self.vertical]
            for v in views {
                v.translatesAutoresizingMaskIntoConstraints = false
            }
            
            let namedViews = views.enumerated().map{index, view in
                ("v\(index)", view)
            }
            
            let viewsDict = namedViews.reduce(Dictionary<String, UIView>()) {(u, tuple) in
                var u = u
                u[tuple.0] = tuple.1
                return u
            }
            
            let buttonsSpace: CGFloat = Env.iPad ? 20 : 10
            
            let hConstraintStr = namedViews.reduce("H:|") {str, tuple in
                "\(str)-(\(buttonsSpace))-[\(tuple.0)]"
            }
            
            let vConstraits = namedViews.flatMap {NSLayoutConstraint.constraints(withVisualFormat: "V:|[\($0.0)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDict)}
            
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: hConstraintStr, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDict)
                + vConstraits)
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
