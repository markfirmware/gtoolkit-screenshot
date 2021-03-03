Class {
	#name : #GtCoderSnippet,
	#superclass : #GtCodeSnippet,
	#instVars : [
		'coder',
		'shouldSpawn'
	],
	#category : #'GToolkit-Playground-Model'
}

{ #category : #accessing }
GtCoderSnippet class >> typeName [
	"Return a playground snippet type name.
	It should be an unique name among all playground snippet types."
	<return: #String>

	^ 'pharo'
]

{ #category : #visitor }
GtCoderSnippet >> accept: aVisitor [
	^ aVisitor visitGtPharoSnippet: self
]

{ #category : #accessing }
GtCoderSnippet >> allImplicitVariables: aCollection [
	coder completionStrategy snippetVariables: aCollection
]

{ #category : #'private - text' }
GtCoderSnippet >> appendDotCharacter [
	self text insertString: '.' at: self text size
]

{ #category : #'private - text' }
GtCoderSnippet >> appendNewLine [
	self text insertString: String cr at: self text size.
]

{ #category : #'private - text' }
GtCoderSnippet >> appendText: aNewText [
	| aLastNonSeparatorCharacterIndex |
	aLastNonSeparatorCharacterIndex := self text finder
		startAtEnd;
		reversed;
		pattern: [ :aText :aCurrentIndex | (aText at: aCurrentIndex) isSeparator not ];
		search.
	(aLastNonSeparatorCharacterIndex > 2
		and: [ (self text at: aLastNonSeparatorCharacterIndex) ~= $. ])
		ifTrue: [ self appendDotCharacter ].
	self appendNewLine.
	self text append: aNewText
]

{ #category : #ui }
GtCoderSnippet >> asElement [
	| aCoderElement |
	
	aCoderElement := coder asCoderUIModel asElement.
	aCoderElement margin: (BlInsets all: 0).

	self announcer
		when: GtSnippetFocusRequestAnnouncement
		send: #requestFocus
		to: aCoderElement.
	
	^ BrFrame new
		vFitContent;
		hMatchParent;
		addLook: (GtSnippetContainerLook new snippet: self);
		addChild: aCoderElement
]

{ #category : #converting }
GtCoderSnippet >> asStencilBuilder [
	^ self
]

{ #category : #private }
GtCoderSnippet >> ast [
	^ GtPharoParser
		parseWithErrors: coder currentSourceString
		startingAt: GtPharoParser startingStateForMethodSequence
]

{ #category : #ui }
GtCoderSnippet >> bind: aSnippet to: aSnippetElement [
]

{ #category : #private }
GtCoderSnippet >> codeEvaluated: anEvaluationAnnouncement [
	self
		notifyAboutResult: anEvaluationAnnouncement evaluationResult
		exception: anEvaluationAnnouncement evaluationResult isError
		spawn: shouldSpawn
]

{ #category : #private }
GtCoderSnippet >> codeModified: aCoderTextModifiedAnnouncement [
	self announce: (GtPageSnippetChangedAnnouncement new snippet: self)
]

{ #category : #initialization }
GtCoderSnippet >> defaultStyler [
	^ BrRBTextStyler new workspace: GtHighlightingBindingStrategy new
]

{ #category : #actions }
GtCoderSnippet >> evaluate [
	self halt.
	"^ coder doItSelectionOrAll"
]

{ #category : #actions }
GtCoderSnippet >> evaluateAndGo [
	self halt.
	"shouldSpawn := true.
	^ [ coder doItSelectionOrAll ]
		ensure: [ shouldSpawn := false ]"
]

{ #category : #'private-actions' }
GtCoderSnippet >> finishRenaming: oldName to: newName in: text [
	| ast otherNodes |
	ast := RBParser parseFaultyExpression: text.
	otherNodes := OrderedCollection new.
	ast
		nodesDo: [ :node | 
			(node isVariable
				and: [ node name = oldName and: [ (node whoDefines: newName) isNil ] ])
				ifTrue: [ otherNodes add: node ] ].
	(otherNodes asSortedCollection: [ :a :b | a stop > b stop ])
		do: [ :node | 
			text
				delete: node start to: node stop;
				insertString: newName at: node start - 1 ].
	coder removeRefactoringAttribute.
	coder requestStyleSourceText
]

{ #category : #'private-actions' }
GtCoderSnippet >> finishRenamingMessage: oldName to: newName in: text [
	| ast otherRenames |
	ast := RBParser parseFaultyExpression: text.
	otherRenames := OrderedCollection new.
	ast
		nodesDo: [ :node | 
			(node isMessage and: [ node selector = oldName ])
				ifTrue: [ node keywordsIntervals reversed
						with: newName keywords reversed
						do: [ :interval :each | otherRenames add: interval -> each ] ].
			(node isLiteralNode and: [ node value = oldName ])
				ifTrue:
					[ otherRenames add: node sourceInterval -> ('#' , newName) ] ].
	(otherRenames asSortedCollection: [ :a :b | a key last > b key last ])
		do: [ :each | 
			text
				delete: each key first to: each key last;
				insertString: each value at: each key first - 1 ].
	coder removeRefactoringAttribute.
	coder requestStyleSourceText
]

{ #category : #'api - cursor' }
GtCoderSnippet >> focusAndPlaceCursorAtBeginning [
	self flag: 'self textEditor moveCursorTo: 0.'.
	self requestSnippetFocus
]

{ #category : #'api - cursor' }
GtCoderSnippet >> focusAndPlaceCursorAtEnd [
	self flag: 'self textEditor moveCursorTo: self textEditor text size.'.
	self requestSnippetFocus
]

{ #category : #accessing }
GtCoderSnippet >> gtKeybindingsFor: aView [
	<gtView>
	^ (coder gtViewKeybindingsFor: aView)
		priority: 60
]

{ #category : #accessing }
GtCoderSnippet >> implicitLocalVariables [
	^ self ast ifNotNil: [ :ast | ast implicitLocalVariables ]
]

{ #category : #initialization }
GtCoderSnippet >> initialize [
	coder := GtPharoSnippetCoder new.
	super initialize.
	coder completionStrategy: GtSnippetCompletionStrategy new.
	shouldSpawn := false.
	
	coder announcer weak
		when: GtCoderEvaluationAnnouncement
		send: #codeEvaluated:
		to: self.
		
	coder announcer weak
		when: GtCoderSourceCodeChanged
		send: #codeModified:
		to: self.

	self variableBindings: GtSnippetBindings new.
	self subscribeToEditorChanges.
	self initializeCoderAddOns
]

{ #category : #initialization }
GtCoderSnippet >> initializeCoderAddOns [
	coder addOns
		addDropDownAction: 'Create example'
			icon: BrGlamorousVectorIcons eg
			stencil: [ :selectedClass | 
				| currentSource |
				currentSource := self text.
				self
					requestSnippetReplacement: GtExampleSnippet
					initializedWith: [ :anExampleSnippet | 
						anExampleSnippet
							updateForCodeSnippet: currentSource
							inClass: selectedClass ] ];
		addShortcut:
			(BlShortcutWithAction new
				combination: BlKeyCombination builder primary backspace build;
				action: [ :aShortcutEvent | self requestSnippetMerge ]);
		addShortcut:
			(BlShortcutWithAction new
				repeatable: false;
				combination: BlKeyCombination primaryR;
				action: [ :aShortcutEvent | self startRenameIn: aShortcutEvent currentTarget ]);
		addShortcut:
			(BlShortcutWithAction new
				combination: (BlKeyCombination builder primary return build);
				action: [ :aShortcutEvent | self requestSnippetSplitInEditor: aShortcutEvent currentTarget editor ]);
		addShortcut:
			(BlShortcutWithAction new
				combination: BlKeyCombination arrowLeft;
				action: [ :aShortcutEvent | self moveLeft: aShortcutEvent currentTarget ]);
		addShortcut:
			(BlShortcutWithAction new
				combination: BlKeyCombination arrowRight;
				action: [ :aShortcutEvent | self moveRight: aShortcutEvent currentTarget ]);
		addShortcut:
			(BlShortcutWithAction new
				combination: BlKeyCombination arrowUp;
				action: [ :aShortcutEvent | self moveUp: aShortcutEvent currentTarget ]);
		addShortcut:
			(BlShortcutWithAction new
				combination: BlKeyCombination arrowDown;
				action: [ :aShortcutEvent | self moveDown: aShortcutEvent currentTarget ])
]

{ #category : #private }
GtCoderSnippet >> intervalsForRenameVariable: aString [
	| intervals |
	intervals := OrderedCollection new.
	self ast
		withAllNodesDo: [ :each | 
			((each isKindOf: GtPharoVariableNode)
				and: [ each name source = aString and: [ each whoDefines isNil ] ])
				ifTrue: [ intervals add: each sourceInterval ] ].
	^ intervals
]

{ #category : #testing }
GtCoderSnippet >> isInterestedInRename: aGtSnippetRenameRequestedAnnouncement [
	aGtSnippetRenameRequestedAnnouncement snippet == self
		ifTrue: [ ^ false ].
	aGtSnippetRenameRequestedAnnouncement variableName
		ifNotNil: [ :name | 
			(self intervalsForRenameVariable: name) notEmpty
				ifTrue: [ ^ true ] ].
	aGtSnippetRenameRequestedAnnouncement selector
		ifNotNil: [ :selector | ^ self referencesSelector: selector ].
	^ false
]

{ #category : #'api - modification' }
GtCoderSnippet >> mergeWith: aSnippet [
	"Subclasses can define merging mechanism"

	aSnippet class = self class
		ifFalse: [ ^ self ].
	aSnippet text ifNotEmpty: [ self appendText: aSnippet text ].
	aSnippet requestSnippetRemoval.
	self requestSnippetFocus.
]

{ #category : #actions }
GtCoderSnippet >> moveDown: anElement [
	| textEditor position |
	textEditor := anElement editor.
	textEditor cursors cursorsCount = 1
		ifTrue: [ position := textEditor cursors first position ].
	textEditor deselecter all deselect.
	textEditor navigator moveDown apply.
	(textEditor cursors cursorsCount = 1
		and: [ position = textEditor cursors first position ])
		ifTrue: [ self
				announce:
					(GtSnippetExternalCursorAnnouncement new
						snippet: self;
						direction: #down) ]
]

{ #category : #actions }
GtCoderSnippet >> moveLeft: anElement [
	| textEditor |
	textEditor := anElement editor.
	(textEditor cursors cursorsCount = 1
		and: [ textEditor cursors first position = 0 ])
		ifTrue: [ self
				announce:
					(GtSnippetExternalCursorAnnouncement new
						snippet: self;
						direction: #left) ]
		ifFalse: [ textEditor deselecter all deselect.
			textEditor navigator moveLeft apply ]
]

{ #category : #actions }
GtCoderSnippet >> moveRight: anElement [
	| textEditor |
	textEditor := anElement editor.
	(textEditor cursors cursorsCount = 1
		and: [ textEditor cursors first position >= textEditor text size ])
		ifTrue: [ self
				announce:
					(GtSnippetExternalCursorAnnouncement new
						snippet: self;
						direction: #right) ]
		ifFalse: [
			textEditor deselecter all deselect.
			textEditor navigator moveRight apply ]
]

{ #category : #actions }
GtCoderSnippet >> moveUp: anElement [
	| textEditor position |
	textEditor := anElement editor.
	textEditor cursors cursorsCount = 1
		ifTrue: [ position := textEditor cursors first position ].
	textEditor deselecter all deselect.
	textEditor navigator moveUp apply.
	(textEditor cursors cursorsCount = 1
		and: [ position = textEditor cursors first position ])
		ifTrue: [ self
				announce:
					(GtSnippetExternalCursorAnnouncement new
						snippet: self;
						direction: #up) ]
]

{ #category : #actions }
GtCoderSnippet >> playAll [
	^ coder doItAll
]

{ #category : #testing }
GtCoderSnippet >> referencesSelector: aSymbol [
	coder rbAST
		nodesDo: [ :each | 
			(each isMessage and: [ each selector = aSymbol ])
				ifTrue: [ ^ true ].
			(each isLiteralNode and: [ each value = aSymbol ])
				ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #'private-actions' }
GtCoderSnippet >> renameClass: node in: aTextEditorElement [
	| announcement renameController |
	renameController := GtRenameClassController new.
	renameController coder: coder.
	renameController sourceElement: aTextEditorElement.
	renameController
		completionAction: [ | oldName newName |
			oldName := renameController originalName.
			newName := renameController newName.
			announcement := GtSnippetRenameRequestedAnnoucement snippet: self.
			announcement variableName: node source.
			self announce: announcement.
			self finishRenaming: oldName to: newName in: self text.
			announcement interestedSnippets
				do: [ :each | each finishRenaming: oldName to: newName in: each text ]. ].
	renameController execute
]

{ #category : #'private-actions' }
GtCoderSnippet >> renameImplicitTemporary: node in: aTextEditorElement [
	| announcement renameAction |
	announcement := GtSnippetRenameRequestedAnnoucement snippet: self.
	announcement variableName: node source.
	self announce: announcement.
	announcement interestedSnippets isEmpty
		ifTrue: [ ^ self"coder renameIn: aTextEditorElement" ].
	renameAction := GtCompositeRenameAction
		locations: (self intervalsForRenameVariable: node source)
		element: aTextEditorElement.
	renameAction forVariableOrUnaryMessage.
	announcement interestedSnippets
		do: [ :each | 
			renameAction
				addLocations: (each intervalsForRenameVariable: node source)
				toText: each text ].
	renameAction install
]

{ #category : #'private-actions' }
GtCoderSnippet >> renameMessage: node in: aTextEditorElement [
	| announcement renameController |
	renameController := GtRenameMethodController new.
	renameController coder: coder.
	renameController sourceElement: aTextEditorElement.
	renameController
		completionAction: [ | oldName newName |
			oldName := renameController originalName asSymbol.
			newName := renameController newName asSymbol.
			announcement := GtSnippetRenameRequestedAnnoucement snippet: self.
			announcement selector: oldName.
			self announce: announcement.
			self finishRenamingMessage: oldName to: newName in: self text.
			announcement interestedSnippets
				do:
					[ :each | each finishRenamingMessage: oldName to: newName in: each text ] ].
	renameController execute
]

{ #category : #'private-actions' }
GtCoderSnippet >> renameTemporaryIn: aTextEditorElement [
	"coder renameIn: aTextEditorElement"
]

{ #category : #'private-actions' }
GtCoderSnippet >> renameVariable: node in: aTextEditorElement [
	node whoDefines notNil
		ifTrue: [ ^ self renameTemporaryIn: aTextEditorElement ].
	^ Smalltalk globals
		at: node name source asSymbol
		ifPresent: [ :global | 
			(global isKindOf: Class)
				ifTrue: [ self renameClass: node in: aTextEditorElement ] ]
		ifAbsent: [ self renameImplicitTemporary: node in: aTextEditorElement ]
]

{ #category : #'private - requests' }
GtCoderSnippet >> requestNewSnippetWith: aNewText [
	| aNewSnippet |
	aNewSnippet := self class new.
	aNewSnippet sourceCode: aNewText.
	self announce: (GtSnippetBelowRequestedAnnouncement
		snippet: self
		second: aNewSnippet).
]

{ #category : #'api - requests' }
GtCoderSnippet >> requestSnippetMerge [
	self announce: (GtSnippetMergeRequestedAnnouncement snippet: self)
]

{ #category : #actions }
GtCoderSnippet >> requestSnippetSplit [
	| positions |
	self deprecated: 'use #requestSnippetSplitInEditor:'.
	positions := (self editor cursor cursors collect: [ :each | each position ]) asSortedCollection.
	positions reverseDo: [ :each | self splitTextAt: each ].
	self editor moveCursorTo: self editor text size
]

{ #category : #'api - requests' }
GtCoderSnippet >> requestSnippetSplitInEditor: aTextEditor [
	| positions |
	positions := (aTextEditor cursors cursors
		collect: [ :each | each position ]) asSortedCollection.
	positions
		reverseDo: [ :eachIndex | 
			| aNewText |
			aNewText := self splitTextAt: eachIndex.
			self requestNewSnippetWith: aNewText ].
	aTextEditor moveCursorTo: aTextEditor text size
]

{ #category : #'api - requests' }
GtCoderSnippet >> requestStyleText [
	coder requestStyleSourceText
]

{ #category : #private }
GtCoderSnippet >> snippetType [
	^ GtCoderSnippetType of: self
]

{ #category : #accessing }
GtCoderSnippet >> sourceCode [
	^ self text asString
]

{ #category : #accessing }
GtCoderSnippet >> sourceCode: aString [
	coder currentSourceString: aString
]

{ #category : #'private - text' }
GtCoderSnippet >> splitTextAt: aSplitIndex [
	"Return a part that is deleted"
	| aDeletedPart anUpdatedText |

	aDeletedPart := self text copyFrom: aSplitIndex + 1 to: self text size.
	aDeletedPart ifEmpty: [ ^ aDeletedPart ].
	aDeletedPart trimmer leftLineBreaks; trim.
	
	anUpdatedText := coder sourceText copy.
	anUpdatedText delete: aSplitIndex + 1 to: self text size.
	anUpdatedText trimmer rightLineBreaks; trim.
	
	coder currentSourceText: anUpdatedText.
	
	^ aDeletedPart
]

{ #category : #actions }
GtCoderSnippet >> startRenameIn: aTextEditorElement [
	| node aTextPosition |
	
	aTextEditorElement editor hasCursors
		ifFalse: [ ^ self ].
	
	aTextPosition := (aTextEditorElement editor cursors first position + 1) min: aTextEditorElement editor text size.
	
	node := coder
		nodeAt: aTextPosition
		ifFound: #yoursefl
		ifNone: [ ^ self ].

	node isNil
		ifTrue: [ ^ self ].
	(node isKindOf: GtPharoVariableNode)
		ifTrue: [ ^ self renameVariable: node in: aTextEditorElement ].
	(node isKindOf: GtPharoMessageNode)
		ifTrue: [ ^ self renameMessage: node in: aTextEditorElement ]
]

{ #category : #converting }
GtCoderSnippet >> stencilBuilderClass [
	"Return a stencil builder class that knows how to display a snippet in Bloc"
	<return: #GtSnippetStencilBuilder>
	^ nil
]

{ #category : #accessing }
GtCoderSnippet >> text [
	<return: #BlText>
	^ coder sourceCode sourceText
]

{ #category : #private }
GtCoderSnippet >> textEditor [
	^ coder sourceEditor
]

{ #category : #accessing }
GtCoderSnippet >> variableBindings [
	^ coder variableBindings
]

{ #category : #accessing }
GtCoderSnippet >> variableBindings: aGtPlaygroundBindings [
	coder variableBindings: aGtPlaygroundBindings
]

{ #category : #'as yet unclassified' }
GtCoderSnippet >> xDocLoadSavedContent [
	"Load the saved content from the XdKeyDocumentStore"

	coder xDocLoadSavedContent
]
