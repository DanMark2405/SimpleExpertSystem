//
//  main.swift
//  laba1
//
//  Created by Daniil Markish on 24.11.22.
//

import Foundation


struct MatrixItem: Hashable {
    var object: String
    var rule: String
    var value: Bool
}

struct Matrix {
    var values = Set<MatrixItem>()
    var countObjects = 0
    var countRules = 0
    var rules = Set<String>()
    var objects = Set<String>()
    
    mutating func enterData() {
        print("Введите количество характеристик:")
        guard let line = readLine(), let count = Int(line) else {
            return
        }
        countRules = count
        for i in 1...count {
            print("Введите характеристику № \(i)")
            if let name = readLine() {
                rules.insert(name)
            }
        }
        
        print("Введите количество объектов:")
        guard let line = readLine(), let count = Int(line) else {
            return
        }
        countObjects = count
        for i in 1...count {
            print("Введите объект № \(i)")
            let name = readLine()
            if let name = name {
                objects.insert(name)
            }
        }
        
        for name in objects {
            for rule in rules {
                print("ИМЕЕТ ЛИ \(name) \(rule)? (y/n)")
                if let line = readLine(), line == "y" {
                    values.insert(MatrixItem(object: name, rule: rule, value: true))
                } else {
                    values.insert(MatrixItem(object: name, rule: rule, value: false))
                }
            }
        }
    }
    
    mutating func deleteNullableRows() {
        for rule in rules {
            if values.filter({ $0.rule == rule && $0.value == true}).isEmpty {
                deleteRow(with: rule)
            }
        }
    }
    
    mutating func deleteRow(with rule: String) {
        self.values = values.filter{ $0.rule != rule }
        rules.remove(rule)
        countRules = rules.count
    }
    
    mutating func deleteColum(with object: String) {
        self.values = values.filter{ $0.object != object }
        objects.remove(object)
        countObjects = objects.count
    }
    
    func ruleWithminSum() -> String {
        var minRule: String = ""
        var minCount: Int = countObjects
        
        for rule in rules {
            let count = values.filter({ $0.rule == rule && $0.value == true}).count
            if count < minCount {
                minCount = count
                minRule = rule
            }
        }
        
        return minRule
    }
    
    mutating func cleanWithAnswer(_ answer: Bool, rule: String) {
        for name in objects {
            guard let hasRule = values.first(where: { $0.object == name &&  $0.rule == rule})?.value else {
                continue
            }
            if answer, !hasRule {
                deleteColum(with: name)
            } else if !answer, hasRule {
                deleteColum(with: name)
            }
        }
        if !answer {
            deleteRow(with: rule)
        }
    }
}

class ExpertSystem {
    
    var matrix: Matrix
    var workMatrix: Matrix
    
    init(matrix: Matrix) {
        self.matrix = matrix
        self.workMatrix = matrix
    }
    
    func search() {
        workMatrix = matrix
        let result = findObject()
        print("\n\n Искомый объект - \(result)")
    }
    
    func findObject() -> String {
        var askRules = workMatrix.rules
        while workMatrix.objects.count > 1, !askRules.isEmpty {
            workMatrix.deleteNullableRows()
            let minRule = workMatrix.ruleWithminSum()
            print("Имеет ли объект \(minRule)? (y/n)»")
            if let answer = readLine(), answer == "y" {
                workMatrix.cleanWithAnswer(true, rule: minRule)
            } else {
                workMatrix.cleanWithAnswer(false, rule: minRule)
            }
            askRules.remove(minRule)
        }
        
        if workMatrix.objects.isEmpty {
            return "НЕИЗВЕСТНЫЙ ОБЪЕКТ"
        } else {
            return workMatrix.objects.joined(separator: ", ")
        }
        
    }
}



var m = Matrix()
m.enterData()
var system = ExpertSystem(matrix: m)
system.search()


func createTestMatrix() -> Matrix {
    Matrix(values: [
        MatrixItem(object: "Птица", rule: "Крылья", value: true),
        MatrixItem(object: "Птица", rule: "Клюв", value: true),
        MatrixItem(object: "Птица", rule: "Двигатель", value: false),
        MatrixItem(object: "Птица", rule: "Лапки", value: true),
        MatrixItem(object: "Птица", rule: "Шасси", value: false),
        MatrixItem(object: "Самолет", rule: "Крылья", value: true),
        MatrixItem(object: "Самолет", rule: "Клюв", value: false),
        MatrixItem(object: "Самолет", rule: "Двигатель", value: true),
        MatrixItem(object: "Самолет", rule: "Лапки", value: false),
        MatrixItem(object: "Самолет", rule: "Шасси", value: true),
        MatrixItem(object: "Планер", rule: "Крылья", value: true),
        MatrixItem(object: "Планер", rule: "Клюв", value: false),
        MatrixItem(object: "Планер", rule: "Двигатель", value: false),
        MatrixItem(object: "Планер", rule: "Лапки", value: false),
        MatrixItem(object: "Планер", rule: "Шасси", value: false),
        MatrixItem(object: "Муха", rule: "Крылья", value: true),
        MatrixItem(object: "Муха", rule: "Клюв", value: false),
        MatrixItem(object: "Муха", rule: "Двигатель", value: false),
        MatrixItem(object: "Муха", rule: "Лапки", value: true),
        MatrixItem(object: "Муха", rule: "Шасси", value: false),
    ],
           countObjects: 4, countRules: 5,
           rules: ["Крылья", "Клюв", "Двигатель", "Лапки", "Шасси"],
           objects: ["Птица", "Самолет", "Планер", "Муха"]
    )
}

