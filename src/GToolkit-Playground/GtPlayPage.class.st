Class {
	#name : #GtPlayPage,
	#superclass : #Object,
	#traits : 'TGtAssert + TGtAnnouncer',
	#classTraits : 'TGtAssert classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'snippets',
		'bindings',
		'announcer',
		'title'
	],
	#category : #'GToolkit-Playground-Model'
}

{ #category : #'instance creation' }
GtPlayPage class >> forObject: anObject [
	| aPlayPage |
	aPlayPage := self newDefault.
	aPlayPage receiver: anObject.
	aPlayPage xDocLoadSavedContent.
	^ aPlayPage
]

{ #category : #'instance creation' }
GtPlayPage class >> newDefault [
	"Open a new play book with one page and one default snippet"
	<return: #GtPlayPage>
	| aPage |
	aPage := self new.
	aPage addSnippet: aPage newDefaultSnippet.
	^ aPage
]

{ #category : #visitor }
GtPlayPage >> accept: aVisitor [
	^ aVisitor visitGtPlayPage: self
]

{ #category : #'api - modification' }
GtPlayPage >> addSnippet: aGtSnippet [ 
	"Add a playground snippet"
	self addSnippet: aGtSnippet at: self snippets size + 1.
]

{ #category : #'api - modification' }
GtPlayPage >> addSnippet: aGtSnippet at: anIndex [
	"Add a playground snippet"

	self
		assert: [ aGtSnippet notNil ]
		description: [ 'Snippet must be non-nil' ].
	self
		assert: [ anIndex > 0 and: [ anIndex <= (self snippets size + 1) ] ]
		description: [ 'Insert index ' , anIndex asString , ' is out of bounds' ].
	self snippets add: aGtSnippet beforeIndex: anIndex.
	self attachToSnippet: aGtSnippet.
	self notifySnippetAdded: aGtSnippet at: anIndex.
	aGtSnippet requestSnippetFocus.
]

{ #category : #announcer }
GtPlayPage >> announcer [
	<return: #Announcer>
	^ announcer
]

{ #category : #converting }
GtPlayPage >> asElement [
	<return: #BlElement>
	
	^ GtPageElement new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ];
		page: self
]

{ #category : #'announcement registration' }
GtPlayPage >> attachToSnippet: aGtSnippet [
	aGtSnippet variableBindings: self bindings.
	aGtSnippet
		when: GtSnippetBelowRequestedAnnouncement
			send: #snippetBelowRequestedAnnouncement:
			to: self
			for: self;
		when: GtSnippetRemovalRequestedAnnouncement
			send: #snippetRemovalRequestedAnnouncement:
			to: self
			for: self;
		when: GtSnippetReplacementRequestedAnnouncement
			send: #snippetReplacementRequestedAnnouncement:
			to: self
			for: self;
		when: GtSnippetMergeRequestedAnnouncement
			send: #snippetMergeRequestedAnnouncement:
			to: self
			for: self;
		when: GtPageSnippetChangedAnnouncement
			send: #snippetChangedAnnouncement:
			to: self
			for: self;
		when: GtSnippetEvaluatedAnnouncement
			send: #snippetEvaluatedAnnouncement:
			to: self
			for: self;
		when: GtSnippetRenameRequestedAnnoucement
			send: #snippetRenameRequestedAnnouncement:
			to: self
			for: self;
		when: GtSnippetExternalCursorAnnouncement
			send: #snippetExternalCursorAnnouncement:
			to: self
			for: self
]

{ #category : #accessing }
GtPlayPage >> bindings [
	<return: #GtBindingsTrait>
	^ bindings
]

{ #category : #accessing }
GtPlayPage >> bindings: aGtBindingsTrait [
	self 
		assert: [ aGtBindingsTrait notNil ] 
		description: [ 'Bindings must be non-nil' ].
	bindings := aGtBindingsTrait
]

{ #category : #accessing }
GtPlayPage >> bindingsDo: aBlock [
	aBlock cull: self bindings cull: self
]

{ #category : #'announcement registration' }
GtPlayPage >> detachFromSnippet: aGtSnippet [
	aGtSnippet variableBindings: GtNoBindings uniqueInstance.
	aGtSnippet unsubscribe: self.
]

{ #category : #'gt-extension' }
GtPlayPage >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live' translated;
		stencil: [self asElement margin: (BlInsets all: 10)];
		priority: 10
]

{ #category : #initialization }
GtPlayPage >> initialize [
	super initialize.
	snippets := OrderedCollection new.
	bindings := GtSnippetBindings new.
	announcer := Announcer new.
	title := 'Page'.
]

{ #category : #'instance creation' }
GtPlayPage >> newCollectionSnippet [
	^ GtCollectionSnippet new.
]

{ #category : #'instance creation' }
GtPlayPage >> newDefaultSnippet [
	^ GtCoderSnippet new.
]

{ #category : #notifying }
GtPlayPage >> notifySnippet: anOldGtSnippet replactedBy: aNewGtSnippet at: anIndex [
	self announce: (GtPageSnippetReplacedAnnoucement new 
		page: self; 
		snippet: aNewGtSnippet; 
		previousSnippet: anOldGtSnippet;
		index: anIndex)
]

{ #category : #notifying }
GtPlayPage >> notifySnippetAdded: aGtSnippet at: anIndex [
	self announce: (GtPageSnippetAddedAnnoucement new page: self; snippet: aGtSnippet; index: anIndex)
]

{ #category : #notifying }
GtPlayPage >> notifySnippetChanged: aGtPageSnippetChangedAnnouncement [
	| anIndex |
	anIndex := self snippets
		indexOf: aGtPageSnippetChangedAnnouncement snippet.
	aGtPageSnippetChangedAnnouncement page: self.
	aGtPageSnippetChangedAnnouncement index: anIndex.
	self announce: aGtPageSnippetChangedAnnouncement
]

{ #category : #notifying }
GtPlayPage >> notifySnippetRemoved: aGtSnippet at: anIndex [
	self announce: (GtPageSnippetRemovedAnnoucement new page: self; snippet: aGtSnippet; index: anIndex)
]

{ #category : #accessing }
GtPlayPage >> numberOfSnippets [
	^ self snippets size
]

{ #category : #actions }
GtPlayPage >> playAll [
	| aLastResult |
	aLastResult := nil.
	self snippets do: [ :eachSnippet | aLastResult := eachSnippet playAll ].
	^ aLastResult
]

{ #category : #accessing }
GtPlayPage >> receiver [
	^ self bindings receiver
]

{ #category : #accessing }
GtPlayPage >> receiver: anObject [
	self bindings receiver: anObject
]

{ #category : #'api - modification' }
GtPlayPage >> removeSnippet: aGtSnippet [
	"Remove a playground snippet"

	| anIndex |
	self
		assert: [ aGtSnippet notNil ]
		description: [ 'Snippet must be non-nil' ].
	anIndex := self snippets indexOf: aGtSnippet.
	self snippets removeAt: anIndex.
	self detachFromSnippet: aGtSnippet.
	self notifySnippetRemoved: aGtSnippet at: anIndex.
	"Ensure that PlayPage has always one snippet."
	self snippets isEmpty ifTrue: [ self addSnippet: self newCollectionSnippet ].

]

{ #category : #'api - modification' }
GtPlayPage >> replaceSnippet: anExistingGtSnippet by: aNewGtSnippet [
	"Replace a snippet by a new one"
	| anIndex |
	self 
		assert: [ anExistingGtSnippet notNil ]
		description: [ 'Existing snippet must be non-nil' ].
	self 
		assert: [ aNewGtSnippet notNil ]
		description: [ 'New snippet must be non-nil' ].
	anIndex := self snippets indexOf: anExistingGtSnippet.
	self snippets at: anIndex put: aNewGtSnippet.
	self detachFromSnippet: anExistingGtSnippet.
	self attachToSnippet: aNewGtSnippet.
	self notifySnippet: anExistingGtSnippet replactedBy: aNewGtSnippet at: anIndex.
]

{ #category : #private }
GtPlayPage >> restyleSnippets [
	snippets do: [ :each | each requestStyleText ]
]

{ #category : #accessing }
GtPlayPage >> snippetAt: anInteger [ 
	<return: #GtSnippet>
	^ self snippets at: anInteger
]

{ #category : #'announcement handling' }
GtPlayPage >> snippetBelowRequestedAnnouncement: aGtSnippetBelowRequestedAnnouncement [ 
	| anSnippet anIndex aNewSnippet |
	anSnippet := aGtSnippetBelowRequestedAnnouncement snippet.
	self
		assert: [ anSnippet notNil ] 
		description: [ 'Source snippet for new snippet request must be non-nil' ].
	anIndex := self snippets indexOf: anSnippet.
	aNewSnippet := aGtSnippetBelowRequestedAnnouncement secondSnippet.
	aNewSnippet ifNil: [ aNewSnippet := self newCollectionSnippet ].
	self addSnippet: aNewSnippet at: anIndex + 1.
]

{ #category : #'announcement handling' }
GtPlayPage >> snippetChangedAnnouncement: aGtPageSnippetChangedAnnouncement [
	self notifySnippetChanged: aGtPageSnippetChangedAnnouncement.
	self updateImplicitVariables
]

{ #category : #'announcement handling' }
GtPlayPage >> snippetEvaluatedAnnouncement: aGtSnippetEvaluatedAnnouncement [ 
	| anIndex anAnnouncement |
	self restyleSnippets.
	anIndex := self snippets indexOf: aGtSnippetEvaluatedAnnouncement snippet.
	anAnnouncement := GtPageSnippetEvaluatedAnnouncement new.
	anAnnouncement 
		page: self;
		index: anIndex;
		snippet: aGtSnippetEvaluatedAnnouncement snippet;
		result: aGtSnippetEvaluatedAnnouncement result;
		isException: aGtSnippetEvaluatedAnnouncement isException;
		isSpawnResultRequested: aGtSnippetEvaluatedAnnouncement isSpawnResultRequested.	
	self announce: anAnnouncement.
]

{ #category : #'announcement handling' }
GtPlayPage >> snippetExternalCursorAnnouncement: aGtSnippetExternalCursorAnnouncement [
	| index direction snippet |
	index := self snippets
		identityIndexOf: aGtSnippetExternalCursorAnnouncement snippet.
	index = 0
		ifTrue: [ ^ self ].
	direction := aGtSnippetExternalCursorAnnouncement direction.
	(#(left up) includes: direction)
		ifTrue: [ index = 1
				ifTrue: [ ^ self ].
			snippet := self snippets at: index - 1.
			snippet focusAndPlaceCursorAtEnd ].
	(#(right down) includes: direction)
		ifTrue: [ index = self snippets size
				ifTrue: [ ^ self ].
			snippet := self snippets at: index + 1.
			snippet focusAndPlaceCursorAtBeginning ]
]

{ #category : #'announcement handling' }
GtPlayPage >> snippetMergeRequestedAnnouncement: aGtSnippetMergeRequestedAnnouncement [ 
	| anSnippet anIndex anAboveSnippet |
	anSnippet := aGtSnippetMergeRequestedAnnouncement snippet.
	self
		assert: [ anSnippet notNil ] 
		description: [ 'Source snippet to merge must be non-nil' ].
	anIndex := self snippets indexOf: anSnippet.
	anIndex < 2 ifTrue: [ "ignore request" ^ self ].
	anAboveSnippet := self snippetAt: anIndex - 1.
	anAboveSnippet mergeWith: anSnippet.
]

{ #category : #'announcement handling' }
GtPlayPage >> snippetRemovalRequestedAnnouncement: aGtSnippetRemovalRequestedAnnouncement [ 
	| anSnippet |
	anSnippet := aGtSnippetRemovalRequestedAnnouncement snippet.
	self
		assert: [ anSnippet notNil ] 
		description: [ 'Source snippet for new snippet request must be non-nil' ].
	self removeSnippet: anSnippet.
]

{ #category : #'announcement handling' }
GtPlayPage >> snippetRenameRequestedAnnouncement: aGtSnippetRepnameRequestedAnnouncement [
	| others |
	others := OrderedCollection new.
	self snippets
		do: [ :each | 
			(each isInterestedInRename: aGtSnippetRepnameRequestedAnnouncement)
				ifTrue: [ others add: each ] ].
	aGtSnippetRepnameRequestedAnnouncement interestedSnippets: others
]

{ #category : #'announcement handling' }
GtPlayPage >> snippetReplacementRequestedAnnouncement: aGtSnippetReplacementRequestedAnnouncement [ 
	| anExistingSnippet aNewSnippetClass newSnippet |
	anExistingSnippet := aGtSnippetReplacementRequestedAnnouncement snippet.
	aNewSnippetClass := aGtSnippetReplacementRequestedAnnouncement requestedSnippetClass.
	self
		assert: [ anExistingSnippet notNil ] 
		description: [ 'Source snippet for new snippet request must be non-nil' ].
	self
		assert: [ aNewSnippetClass notNil ] 
		description: [ 'New snippet class for new snippet request must be non-nil' ].
	newSnippet := aNewSnippetClass new.
	aGtSnippetReplacementRequestedAnnouncement initializationBlock cull: newSnippet.
	self replaceSnippet: anExistingSnippet by: newSnippet.
]

{ #category : #accessing }
GtPlayPage >> snippets [
	<return: #OrderedCollection>
	^ snippets
]

{ #category : #'api - modification' }
GtPlayPage >> snippets: aCollectionOfGtSnippets [
	"Add snippets"
	aCollectionOfGtSnippets do: [ :eachSnippet | 
		self addSnippet: eachSnippet ]
]

{ #category : #accessing }
GtPlayPage >> string [
	<return: #String>
	^ String streamContents: [ :aStream | 
		self snippets 
			do: [ :eachSnippet | 
				eachSnippet isUserSnippet ifTrue: [ 
					| aString |
					aString := eachSnippet text asString trimRight.
					aStream nextPutAll: aString.
					(aString endsWith: '.') ifFalse: [ aStream nextPut: $. ] ] ]
			separatedBy: [ aStream crlf; crlf ] ]
]

{ #category : #accessing }
GtPlayPage >> title [
	<return: #String>
	^ title
]

{ #category : #accessing }
GtPlayPage >> title: aString [
	title := aString
]

{ #category : #private }
GtPlayPage >> updateImplicitVariables [
	| variables |
	variables := GtPrefixTree new.
	self snippets
		do: [ :each | variables addAll: each implicitLocalVariables ].
	self snippets do: [ :each | each allImplicitVariables: variables ]
]

{ #category : #store }
GtPlayPage >> xDocLoadSavedContent [
	"Load the saved content from the XdKeyDocumentStore"

	self snippets do: 
		[ :snippet | snippet xDocLoadSavedContent ].
]
