Class {
	#name : #GtPageSnippetAnnouncement,
	#superclass : #GtPageAnnoucement,
	#instVars : [
		'snippet',
		'index'
	],
	#category : #'GToolkit-Playground-Announcements'
}

{ #category : #accessing }
GtPageSnippetAnnouncement >> index [
	<return: #Number>
	^ index
]

{ #category : #accessing }
GtPageSnippetAnnouncement >> index: anIndex [
	self 
		assert: [ anIndex notNil ] 
		description: [ 'Snippet index must be non-nil' ].
	index := anIndex
]

{ #category : #accessing }
GtPageSnippetAnnouncement >> snippet [
	<return: #GtSnippet>
	^ snippet
]

{ #category : #accessing }
GtPageSnippetAnnouncement >> snippet: aGtSnippet [
	self 
		assert: [ aGtSnippet notNil ] 
		description: [ 'Snippet must be non-nil' ].
	snippet := aGtSnippet
]
