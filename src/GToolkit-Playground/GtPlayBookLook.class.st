Class {
	#name : #GtPlayBookLook,
	#superclass : #BrLook,
	#instVars : [
		'tabGroup',
		'playBook'
	],
	#category : #'GToolkit-Playground-PlayBook - Look'
}

{ #category : #initialization }
GtPlayBookLook >> initialize [
	super initialize.

	playBook := GtPlayBook new.
	tabGroup := BrTabGroup new look: BrGlamorousTabGroupLook.

	self updateTabs.
	self addChangeAddChildAs: #(pages) with: [ tabGroup ]
]

{ #category : #initialization }
GtPlayBookLook >> initializeListeners [
	super initializeListeners.
	
	self when: GtPlayBookChanged do: [ :anEvent | self playBook: anEvent playBook ]
]

{ #category : #initialization }
GtPlayBookLook >> initializeRequests [
	super initializeRequests.
	
	self request: GtPlayBookRequest new.
]

{ #category : #private }
GtPlayBookLook >> mayAddActionsFor: aGtPage in: aTab [
	| theActions |
	theActions := GtPhlowActionsCollector new
		fromObject: self playBook;
		selectUsing: [ :eachAction | eachAction target = GtPlaygroundActionTarget uniqueInstance ];
		collect.
	theActions ifEmpty: [ ^ self ].
	aTab toolbarStencil: [
		| aView |
		aView := GtPhlowView empty.
		aView addPhlowActions: theActions.
		aView actionsToolbarForElement: aTab ]
]

{ #category : #accessing }
GtPlayBookLook >> playBook [
	^ playBook
]

{ #category : #accessing }
GtPlayBookLook >> playBook: aGtPlayground [
	playBook := aGtPlayground.
	self updateTabs.
]

{ #category : #private }
GtPlayBookLook >> updateTab: aGtPage [
	| aTab |
	aTab := BrTab new
		look: BrGlamorousTabLook;
		padding: (BlInsets all: 10);
		label: aGtPage title;
		stencil: [ aGtPage asElement ].
	self mayAddActionsFor: aGtPage in: aTab.
	tabGroup addTab: aTab
]

{ #category : #private }
GtPlayBookLook >> updateTabs [
	tabGroup viewModel tabs copy do: [ :eachTab | 
		tabGroup removeTab: eachTab widget ].
	self playBook pages do: [ :eachPage | 
		self updateTab: eachPage ]
]
