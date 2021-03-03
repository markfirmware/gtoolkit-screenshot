Class {
	#name : #GtSnippetAnnoucement,
	#superclass : #Announcement,
	#traits : 'TGtAssert',
	#classTraits : 'TGtAssert classTrait',
	#instVars : [
		'snippet'
	],
	#category : #'GToolkit-Playground-Announcements'
}

{ #category : #accessing }
GtSnippetAnnoucement class >> snippet: aGtSnippet [
	^ self new snippet: aGtSnippet
]

{ #category : #accessing }
GtSnippetAnnoucement >> snippet [
	^ snippet
]

{ #category : #accessing }
GtSnippetAnnoucement >> snippet: aGtSnippet [
	snippet := aGtSnippet
]
