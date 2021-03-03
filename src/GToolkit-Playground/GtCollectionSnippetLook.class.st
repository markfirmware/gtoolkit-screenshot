"
I am a look for a collection snippet. I provide a way to select the type of the snippet to create, for examples pharo code or url.

I am designed to work together with ${class:GtSnippetWidgetModel}$ and can be applied on the ${class:GtSnippetElement}$

Example:
[[[
GtSnippetElement new
	look: GtCollectionSnippetLook + BrLayoutLook linearVertical vFitContent hMatchParent
]]]

"
Class {
	#name : #GtCollectionSnippetLook,
	#superclass : #BrLook,
	#instVars : [
		'snippet',
		'toolbar'
	],
	#category : #'GToolkit-Playground-Snippet - Looks'
}

{ #category : #adding }
GtCollectionSnippetLook >> addSnippet: aClass [ 
	self snippet requestSnippetReplacement: aClass
]

{ #category : #accessing }
GtCollectionSnippetLook >> availableSnippetClasses [
	^ self snippet availableSnippetClasses
]

{ #category : #initialization }
GtCollectionSnippetLook >> initialize [
	super initialize.

	toolbar := BrToolbar new
		hMatchParent;
		look: BrGlamorousToolbarLook;
		background: (Color fromHexString: #f0f0f0);
		border: (BlBorder paint: Color veryLightGray width: 1);
		padding: (BlInsets all: 10).

	self addChangeAddChildAs: #(content toobar) with: [ toolbar ].
	self
		addChange:
			(BrLookChange new
				up: [ :e | 
					self availableSnippetClasses
						do: [ :eachSnippetClass | 
							| anItem |
							anItem := BrButton new.
							anItem margin: (BlInsets all: 2).
							anItem
								look: BrGlamorousButtonWithLabelLook.
							anItem label: eachSnippetClass new typeName.
							anItem action: [ self addSnippet: eachSnippetClass ].
							toolbar addItem: anItem ] ];
				down: [ :e |  ];
				yourself).
]

{ #category : #initialization }
GtCollectionSnippetLook >> initializeListeners [
	super initializeListeners.
	
	self when: GtSnippetChanged do: [ :anEvent | self snippet: anEvent snippet ].
]

{ #category : #initialization }
GtCollectionSnippetLook >> initializeRequests [
	super initializeRequests.
	
	self request: GtSnippetRequest new.
]

{ #category : #accessing }
GtCollectionSnippetLook >> snippet [
	snippet ifNil: [ self snippet: GtCollectionSnippet new ].
	^ snippet
]

{ #category : #accessing }
GtCollectionSnippetLook >> snippet: aGtSnippet [
	snippet := aGtSnippet.
]
