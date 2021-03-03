"
I create an ${class:GtPageElement}$ for a given ${class:GtPlayPage}$ with a ${method:GtPlayPageStencil>>#receiver}$. ${class:GtPlayPageStencil|label=Example:|expanded|show=#gtLiveFor:}$

"
Class {
	#name : #GtPlayPageStencil,
	#superclass : #BrStencil,
	#instVars : [
		'playPage',
		'receiver'
	],
	#category : #'GToolkit-Playground-Snippet - Stencils'
}

{ #category : #'api - instantiation' }
GtPlayPageStencil >> create [
	<return: #GtPageElement>
	| aPlayPageElement |
	aPlayPageElement := self playPage asElement.
	aPlayPageElement 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	self playPage bindingsDo: [ :eachBinding | 
		eachBinding at: #thisPlayground put: aPlayPageElement ].
	self playPage receiver: self receiver.
	self playPage xDocLoadSavedContent.
	^ aPlayPageElement
]

{ #category : #defaults }
GtPlayPageStencil >> defaultPlayPage [
	^ GtPlayPage newDefault.
]

{ #category : #defaults }
GtPlayPageStencil >> defaultReceiver [
	^ nil
]

{ #category : #initialization }
GtPlayPageStencil >> initialize [
	super initialize.
	playPage := self defaultPlayPage.
	receiver := self defaultReceiver.
]

{ #category : #'api - accessing' }
GtPlayPageStencil >> playPage [
	<return: #GtPlayPage>
	^ playPage
]

{ #category : #'api - accessing' }
GtPlayPageStencil >> playPage: aGtPlayPage [
	playPage := aGtPlayPage
]

{ #category : #'api - accessing' }
GtPlayPageStencil >> receiver [
	^ receiver
]

{ #category : #'api - accessing' }
GtPlayPageStencil >> receiver: anObject [
	receiver := anObject
]
