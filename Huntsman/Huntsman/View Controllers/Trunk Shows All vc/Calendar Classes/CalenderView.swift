//
//  CalenderView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

struct Colors {
    static var darkGray = #colorLiteral(red: 0.3764705882, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
    static var darkRed = #colorLiteral(red: 0.5607843137, green: 0, blue: 0.1647058824, alpha: 1)
}

struct Style {
    static var bgColor = UIColor.white
    static var monthViewLblColor = UIColor.black
    static var monthViewBtnRightColor = UIColor.black
    static var monthViewBtnLeftColor = UIColor.black
    static var activeCellLblColor = UIColor.white
    static var ActiveCellGreencolor = Colors.darkRed//UIColor.green
    static var activeCellLblColorHighlighted = UIColor.black
    static var weekdaysLblColor = UIColor.black
    
    static func themeDark(){
        bgColor = Colors.darkGray
        monthViewLblColor = UIColor.white
        monthViewBtnRightColor = UIColor.white
        monthViewBtnLeftColor = UIColor.white
        activeCellLblColor = UIColor.white
        ActiveCellGreencolor = Colors.darkRed//UIColor.green
        activeCellLblColorHighlighted = UIColor.black
        weekdaysLblColor = UIColor.white
    }
    
    static func themeLight(){
        bgColor = UIColor.white
        monthViewLblColor = UIColor.black
        monthViewBtnRightColor = UIColor.black
        monthViewBtnLeftColor = UIColor.black
        activeCellLblColor = UIColor.black
        ActiveCellGreencolor = Colors.darkRed//UIColor.green
        activeCellLblColorHighlighted = UIColor.white
        weekdaysLblColor = UIColor.black
    }
}

class CalenderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {
    
    var delegate: CalenderDelegate?
    func didChangeMonthPrivous(monthIndex: Int, year: Int, StrFlage: NSString) {
        delegate?.didTap_PrivousMonth(date:StrFlage as String)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func didChangeNext(monthIndex: Int, year: Int, StrFlage: NSString) {
        delegate?.didTap_NextMonth(date:StrFlage as String)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
     @objc func loadList(){
        //load data here
        myCollectionView.reloadData()
    }
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentMonthEvent: Int = 0
    var currentYearEvent: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    
    var bookedSlotDate = [Int]()
    var Trunk_shows_Filter_Array = [] as NSMutableArray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)

        initializeView()
    }
    
    convenience init(theme: MyTheme) {
        self.init()
        
        if theme == .dark {
            Style.themeDark()
        } else {
            Style.themeLight()
        }
        
        initializeView()
    }
    
    func changeTheme() {
        myCollectionView.reloadData()
        
        monthView.lblName.textColor = Style.monthViewLblColor
        monthView.btnRight.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        monthView.btnLeft.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        
        for i in 0..<7 {
            (weekdaysView.myStackView.subviews[i] as! UILabel).textColor = Style.weekdaysLblColor
        }
    }
    
    func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentMonthEvent = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        currentYearEvent = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth=getFirstWeekDay()
        
