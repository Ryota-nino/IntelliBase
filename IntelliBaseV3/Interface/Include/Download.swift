//
//  Download.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2020/12/15.
//

import Foundation

final class Download: NSObject {

  var url: URL

  // 現在ダウンロード中か
  var isDownloading = false

  // 進行状況
  var progress: Float = 0

  var task: URLSessionDownloadTask?

  // ダウンロードが中断された時のダウンロード済のデータ
  var resumeData: Data?

  init(url: URL) {
    self.url = url
  }
}
