//
//  File.swift
//  editorTest
//
//  Created by Adam Podsiadlo on 22/03/2021.
//  Copyright © 2021 Mohamed Hamed. All rights reserved.
//

import Foundation

extension ViewController {

static var covers = ["{\"layers\":[{\"zIndex\":0,\"size\":{\"width\":190,\"height\":190},\"transform\":{\"d\":1,\"b\":0,\"ty\":0,\"c\":0,\"a\":1,\"tx\":0},\"contentUrl\":\"https://media3.giphy.com/media/l46CcbwdTPqibqblu/giphy.gif?cid=cac7b245i5hrvig2jckuas7q103pf7pm76iuejnhf8vhxk64&rid=giphy.gif\",\"center\":{\"x\":596.6183206309443,\"y\":1440.2173913043478}},{\"zIndex\":1,\"size\":{\"width\":190,\"height\":164},\"transform\":{\"d\":1,\"b\":0,\"ty\":0,\"c\":0,\"a\":1,\"tx\":0},\"contentUrl\":\"https://media3.giphy.com/media/WysJpKYhJkkyBgVYel/giphy.gif?cid=cac7b245qrj1foe900z3hrujvm493dj0jbhte83dfn0s3o44&rid=giphy.gif\",\"center\":{\"x\":1147.3430135975711,\"y\":1460.7488106990206}}],\"backgroundSize\":{\"width\":1500,\"height\":2250},\"thumbnailUrl\":\"https://firebasestorage.googleapis.com/v0/b/shinggg-development.appspot.com/o/images%2Fthumbnail_1614205706036.png?alt=media&token=37870660-10b1-4608-a892-33ed6b66ed43\",\"key\":\"726\",\"backgroundImage\":\"journal_cover_20\",\"originalFrame\":{\"width\":414,\"height\":896}}",
]

static var backgrounds = ["https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_1.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_2.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_3.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_4.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_5.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_6.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_7.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_8.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_9.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_10.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_11.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_12.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_13.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_14.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_15.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_16.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_17.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_18.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_19.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_20.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_21.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_22.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
                  "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fjournal_cover_23.png?alt=media&token=4de0c824-e287-47e1-9200-441bd8dfd866",
]
}
