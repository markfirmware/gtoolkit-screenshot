Class {
	#name : #Screenshot,
	#superclass : #Object,
	#instVars : [
		'form',
		'profile'
	],
	#classInstVars : [
		'lastTaken'
	],
	#category : #Screenshot
}

{ #category : #accessing }
Screenshot class >> isProfileTextChunk: textChunk [
	^ textChunk keyword = self profileTextChunkKeyword
]

{ #category : #accessing }
Screenshot class >> lastTaken [
	^ lastTaken
]

{ #category : #accessing }
Screenshot class >> playgroundContentsFromFileNamed: fileName [
	| textChunks profileChunk |
	textChunks := (PNGReadWriterWithTextChunks formAndChunksFromFileNamed: fileName) at: #textChunks.
	profileChunk := textChunks detect: [ :c | self isProfileTextChunk: c ] ifNone: [ ^ nil ].
	^ (STON fromString: profileChunk text) at: #playgroundContents
]

{ #category : #accessing }
Screenshot class >> profileTextChunkKeyword [
	^'Screenshot>>profile'
]

{ #category : #accessing }
Screenshot class >> readFromFileNamed: fileName [
	| formAndChunks firstText |
	formAndChunks := PNGReadWriterWithTextChunks formAndChunksFromFileNamed: fileName.
	firstText := (formAndChunks at: #textChunks) first text.
	^self new form: (formAndChunks at: #form); profile: (STON fromString: firstText); yourself
]

{ #category : #accessing }
Screenshot class >> take [
	^ self takeForElement: GtWorldElement allInstances first.
]

{ #category : #accessing }
Screenshot class >> takeForElement: anElement [
	^ lastTaken := self new takeForElement: anElement
]

{ #category : #accessing }
Screenshot class >> test [
	| fileName |
	fileName := 'screenshot-1.png'.
	Screenshot
		take writeToFileNamed: fileName.
	^ Screenshot
		readFromFileNamed: fileName
]

{ #category : #accessing }
Screenshot >> form: anObject [
	form := anObject
]

{ #category : #accessing }
Screenshot >> gtItemsFor: aView [
	<gtView>
	^ profile gtItemsFor: aView
]

{ #category : #accessing }
Screenshot >> playgroundContentsForElement: i [
	(i class == GtPlayground) ifTrue: [
		^ i viewModel playBook string trimBoth
	] ifFalse: [
		i children do: [ :child | | childContents |
			childContents := self playgroundContentsForElement: child.
			childContents ifNotNil: [
				^ childContents
			]
		]
	].
	^ nil
]

{ #category : #accessing }
Screenshot >> profile: anObject [
	profile := anObject
]

{ #category : #accessing }
Screenshot >> profileFor: anElement [
	| aProfile playgroundContents |
	aProfile := Dictionary new.
	aProfile at: #textTree put: (self textTreeFor: anElement).
	playgroundContents := self playgroundContentsForElement: anElement.
	playgroundContents ifNotNil: [
		aProfile at: #playgroundContents put: playgroundContents
	].
	^ aProfile
	
]

{ #category : #accessing }
Screenshot >> takeForElement: anElement [
	| root |
	root := anElement.
	[ root isRoot ]
		whileFalse: [
			root := root parent
		].
	form := root exportAsForm.
	profile := self profileFor: root
]

{ #category : #accessing }
Screenshot >> textTreeFor: i [
	| p |
	p := Dictionary new.
	(i respondsTo: #text)
		ifTrue: [ p at: #text put: i text asString ]
		ifFalse: [ | childProfiles |
			childProfiles := OrderedCollection new.
			i children
				do: [ :child | 
					| childProfile |
					childProfile := self textTreeFor: child.
					childProfile isEmpty
						ifFalse:
							[ childProfiles add: childProfile ] ].
			childProfiles isEmpty
				ifFalse:
					[ p at: #children put: childProfiles asArray ] ].
	p isEmpty
		ifFalse:
			[ p at: #className put: i class name ].
	^ p
]

{ #category : #accessing }
Screenshot >> writeToFileNamed: fileName [
	fileName asFileReference deleteIfAbsent: [].
	PNGReadWriterWithTextChunks
		putForm: form
		onFileNamed: fileName
		withTextChunks:
			(OrderedCollection
				with: (PNGtEXtChunk keyword: self class profileTextChunkKeyword text: (STON toJsonString: profile)))
]
