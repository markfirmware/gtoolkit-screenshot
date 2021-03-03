Class {
	#name : #GtCollectionSnippetStencilBuilder,
	#superclass : #GtSnippetStencilBuilder,
	#category : #'GToolkit-Playground-Snippet - Stencils'
}

{ #category : #'api - instantiation' }
GtCollectionSnippetStencilBuilder >> buildDefault [
	<return: #BlElement>

	^ super buildDefault
		layout: BlFrameLayout new;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		look: GtSnippetContainerLook + GtCollectionSnippetLook
]
