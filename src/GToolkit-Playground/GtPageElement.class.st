Class {
	#name : #GtPageElement,
	#superclass : #BlElement,
	#instVars : [
		'list'
	],
	#category : #'GToolkit-Playground-Page'
}

{ #category : #adding }
GtPageElement >> addSnippet: aGtSnippet [
	list dataSource addSnippet: aGtSnippet
]

{ #category : #initialization }
GtPageElement >> initialize [
	super initialize.

	list := GtPageSnippetsElement new.
	list constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	self addChild: list as: #list
]

{ #category : #adding }
GtPageElement >> page: aGtPage [
	list dataSource page: aGtPage.
]
