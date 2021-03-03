Class {
	#name : #GtPlayground,
	#superclass : #BlElement,
	#traits : 'TGtPagerWindowOpener',
	#classTraits : 'TGtPagerWindowOpener classTrait',
	#instVars : [
		'titleNotifier'
	],
	#category : #'GToolkit-Playground-UI'
}

{ #category : #'window creation' }
GtPlayground class >> create [
	^ self createOn: GtPlayBook newDefault.
]

{ #category : #'instance creation' }
GtPlayground class >> newOn: aPlayBook [
	"create a tool element on a given object"
	^ self new playBook: aPlayBook
]

{ #category : #'instance creation' }
GtPlayground class >> newWithSnippets: snippets [
	| playbook playground |
	playbook := GtPlayBook newWithCodeSnippetContent: snippets first.
	snippets allButFirst
		do:
			[ :el | playbook pages first addSnippet: (GtCoderSnippet new sourceCode: el) ].
	^ self newOn: playbook
]

{ #category : #'window creation' }
GtPlayground class >> open [
	^ self openOn: GtPlayBook newDefault.
]

{ #category : #'window creation' }
GtPlayground class >> openFrom: aSourceElement [
	^ self openOn: GtPlayBook newDefault from: aSourceElement.
]

{ #category : #'window creation' }
GtPlayground class >> openWithSnippets: snippets [
	| aTool |
	aTool := self newWithSnippets: snippets.
	^ aTool openInPager
]

{ #category : #initialization }
GtPlayground >> initialize [
	super initialize.
	self initializeTitleNotifier.
	self
		viewModel: GtPlayBookWidgetModel new;
		look: GtPlayBookLook;
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self when: BlClickEvent do: [ self requestFocus ].
]

{ #category : #initialization }
GtPlayground >> initializeTitleNotifier [
	titleNotifier := GtPhlowTitleIconAndLabelNotifier new
		shortLabel: 'Playground';
		icon: BrGlamorousVectorIcons play.
	self addEventHandler: titleNotifier
]

{ #category : #opening }
GtPlayground >> pagerWindowTitle [
	<return: #String>
	^ 'Playground'
]

{ #category : #accessing }
GtPlayground >> playBook [
	^ self viewModel playBook
]

{ #category : #accessing }
GtPlayground >> playBook: aGtPlayBook [
	self viewModel playBook: aGtPlayBook
]

{ #category : #accessing }
GtPlayground >> playgroundWithSnippets [
	<gtExample>
	^ GtPlayground newWithSnippets: { '3+4' . '42' }
]

{ #category : #'private - accessing' }
GtPlayground >> titleNotifier [
	<return: #GtPhlowTitleNotifier>
	^ titleNotifier
]

{ #category : #'private - updating' }
GtPlayground >> updateTabLabel [
	self titleNotifier notifyIfFocused
]
