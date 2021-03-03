Extension { #name : #AbstractFileReference }

{ #category : #'*Screenshot' }
AbstractFileReference >> gtPlaygroundFor: aView [
	| playgroundText |
	<gtView>
	(self isFile and: [ 
		self extension asLowercase = 'png' ]) ifFalse: [ ^ aView empty ].
	(playgroundText := Screenshot playgroundContentsFromFileNamed: self fullName) ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Playground';
		priority: 9;
		stencil: [
			BrEditorElement new
				margin: (BlInsets all: 10);
				constraintsDo: [ :c | 
					c vertical matchParent. 
					c horizontal matchParent ];
				editor: (BrTextEditor new
					text: (playgroundText asRopedText
						glamorousRegularFontAndSize) ) ]
]
