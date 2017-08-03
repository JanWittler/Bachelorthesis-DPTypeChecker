//
//  TypeCheckerError.swift
//  DPTypeChecker
//
//  Created by Jan Wittler on 01.08.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import Foundation

public enum TypeCheckerError: Error {
    case nameAlreadyInUse(id: String, as: String)
    case functionNotFound(Id)
    case exposedFunctionDoesNotReturnOPPType(function: Id, returnType: Type)
    case typeNotFound(Ident)
    case variableAlreadyExists(Id)
    case variableNotFound(Id)
    case accessToVariableWithUnknownType(Id)
    case invalidVariableAccess(Id)
    case assignmentFailed(stm: Stm, actual: Type, expected: Type)
    case missingReturn(function: Id)
    case invalidReturnType(actual: Type, expected: Type)
    case splitFailed(stm: Stm, actual: Type)
    case caseApplicationFailed(case: Case, actual: Type)
    case mismatchingTypesForSumType(exp: Exp, actual: Type, expected: Type)
    case tooManyArgumentsToFunction(exp: Exp, actualCount: Int, expectedCount: Int)
    case mismatchingTypeForFunctionArgument(exp: Exp, index: Int, actual: Type, expected: Type)
    case noOperatorOverloadFound(exp: Exp, types: [Type])
    case arithmeticError(message: String)
    case assertionFailed(String)
    case addNoiseFailed(message: String)
    case other(String)
}

extension TypeCheckerError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .nameAlreadyInUse(id: id, as: usageType):
            return "unable to use Id `\(id)` because it is already used for a \(usageType)"
        case let .functionNotFound(id):
            return "function `\(id.value)` not found"
        case let .exposedFunctionDoesNotReturnOPPType(function: id, returnType: type):
            return "exposed functions must always return an OPP type\n" +
                "function: \(id)" +
            "actual: \(type)"
        case let .typeNotFound(id):
            return "type `\(id.value)` not found"
        case let .variableAlreadyExists(id):
            return "variable `\(id.value)` already exists in context"
        case let .variableNotFound(id):
            return "variable `\(id.value)` not found in context"
        case let .accessToVariableWithUnknownType(id):
            return "tried to access an variable with unknown type which is invalid. Unknown types occur when generic elements are created with not enough information, e.g. an empty list without type annotation" + "\n" +
            "variable id: \(id)"
        case let .invalidVariableAccess(id):
            return "access to variable `\(id.value)` led to replication count less than zero"
        case let .assignmentFailed(stm, actual, expected):
            return "assignment failed in statement" + "\n" +
                "statement: " + stm.show() + "\n" +
                "expected: \(expected)\n" +
            "actual: \(actual)"
        case let .missingReturn(function: id):
            return "missing return statement in function `\(id.value)`"
        case let .invalidReturnType(actual: actual, expected: expected):
            return "invalid return type in function\n" +
                "expected: \(expected)\n" +
            "actual: \(actual)\n"
        case let .splitFailed(stm, actual):
            return "assignment failed in statement" + "\n" +
                "statement: " + stm.show() + "\n" +
                "expected: pair type\n" +
            "actual: \(actual)"
        case let .caseApplicationFailed(case: `case`, actual: actual):
            return "failed to apply " + `case`.show() + " on expression of type \(actual)"
        case let .mismatchingTypesForSumType(exp: exp, actual: actual, expected: expected):
            return "mismatching types when trying to construct sum type" + "\n" +
                "expression: " + exp.show() + "\n" +
                "expected: \(expected)\n" +
            "actual: \(actual)"
        case let .tooManyArgumentsToFunction(exp: exp, actualCount: actual, expectedCount: expected):
            return "too many arguments to function" + "\n" +
                "expression: " + exp.show() + "\n" +
                "expected: \(expected)\n" +
            "actual: \(actual)"
        case let .mismatchingTypeForFunctionArgument(exp: exp, index: index, actual: actual, expected: expected):
            return "argument at index \(index) has mismatching type in function application" + "\n" +
                "expression: " + exp.show() + "\n" +
                "expected: \(expected)\n" +
            "actual: \(actual)"
        case let .noOperatorOverloadFound(exp: exp, types: types):
            return "no operator overload found that matches found types" + "\n" +
                "expression: " + exp.show() + "\n" +
                "types: " + types.map { $0.description }.joined(separator: ", ")
        case let .arithmeticError(message: message):
            return message
        case let .assertionFailed(message):
            return message
        case let.addNoiseFailed(message: message):
            return message
        case let .other(message):
            return message
        }
    }
}
