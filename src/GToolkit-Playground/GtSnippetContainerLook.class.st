Class {
	#name : #GtSnippetContainerLook,
	#superclass : #BrLook,
	#instVars : [
		'bottomToolbar',
		'snippet',
		'closeButton'
	],
	#pools : [
		'BrGlamorousColors'
	],
	#category : #'GToolkit-Playground-Snippet - Looks'
}

{ #category : #initialization }
GtSnippetContainerLook >> initialize [
	super initialize.
		
	closeButton := self newCloseElement
		action: [ self snippetRemoveRequested ];
		elevation: (BlRelativeElevation elevation: 10);
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignTop.
			c margin: (BlInsets top: 4 right: 4) ].
		
	bottomToolbar := self newPlusElement
		action: [ self snippetBelowRequested ];
		elevation: (BlRelativeElevation elevation: 10);
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignCenter.
			c ignored vertical alignBottom.
			c margin: (BlInsets bottom: 4) ].

	self addChangeAddChildAs: #(closeButton) with: [ closeButton ].
	self addChangeAddChildAs: #(bottomToolbar) with: [ bottomToolbar ].
	
	self addChangeProperty: #(widget padding) with: [ BlInsets all: 12 ]
]

{ #category : #initialization }
GtSnippetContainerLook >> initializeListeners [
	super initializeListeners.
	
	self when: GtSnippetChanged do: [ :anEvent | self snippet: anEvent snippet ]
]

{ #category : #initialization }
GtSnippetContainerLook >> initializeRequests [
	super initializeRequests.
	
	self request: GtSnippetRequest new.
]

{ #category : #'instance creation' }
GtSnippetContainerLook >> newCloseElement [
	<return: #BlElement>

	^ GtInspectorRoundButtonStencil small asElement
		icon: (GtInspectorPlusIconStencil close thickness: 1; radius: 4; asElement);
		yourself
]

{ #category : #'instance creation' }
GtSnippetContainerLook >> newPlusElement [
	<return: #BlElement>

	^ GtInspectorRoundButtonStencil small asElement
		icon: (GtInspectorPlusIconStencil add thickness: 1; radius: 4; asElement);
		yourself
]

{ #category : #accessing }
GtSnippetContainerLook >> snippet [
	^ snippet
]

{ #category : #accessing }
GtSnippetContainerLook >> snippet: aGtSnippet [
	snippet := aGtSnippet.
]

{ #category : #private }
GtSnippetContainerLook >> snippetBelowRequested [
	self snippet ifNil: [ ^ self inform: 'A snippet must be attached' ].
	self snippet requestNewSnippetBelow.
]

{ #category : #private }
GtSnippetContainerLook >> snippetRemoveRequested [
	self snippet ifNil: [ ^ self inform: 'A snippet must be attached' ].
	self snippet requestSnippetRemoval.
]
