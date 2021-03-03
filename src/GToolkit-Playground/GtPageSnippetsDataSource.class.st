Class {
	#name : #GtPageSnippetsDataSource,
	#superclass : #BlInfiniteDataSource,
	#instVars : [
		'page'
	],
	#category : #'GToolkit-Playground-Page'
}

{ #category : #adding }
GtPageSnippetsDataSource >> addSnippet: aGtSnippet [
	page addSnippet: aGtSnippet
]

{ #category : #initialization }
GtPageSnippetsDataSource >> initialize [
	super initialize.

	self page: GtPlayPage new
]

{ #category : #accessing }
GtPageSnippetsDataSource >> itemCount [
	"Return the total number of items in the data set"
	<return: #Number>

	^ page numberOfSnippets
]

{ #category : #accessing }
GtPageSnippetsDataSource >> itemTypeAt: aPosition [
	<return: #BlInfiniteItemType>

	^ (page snippetAt: aPosition) snippetType
]

{ #category : #'instance creation' }
GtPageSnippetsDataSource >> onBindHolder: anElementHolder at: aPosition [
	anElementHolder snippet: (page snippetAt: aPosition)
]

{ #category : #'instance creation' }
GtPageSnippetsDataSource >> onCreateHolder: anInfiniteElement type: aSnippetType [
	"Override to create an ElementHolder for an item type.
	use ===BlElementHolder of: element=== to create a holder for an element"
	<return: #GtSnippetElementHolder>

	^ aSnippetType newHolder
]

{ #category : #adding }
GtPageSnippetsDataSource >> page: aGtPage [
	page ifNotNil: [ self unsubscribeFromPage ].
	page := aGtPage.
	self subscribeToPage.
]

{ #category : #'announcement handling' }
GtPageSnippetsDataSource >> snippetAdded: aGtPageSnippetAddedAnnoucement [
	self notifyItemsInserted: (aGtPageSnippetAddedAnnoucement index to: aGtPageSnippetAddedAnnoucement index)
]

{ #category : #'announcement handling' }
GtPageSnippetsDataSource >> snippetRemoved: aGtPageSnippetRemovedAnnoucement [ 
	self notifyItemsRemoved: (aGtPageSnippetRemovedAnnoucement index to: aGtPageSnippetRemovedAnnoucement index)
]

{ #category : #'announcement handling' }
GtPageSnippetsDataSource >> snippetReplaced: aGtPageSnippetReplacedAnnoucement [ 
	self notifyItemsChanged: (aGtPageSnippetReplacedAnnoucement index to: aGtPageSnippetReplacedAnnoucement index)
]

{ #category : #'private - subscriptions' }
GtPageSnippetsDataSource >> subscribeToPage [
	page
		when: GtPageSnippetAddedAnnoucement 
		send: #snippetAdded: 
		to: self 
		for: self.
	page
		when: GtPageSnippetRemovedAnnoucement 
		send: #snippetRemoved: 
		to: self 
		for: self.
	page
		when: GtPageSnippetReplacedAnnoucement 
		send: #snippetReplaced: 
		to: self 
		for: self
]

{ #category : #'private - subscriptions' }
GtPageSnippetsDataSource >> unsubscribeFromPage [
	page unsubscribe: self
]
