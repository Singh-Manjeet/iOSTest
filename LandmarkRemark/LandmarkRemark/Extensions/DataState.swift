//
//  DataState.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 31/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import Foundation

// MARK: - Data State

enum DataState<T, E> {
    case loading
    case loaded(T)
    case error(E)
}
