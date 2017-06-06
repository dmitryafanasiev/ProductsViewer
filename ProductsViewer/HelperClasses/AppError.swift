//
//  AppError.swift
//  ProductsViewer
//

import Foundation

enum AppError: Error {
    case unknown
    case weakSelf
    case noInternetConnection
    case unexpectedResponseStructure
    case requestCancelled
    case requestTimeout
    
    var errorMessage: String {
        switch self {
        
        case .unexpectedResponseStructure:
            return "Unexpected response structure."
        case .weakSelf:
            return ""
        case .requestCancelled:
            return "Request was cancelled."
        case .requestTimeout:
            return "Request timed out."
        case .noInternetConnection:
            return "No Internet Connection"
        default:
            return "Unknown error occured."
        }
    }
    
}
