Class {
	#name : #GtSnippetReplacementRequestedAnnouncement,
	#superclass : #GtSnippetAnnoucement,
	#instVars : [
		'requestedSnippetClass',
		'initializationBlock'
	],
	#category : #'GToolkit-Playground-Announcements'
}

{ #category : #accessing }
GtSnippetReplacementRequestedAnnouncement >> initializationBlock [
	^ initializationBlock ifNil: [ [  ] ]
]

{ #category : #accessing }
GtSnippetReplacementRequestedAnnouncement >> initializationBlock: aBlock [
	initializationBlock := aBlock
]

{ #category : #accessing }
GtSnippetReplacementRequestedAnnouncement >> requestedSnippetClass [
	^ requestedSnippetClass
]

{ #category : #accessing }
GtSnippetReplacementRequestedAnnouncement >> requestedSnippetClass: anObject [
	requestedSnippetClass := anObject
]