        //for leap years, make february month of 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        //end
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        
        setupViews()
        
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        cell.backgroundColor=UIColor.clear
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden=true
        } else {
            bookedSlotDate = [0]
            if  UserDefaults.standard.value(forKey: "allcalendarlist") != nil
            {
                bookedSlotDate = [0]
                bookedSlotDate = (NSKeyedUnarchiver.unarchiveObject(with: PreferenceUtil.getCalendarList() as Data)) as! [Int]
            }
            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            cell.isHidden = false
            cell.dateLbl.text = "\(calcDate)"
            
           // print(calcDate)
            if bookedSlotDate.contains(calcDate){
                cell.dateLbl.textColor = Colors.darkRed//UIColor.green
                if currentMonthIndex == currentMonthEvent && currentYear == currentYearEvent
                {
                    if todaysDate == calcDate
                    {
                        cell.dateLbl.textColor = UIColor.white
                        cell.backgroundColor=Colors.darkRed
                    }
                }
            }
            else
            {
                if currentMonthIndex == currentMonthEvent && currentYear == currentYearEvent
                {
                    if todaysDate == calcDate
                    {
                        cell.dateLbl.textColor = UIColor.white
                        cell.backgroundColor=Colors.darkRed
                    }
                    else
                    {
                        cell.dateLbl.textColor = Style.activeCellLblColor
                    }
                }
                else
                {
                    cell.dateLbl.textColor = Style.activeCellLblColor
                }
            }
            /*
             if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex  {
             cell.isUserInteractionEnabled=true
             if bookedSlotDate.contains(calcDate){
             cell.dateLbl.textColor = UIColor.green
             }
             else
             {
             cell.dateLbl.textColor = Style.activeCellLblColor
             }
             } else if bookedSlotDate.contains(calcDate){
             cell.isUserInteractionEnabled=true
             cell.dateLbl.textColor = UIColor.green
             
             } else {
             cell.isUserInteractionEnabled=true
             cell.dateLbl.textColor = Style.activeCellLblColor
             }
             */
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
      //  cell?.backgroundColor = UIColor.clear
        let calcDate = indexPath.row-firstWeekDayOfMonth+2
        print("calcDate = \(calcDate), indexPath.row = \(indexPath.row)")
        if  bookedSlotDate.contains(calcDate) {
           // cell?.backgroundColor=Colors.darkRed
            let lbl = cell?.subviews[1] as! UILabel
           // lbl.textColor = Colors.darkRed//UIColor.green
            lbl.textColor=UIColor.white
            cell?.backgroundColor=Colors.darkRed
            if currentMonthIndex == currentMonthEvent && currentYear == currentYearEvent
            {
                if todaysDate == calcDate
                {
                    lbl.textColor = UIColor.white
                    cell?.backgroundColor=Colors.darkRed
                }
            }
           //
            delegate?.didTapDate(date: "\(calcDate)/0\(currentMonthIndex)/\(currentYear)", available: true)
        } else {
            //cell?.backgroundColor=Colors.darkRed
            let lbl = cell?.subviews[1] as! UILabel
          //  lbl.textColor=UIColor.white
            if currentMonthIndex == currentMonthEvent && currentYear == currentYearEvent
            {
                if todaysDate == calcDate
                {
                    lbl.textColor = UIColor.white
                    cell?.backgroundColor=Colors.darkRed
                }
                else
                {
                   // lbl.textColor=UIColor.white
                }
            }
            delegate?.didTapDate(date: "\(calcDate)/0\(currentMonthIndex)/\(currentYear)", available: true)
        }
         self.myCollectionView.reloadData()
    }
  
    /*
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
       
        
        let calcDate = indexPath.row-firstWeekDayOfMonth+2
        if  bookedSlotDate.contains(calcDate) {
            cell?.backgroundColor=UIColor.clear
            let lbl = cell?.subviews[1] as! UILabel
            //lbl.textColor = UIColor.green
            lbl.textColor = Style.ActiveCellGreencolor
         
        } else {
            cell?.backgroundColor=UIColor.clear
            let lbl = cell?.subviews[1] as! UILabel
            lbl.textColor = Style.activeCellLblColor
            if currentMonthIndex == currentMonthEvent && currentYear == currentYearEvent
            {
                if todaysDate == calcDate
                {
                    lbl.textColor = UIColor.red
                }
                else
                {
                    lbl.textColor = Style.activeCellLblColor
                }
            }
        }
    }
   */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        return day == 7 ? 1 : day
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex=monthIndex+1
        currentYear = year
        
        //for leap year, make february month of 29 days
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        //end
        firstWeekDayOfMonth=getFirstWeekDay()
        myCollectionView.reloadData()
        
      //  monthView.btnLeft.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
    }
    
    func setupViews() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive=true
        monthView.delegate=self
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive=true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive=true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive=true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    let monthView: MonthView = {
        let v=MonthView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let weekdaysView: WeekdaysView = {
        let v=WeekdaysView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let myCollectionView=UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.allowsMultipleSelection=false
        return myCollectionView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}


protocol CalenderDelegate {
    func didTapDate(date:String, available:Bool)
    func didTap_PrivousMonth(date:String)
    func didTap_NextMonth(date:String)
}
class dateCVCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.clear
        layer.masksToBounds=true
        setupViews()
    }
    
    func setupViews() {
        addSubview(dateLbl)
        dateLbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        dateLbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        dateLbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        dateLbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
    }
    
    let dateLbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont(name: "GillSansMT" , size: 16.0)
        label.textColor=Colors.darkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//get first day of the month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}


