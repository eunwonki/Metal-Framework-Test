//
//  Gesture.swift
//  MetalRenderer
//
//  Created by wonki on 2022/01/16.
//

import CoreGraphics
import Foundation

class Gesture {
    public static var dragStartPos = CGPoint()
    public static var currentDragDiff = CGSize()
    public static var isDragging = false
    
    private static var prevMagnitude: CGFloat = 0
    public static var zoomDelta: Float = 0
    public static var isZooming = false
    
    public static func OnDragging(start: CGPoint, translation: CGSize) {
        isDragging = true
        currentDragDiff = translation
        NSLog("On Dragging")
    }
    
    public static func OnDragEnd() {
        isDragging = false
        NSLog("On Drag End")
    }
    
    public static func OnZooming(magnitude: CGFloat) {
        if isZooming == false {
            prevMagnitude = magnitude
            zoomDelta = 0.01
            isZooming = true
            return
        }
        
        zoomDelta = magnitude > prevMagnitude ? 0.01 : -0.01
        prevMagnitude = magnitude
    }
    
    public static func OnZoomEnd() {
        isZooming = false
    }
}
