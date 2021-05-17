//
//  DocumentThumbnailView.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2020/12/15.
//

import SwiftUI
import UIKit

struct DocumentThumbnailView: View {
    var noteManager: NoteManager = NoteManager.shared
    var id: Int
    @State var navSelection: Int? = nil
    @State var showingPopover: Bool = false
    @State var showingSheet: Bool = false
    @State var navigateAsNewNote: Bool = false
    @State var navigateWithNoteId: Int? = nil
    @State var document: DocumentStruct
    
    var thumbnailDataPath: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var uiImage: UIImage? = nil
    
    @State private var popoverWidth = CGFloat(500)
    
    init(id: Int, isNote: Bool = false) {
        self.id = id
        self._document = State(initialValue: DocumentStruct(id: id, isNote: isNote))
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.thumbnailDataPath = documentDirectory.appendingPathComponent("thumbnail_\(document.book.id).png")
        
        do {
            let thumbnailData = try Data(contentsOf: thumbnailDataPath)
            self.uiImage = UIImage(data: thumbnailData)
        } catch let error {
            print(error)
        }
    }
    
    var body: some View {
        NavigationLink(destination: DocumentRootView(documentId: self.document.id, isNote: self.document.isNote), tag: 0, selection: $navSelection) {
            Group {
                // Thumbnail
                if let image = uiImage {
                    VStack(alignment: .leading) {
                        GeometryReader { geometry in
                            Image(uiImage: image)
                                .resizable()
                                .renderingMode(.original)
                                //.aspectRatio(contentMode: .fit)
                                .frame(width: 246, height: 335, alignment: .leading)
                                .padding(.bottom, 30)
                                .rotation3DEffect(Angle(degrees:
                                                            Double(geometry.frame(in: .global).minX - 30) / -40), axis: (x: 0, y: 10.0, z: 0))
                            if document.isNote {
                                HStack{
                                    EditedMark(icon: "pencil.and.outline")
                                        .rotation3DEffect(Angle(degrees:
                                                                    Double(geometry.frame(in: .global).minX - 30) / -40), axis: (x: 0, y: 10.0, z: 0))
                                    if document.note!.share {
                                        if document.note!.account_id == document.note!.share_account_id {
                                            EditedMark(icon: "link")
                                                .rotation3DEffect(Angle(degrees:
                                                                            Double(geometry.frame(in: .global).minX - 30) / -40), axis: (x: 0, y: 10.0, z: 0))
                                        } else {
                                            EditedMark(icon: "link.icloud")
                                                .rotation3DEffect(Angle(degrees:
                                                                            Double(geometry.frame(in: .global).minX - 30) / -40), axis: (x: 0, y: 10.0, z: 0))}
                                    }
                                    
                                }
                                

                                
                            }
                            
                            
                        }
                        .frame(width: 246, height: 360)
                    }
                    .frame(width: 250, height: 360)
                    .shadow(color: Color("backgroundShadow3"), radius: 20, x: 0, y: 20)
                } else {
                    Text("\(document.book.id)")
                        .frame(width: 210, height: 297, alignment: .center)
//                        Image("thumbnailPlaceholder")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 210, height: 297, alignment: .center)
                }
            }
            .onTapGesture(count: 2) {
                _ = InterfaceDL(id: document.book.id, documentType: "book")
                self.navSelection = 0
            }
            .onLongPressGesture {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    // iPhone
                    self.showingSheet.toggle()
                }
                else if UIDevice.current.userInterfaceIdiom == .pad {
                    // iPad
                    self.showingPopover.toggle()
                    // temp for debug
//                    self.showingSheet.toggle()
                }
            }
            .onTapGesture(count: 1) {
                let _ = InterfaceDL(id: document.book.id, documentType: "book")
                self.navSelection = 0
            }
            // 長押しの判定とタップの判定を同時に行う
            // Reference
            // https://stackoverflow.com/a/60138475
        }
        .popover(isPresented: $showingPopover) {
            DocumentPopup(showing: $showingPopover,bindedDocument: self.$document, bindedNavigateFlag: $navigateAsNewNote, navigateWithNoteId: $navigateWithNoteId)
        }
        .sheet(isPresented: $showingSheet) {
            DocumentPopup(showing: $showingSheet,bindedDocument: self.$document, bindedNavigateFlag: $navigateAsNewNote, navigateWithNoteId: $navigateWithNoteId)
        }
        if !document.isNote {
            // 新規ノートで開く用のNavigationLink
            NavigationLink(destination: DocumentRootView(documentId: document.id, isNote: document.isNote, openAsNewNote: true), isActive: $navigateAsNewNote){}
            ForEach(document.book.notes.indices) { index in
                // 指定したIDのノートで開く用のNavigationLink
                NavigationLink(destination: DocumentRootView(documentId: document.book.notes[index].id, isNote: true), tag: document.book.notes[index].id, selection: $navigateWithNoteId){}
            }
        }
    }
}

struct DocumentThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentThumbnailView(id: 1)
    }
}
