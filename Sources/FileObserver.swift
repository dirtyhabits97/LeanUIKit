//
//  FileObserver.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 9/21/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

/// The entity that constantly observes a file.
class FileObserver {

    // MARK: - Properties

    /// The dispatch source that observes file changes.
    private var observer: DispatchSourceFileSystemObject?
    /// The closure that gets called when the observed file is modified.
    var onChange: (() -> Void)?
    /// The path to the file to observe.
    let path: String

    // MARK: - Lifecycle

    /**
     - Parameters:
        - fileToObserve: the path to the file to observe.
     */
    init(fileToObserve: String) {
        path = fileToObserve
    }

    /**
     Starts observing the file.
     */
    func observeFile() {
        // open the file
        let descriptor = open(path, O_EVTONLY)
        // check if the file was opened
        if descriptor == -1 { return }
        // configure the observer
        observer = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: descriptor,
            eventMask: .delete,
            queue: .main
        )
        // set the on change event
        observer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.onChange?()
            self.observeFile()
        }
        // start observing
        observer?.resume()
    }

}
