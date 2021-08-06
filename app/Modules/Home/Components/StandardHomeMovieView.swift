//
//  StandardHomeMovieView.swift
//  NetflixClone
//
//  Created by Mércia Maguerroski on 05/08/21.
//  Copyright © 2021 Mércia Maguerroski. All rights reserved.
//

import SwiftUI
import Kingfisher

struct StandardHomeMovieView: View {
    var movie: Movie

    var body: some View {
        KFImage(movie.thumbnailURL)
    }
}

struct StandardHomeMovieView_Previews: PreviewProvider {
    static var previews: some View {
        StandardHomeMovieView(movie: Constants.exampleMovie1)
    }
}
