//
//  FilpGroup.swift
//  LlamaLink
//
//  Created by Noah Kamara on 29.12.23.
//

import SwiftUI

@ViewBuilder
func FlipGroup<V1: View, V2: View>(if value: Bool,
                                   @ViewBuilder _ content: @escaping () -> TupleView<(V1, V2)>) -> some View {
    let pair = content()
    if value {
        TupleView((pair.value.1, pair.value.0))
    } else {
        TupleView((pair.value.0, pair.value.1))
    }
}
