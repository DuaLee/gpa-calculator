//
//  ViewController.swift
//  gpa-calculator
//
//  Created by Cony Lee on 2/8/22.
//

import UIKit

class ViewController: UIViewController {
    class Course {
        var courseName: String
        var courseCredit: Double
        var courseGrade: Int
        
        init(courseName: String, courseCredit: Double, courseGrade: Int) {
            self.courseName = courseName
            self.courseCredit = courseCredit
            self.courseGrade = courseGrade
        }
        
        func getGradePoint() -> Double {
            return courseCredit * Double(courseGrade)
        }
    }
    
    @IBOutlet weak var courseName: UITextField!
    var getCourseName: String? {
        return courseName.text
    }

    @IBOutlet weak var point1: UITextField!
    @IBOutlet weak var point2: UITextField!
    @IBOutlet weak var point3: UITextField!
    
    @IBOutlet weak var max1: UITextField!
    @IBOutlet weak var max2: UITextField!
    @IBOutlet weak var max3: UITextField!
    
    @IBOutlet weak var weight1: UITextField!
    @IBOutlet weak var weight2: UITextField!
    @IBOutlet weak var weight3: UITextField!
    
    @IBOutlet weak var credit: UITextField!
    
    @IBOutlet weak var deleteIndex: UITextField!
    
    @IBOutlet weak var gpa: UILabel!
    
    func drawGpa() {
        var gradePointSum: Double = 0.0
        var creditSum: Double = 0.0
        
        for index in 0..<courseListArray.count {
            gradePointSum += courseListArray[index].getGradePoint()
            creditSum += courseListArray[index].courseCredit
        }
        
        print(gradePointSum);
        print(creditSum);
        
        let gradePointAverage: Double = gradePointSum / creditSum
        
        print(gradePointAverage)
        
        switch gradePointAverage {
        case 3...:
            gpa.textColor = UIColor.green
            
        case 2...:
            gpa.textColor = UIColor.orange
            
        default:
            gpa.textColor = UIColor.red
        }
        
        gpa.text = "GPA: \(String(format: "%.2f", gradePointAverage))"
    }
    
    @IBOutlet weak var courseList1: UILabel!
    @IBOutlet weak var courseList2: UILabel!
    @IBOutlet weak var courseList3: UILabel!
    @IBOutlet weak var courseList4: UILabel!
    
    @IBOutlet weak var courseIcon1: UIImageView!
    @IBOutlet weak var courseIcon2: UIImageView!
    @IBOutlet weak var courseIcon3: UIImageView!
    @IBOutlet weak var courseIcon4: UIImageView!
    
    func drawCourseList() {
        for index in 0...3 {
            var text: String = ""
            
            if index < courseListArray.count {
                text = "\(index + 1): \(courseListArray[index].courseName) | \(courseListArray[index].courseCredit)"
            }
                
            switch index {
            case 0:
                courseList1.text = text
                
            case 1:
                courseList2.text = text
                    
            case 2:
                courseList3.text = text
                
            case 3:
                courseList4.text = text
                        
            default:
                break
            }
        }
    }
    
    func drawCourseIcon() {
        courseIcon1.image = nil
        courseIcon2.image = nil
        courseIcon3.image = nil
        courseIcon4.image = nil
        
        for index in 0..<courseListArray.count {
            switch index {
            case 0:
                courseIcon1.image = UIImage(named: "grade\(courseListArray[index].courseGrade)")
                
            case 1:
                courseIcon2.image = UIImage(named: "grade\(courseListArray[index].courseGrade)")
                
            case 2:
                courseIcon3.image = UIImage(named: "grade\(courseListArray[index].courseGrade)")
                
            case 3:
                courseIcon4.image = UIImage(named: "grade\(courseListArray[index].courseGrade)")
                
            default:
                break
            }
        }
    }
    
    var courseListArray = [Course]()
    
    func addCourseListArray(course: String, credit: Double, scoreSum: Double) {
        var courseGrade: Int = 0
        
        switch scoreSum {
        case 0.90...:
            courseGrade = 4
        
        case 0.80...:
            courseGrade = 3
        
        case 0.70...:
            courseGrade = 2
        
        case 0.60...:
            courseGrade = 1
        
        default:
            courseGrade = 0
        }
        
        courseListArray.append(Course(courseName: course, courseCredit: credit, courseGrade: courseGrade))
    }
    
    func removeCourseListArray(index: Int) -> Bool {
        if 0 <= index && index < courseListArray.count {
            courseListArray.remove(at: index)
            
            return true
        }
        
        return false
    }
    
    func readParams() -> Bool {
        if Int(weight1.text!)! + Int(weight2.text!)! + Int(weight3.text!)! == 100 {
            var scoreSum: Double = 0.0;
            
            scoreSum += ((Double(point1.text!) ?? 0.0) / (Double(max1.text!) ?? 100.0) * (Double(weight1.text!) ?? 0.0) * 0.01)
            scoreSum += ((Double(point2.text!) ?? 0.0) / (Double(max2.text!) ?? 100.0) * (Double(weight2.text!) ?? 0.0) * 0.01)
            scoreSum += ((Double(point3.text!) ?? 0.0) / (Double(max3.text!) ?? 100.0) * (Double(weight3.text!) ?? 0.0) * 0.01)
            
            addCourseListArray(course: getCourseName!, credit: Double(credit.text!) ?? 0.0, scoreSum: scoreSum)
            
            return true
        } else {
            showAlert(message: "Weight percentages must add up to 100.")
        }
        
        return false
    }
    
    func showAlert(message: String = "") {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
    func showWarning(message: String = "") {
        let resetAction = UIAlertAction(title: "Reset",
                  style: .destructive) { UIAlertAction in
            self.resetAction()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                  style: .cancel)
             
        let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: .actionSheet)
        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)
             
        self.present(alertController, animated: true, completion: nil)
    }
    
    func resetAction() {
        courseListArray.removeAll()
        
        drawCourseList()
        drawCourseIcon()
        gpa.isHidden = true
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            if courseListArray.count < 4 {
                if readParams() {
                    print("Course Added")
                }
            } else {
                showAlert(message: "Maximum of 4 classes allowed.")
            }
            
        case 2:
            if removeCourseListArray(index: Int(deleteIndex.text!)! - 1) {
                print("Course Deleted")
            }
            
        case 3:
            showWarning(message: "Remove all courses?")
            
        default:
            print("")
        }
        
        drawCourseList()
        drawCourseIcon()
        
        if courseListArray.count > 0 {
            gpa.isHidden = false
            drawGpa()
        } else {
            gpa.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetAction()
    }
}
