//
//  main.swift
//  BNFC_cToSwift
//
//  Created by Jan Wittler on 04.06.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import Foundation
import CGrammar

let parse_tree: CGrammar.Program?
if CommandLine.argc > 1, let file = fopen(CommandLine.arguments[1], "r") {
    parse_tree = pProgram(file)
}
else {
    parse_tree = pProgram(stdin)
}

guard let parse_tree = parse_tree else {
    exit(1)
}

let swiftTree = CGrammarToSwiftBridge().visitProgram(parse_tree)
print("Parse Successful!")
print("\n[Abstract Syntax]")
print(swiftTree.show())
print("\n[Linearized Tree]")
print(Swift.String(cString: printProgram(parse_tree)))
