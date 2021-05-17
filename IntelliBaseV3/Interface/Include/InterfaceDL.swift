//
//  InterfaceDL.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2020/12/15.
//

import Foundation
import UIKit
import CoreData

public class InterfaceDL {
    let url: URL
    
    let fileManager = FileManager()
    
    // アプリケーションごとのドキュメントディレクトリ
    let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask)[0]
    
    var dataPath: URL

    // ダウンロード処理中のDownloadクラスを保持
    var activeDownloads: [URL: Download] = [:]
    
    var download: Download
    
    let coreData = CoreDataOperation()

    init(
        id: Int,
        documentType: String = "book"
    ) {
        var dirName = ""
        var fileType = ""
        switch documentType {
            case "thumbnail":
                dirName = "thumbnail"
                fileType = "png"
                break
            case "book":
                dirName = "book"
                fileType = "pdf"
                break
            case "note":
                dirName = "note"
                fileType = "pdf"
                break
            default:
                dirName = "book"
                fileType = "pdf"
        }
        self.url = URL(string: HomePageUrl(lastDirectoryUrl: "uploadedData/" + dirName, fileName: "\(dirName)\(id).\(fileType)").getFullPath())!
        
        dataPath = documentDirectory.appendingPathComponent("\(dirName)_\(id).\(fileType)")
        
        // 本のデータにアップデートがあるかどうか確認
        // product表のアップデートの日付を取得して前回DLした日付と比較
        
        // coreDataからDLした日付を取得
        var downloadedDate:Int = 0
        
        switch documentType {
            case "thumbnail":
                let result: Array<Book> = coreData.select(entity: .book, conditionStr: "id == \(id)")
                if result.count == 1 {
                    downloadedDate = result[0].download_thumbnail_date as! Int
                }
                break
            case "book":
                let result: Array<Book> = coreData.select(entity: .book, conditionStr: "id == \(id)")
                if result.count == 1 {
                    downloadedDate = result[0].download_date as! Int
                }
                break
            case "note":
                let result: Array<Note> = coreData.select(entity: .note, conditionStr: "id == \(id)")
                if result.count == 1 {
                    downloadedDate = result[0].download_date as! Int
                }
                break
            default:
                let result: Array<Book> = coreData.select(entity: .book, conditionStr: "id == \(id)")
                if result.count == 1 {
                    downloadedDate = result[0].download_date as! Int
                }
                break
        }
        
        // apiを叩いて更新日付を取得
        var updatedDate:Int = 0
        
        let interface = Interface(apiFileName: "get_modify_date", parameter: ["id":"\(id)", "type":dirName], sync: true)
        while interface.isDownloading {}
        
        if !interface.error {
            let result = interface.content
            if result.count == 0 {
                // Error
                print("Error : Api returned empty data. [ \(interface.apiPath) ]")
            } else {
                updatedDate = Int(result[0]["datetime"] as! String)!
                print(updatedDate)
            }
        }
        
        self.download = Download(url: url)
        
        // Updated
        if updatedDate > downloadedDate {
            self.startDownload(writeFilePath: self.dataPath)
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyyMMddHHmmss"

            switch documentType {
                case "thumbnail":
                    _ = coreData.update(entity: .book, conditionStr: "id = \(id)", values: ["download_thumbnail_date":dateFormatter.string(from: now)])
                    break
                case "book":
                    _ = coreData.update(entity: .book, conditionStr: "id = \(id)", values: ["download_date":dateFormatter.string(from: now)])
                    break
                case "note":
                    _ = coreData.update(entity: .note, conditionStr: "id = \(id)", values: ["download_date":dateFormatter.string(from: now)])
                    break
                default:
                    _ = coreData.update(entity: .book, conditionStr: "id = \(id)", values: ["download_date":dateFormatter.string(from: now)])
            }
        }
        
        return
    }
    
    // ダウンロード開始処理
    func startDownload(writeFilePath: URL) {
        // 保存するファイル名を指定

        download.task = URLSession.shared.downloadTask(with: url) { location, response, error in

            // ダウンロードデータの一時保存URL
//            print("Debug : Saved as temp to \(location!)")

            if let tempFileUrl = location {
                do {
                    // Write to file
                    let data = try Data(contentsOf: tempFileUrl)
                    try data.write(to: writeFilePath)
//                    print("Debug : Seved to \(writeFilePath.absoluteString)")
                } catch {
                    print("Error : Caught error at download file.")
                }
            }
        }
        download.task!.resume()
        download.isDownloading = true
        print("Debug : Try download to \(self.url)")
        activeDownloads[download.url] = download
        while download.task!.state != .completed {}
        download.isDownloading = false
    }

    // 一時停止処理
    func pauseDownload() {
        guard let download = activeDownloads[url] else { return }
        if download.isDownloading {
            download.task?.cancel(byProducingResumeData: { data in
            // ここで途中までダウンロードしていたデータを保持しておく
            download.resumeData = data
            })
            download.isDownloading = false
        }
    }

    // キャンセル処理
    func cancelDownload() {
        if let download = activeDownloads[url] {
            download.task?.cancel()
            activeDownloads[url] = nil
        }
    }

    // ダウンロード再開処理
    func resumeDownload() {
        guard let download = activeDownloads[url] else { return }

        // pause時に保存していたresumeDataがある場合はそこから続きのダウンロードを行う
        if let resumeData = download.resumeData {
            download.task = URLSession.shared.downloadTask(withResumeData: resumeData)
            download.task!.resume()
            download.isDownloading = true
        } else {
            download.task = URLSession.shared.downloadTask(with: download.url)
            download.task!.resume()
            download.isDownloading = true
        }
    }
    
    // 端末内パスの取得
    func getPath() -> URL {
        return dataPath
    }
}
