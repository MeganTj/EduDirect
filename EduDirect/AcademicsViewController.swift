//
//  AcademicsViewController.swift
//  EduDirect
//
//  Created by Megan Tjandrasuwita on 6/24/17.
//  Copyright © 2017 MMT. All rights reserved.
//

import UIKit

class AcademicsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddCourseControllerDelegate {
    
    struct Grades {
        var grade:Int!
        var classes: [Course]
        
    }
    
    var gradesArray = [Grades(grade: 9, classes: []),
                       Grades(grade: 10, classes: []),
                       Grades(grade: 11, classes: []),
                       Grades(grade: 12, classes: [])]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    func didFinishAddingClass(form: AddCourseViewController, course: Course) {
        let grade = course.grade
        if (grade! < 9)
        {
            gradesArray[0].classes.append(course)
        }
        else
        {
            gradesArray[grade!-9].classes.append(course)
        }
        tableView.reloadData()
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDelegate.persistentContainer.viewContext
        course.saveToCoreData(context: context)
        appDelegate.saveContext()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        // Load data from disk and and fill up our "gradesArray"
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDelegate.persistentContainer.viewContext
        var coursesData: [CourseData] = []
        do {
            coursesData = try context.fetch(CourseData.fetchRequest()) as! [CourseData]
        } catch {
            print("Failed to add course.")
        }
        for courseData in coursesData {
            let grade = Int(courseData.grade)
            let course = Course(courseData.name!, semester: Int(courseData.semester), description: courseData.course_description, grade: Int(courseData.grade), workload: courseData.workload!)
            gradesArray[grade-9].classes.append(course)
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellSection = indexPath.section
        let classes = gradesArray[cellSection].classes
        let cellIndex = indexPath.row
        if cellIndex == classes.count
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddClassCell", for: indexPath) as! AddCourseTableViewCell
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath) as! ClassTableViewCell
        let course = classes[indexPath.row]
        cell.courseName.text = course.name
        cell.courseSemester.text = String(course.semester)
        cell.courseDescription.text = course.description
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellSection = indexPath.section
        let classes = gradesArray[cellSection].classes
        if indexPath.row == classes.count {
            // Present my form view controller.
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "AddCourseNavigationController") as! UINavigationController
            let vc = controller.viewControllers[0] as! AddCourseViewController
            vc.delegate = self
            self.present(controller, animated: true, completion: nil)
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gradesArray[section].classes.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return gradesArray.count
        }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}