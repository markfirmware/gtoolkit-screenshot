Class {
	#name : #GtPlayBook,
	#superclass : #Object,
	#traits : 'TBlDebug + TGtAnnouncer',
	#classTraits : 'TBlDebug classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'pages',
		'announcer'
	],
	#category : #'GToolkit-Playground-Model'
}

{ #category : #accessing }
GtPlayBook class >> empty [
	^ self new
]

{ #category : #'instance creation' }
GtPlayBook class >> fromXdFile: anXdFile [

	self flag: 'XDoc API proposeal [feenkcom/gtoolkit#888]'.
	"anXdFile navigator
		ignoreErrors;
		mainDocument;
		mainAttachment;
		string;
		onErrorReturn: [ :anException | self newDefault ];
		as: [ :aString | XdPlayBookJsonMapping readPlayBook: aString ];
		find"

	^ anXdFile streamingStrategy zip members
			detect: [ :aMember | aMember fileName endsWith: XdConstants playBookExtension ]
			ifFound: [ :aPlayBookMember | 
				[ | aJsonString |
				aJsonString := aPlayBookMember contents asByteArray utf8Decoded.
				XdPlayBookJsonMapping readPlayBook: aJsonString ]
				on: Error do: [ :anException | self newDefault] ]
			ifNone: [ self newDefault ]
]

{ #category : #'instance creation' }
GtPlayBook class >> newDefault [
	"Open a new play book with one page and one default snippet"
	<return: #GtPlayBook>
	^ self new 
		addPlayPage: GtPlayPage newDefault;
		subscribeExternalTools
]

{ #category : #'instance creation' }
GtPlayBook class >> newWithCodeSnippetContent: aString [
	| aPlayBook aSnippet |
	self
		assert: [ aString isString ] 
		description: [ 'Code snippet content must be a string' ].
	aPlayBook := self newDefault.
	aSnippet := aPlayBook pages first snippets first.
	aSnippet sourceCode: aString.
	^ aPlayBook
]

{ #category : #'instance creation' }
GtPlayBook class >> open [
	| aPlayground aSpace |

	aPlayground := self new asElement.
	aSpace := BlSpace new.
	aSpace title: 'Playground' translated.
	aSpace extent: 1200@600.
	aSpace root addChild: aPlayground.
	"aSpace root when: BlDblClickEvent do: [ :evt | BlElementSelection on: evt target ]."
	aSpace show.
	
	^ aPlayground
]

{ #category : #visitor }
GtPlayBook >> accept: aVisitor [
	^ aVisitor visitGtPlayBook: self
]

{ #category : #adding }
GtPlayBook >> addPlayPage: aGtPlayPage [
	self 
		assert: [ aGtPlayPage notNil ] 
		description: [ 'Play page must be non-nil' ].
	pages addLast: aGtPlayPage.
	self attachToPage: aGtPlayPage.
]

{ #category : #announcer }
GtPlayBook >> announcer [
	<return: #Announcer>
	^ announcer
]

{ #category : #converting }
GtPlayBook >> asElement [
	<return: #BlElement>
	^ GtPlayground new playBook: self
]

{ #category : #subscriptions }
GtPlayBook >> attachToPage: aGtPlayPage [
	aGtPlayPage
		when: GtPageAnnoucement
		send: #pageAnnouncement:
		to: self
		for: self
]

{ #category : #accessing }
GtPlayBook >> bindingsDo: aBlock [
	"Enumerate ${class:GtSnippetBindings}$ bindings and call aBlock for every bindings instance.
	Since ${class:GtPlayBook}$ has be default only one ${class:GtPlayPage}$, there is usually only one ${class:GtSnippetBindings}$ instance."
	self pages do: [ :eachPage | 
		eachPage bindingsDo: aBlock ]
]

{ #category : #actions }
GtPlayBook >> copyContentToClipboard [
	| aContent |	
	aContent := self string trimBoth.
	aContent ifEmpty: [ 
		self inform: 'Nothing was copied because the playground is empty'.
		^ self ].
	Clipboard clipboardText: aContent.
	Screenshot takeForElement: (self announcer subscriptionsForClass: GtPlayBookWidgetModel) first widget.
	self inform: 'Playground content was copied to clipboard'.

]

{ #category : #'gt-extension' }
GtPlayBook >> gtCopyContentToClipboardActionFor: anAction [
	<gtAction>
	^ anAction button
			icon: BrGlamorousIcons clipboard;
			tooltip: 'Copy content to Clipboard';
			forPlayground;
			priority: 10;
			action: [ :aButton | self copyContentToClipboard ] 
]

{ #category : #'gt-extension' }
GtPlayBook >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live' translated;
		priority: 50;
		stencil: [ self asElement ]
]

{ #category : #'gt-extension' }
GtPlayBook >> gtRunAllActionFor: anAction [
	"<gtAction>"
	^ anAction button
			icon: BrGlamorousVectorIcons play;
			tooltip: 'Evaluate all';
			forPlayground;
			priority: 1;
			action: [ :aButton | self playAllAndSelectResult: aButton ] 
]

{ #category : #'gt-extension' }
GtPlayBook >> gtRunAllAndInspectActionFor: anAction [
	"<gtAction>"
	^ anAction button
			icon: BrGlamorousVectorIcons playinspect;
			tooltip: 'Evaluate all and inspect';
			forPlayground;
			priority: 2;
			action: [ :aButton | self playAllAndSpawnResult: aButton ] 
]

{ #category : #initialization }
GtPlayBook >> initialize [
	super initialize.
	pages := OrderedCollection new.
	announcer := Announcer new.
]

{ #category : #accessing }
GtPlayBook >> numberOfPages [
	^ self pages size
]

{ #category : #'announcement handling' }
GtPlayBook >> pageAnnouncement: aGtPageAnnouncement [ 
	self announce: aGtPageAnnouncement.
]

{ #category : #accessing }
GtPlayBook >> pages [
	<return: #OrderedCollection>
	^ pages
]

{ #category : #adding }
GtPlayBook >> pages: aCollectionOfPages [
	aCollectionOfPages do: [ :eachPage | 
		self addPlayPage: eachPage ]
]

{ #category : #actions }
GtPlayBook >> playAll [
	| aLastResult |
	aLastResult := nil.
	self pages do: [ :eachPage | aLastResult := eachPage playAll ].
	^ aLastResult
]

{ #category : #actions }
GtPlayBook >> playAllAndSelectResult: anElement [
	| aLastResult |
	aLastResult := self playAll.
	anElement phlow selectObject: aLastResult
]

{ #category : #actions }
GtPlayBook >> playAllAndSpawnResult: anElement [
	| aLastResult |
	aLastResult := self playAll.
	anElement phlow spawnObject: aLastResult
]

{ #category : #accessing }
GtPlayBook >> string [
	<return: #String>
	^ String streamContents: [ :aStream | 
		self pages 
			do: [ :eachPage | 
				| aString |
				aString := eachPage string.
				aStream nextPutAll: aString. ]
			separatedBy: [ aStream crlf ] ]
]

{ #category : #subscriptions }
GtPlayBook >> subscribeExternalTools [
	| thePragmas |
	thePragmas := Pragma 
		allNamed: #playBookHandler 
		from: self class
		to: ProtoObject.
	thePragmas do: [ :eachPragma | 
		self perform: eachPragma methodSelector ]
]
