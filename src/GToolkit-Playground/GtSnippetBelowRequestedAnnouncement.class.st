Class {
	#name : #GtSnippetBelowRequestedAnnouncement,
	#superclass : #GtSnippetAnnoucement,
	#instVars : [
		'secondSnippet'
	],
	#category : #'GToolkit-Playground-Announcements'
}

{ #category : #'instance creation' }
GtSnippetBelowRequestedAnnouncement class >> snippet: aGtSnippet second: aSecondGtSnippet [
	^ (self snippet: aGtSnippet)
			secondSnippet: aSecondGtSnippet
]

{ #category : #accessing }
GtSnippetBelowRequestedAnnouncement >> secondSnippet [
	"If a return value is nil, a default snippet is expected"
	<return: #GtSnippet or: nil>
	^ secondSnippet
]

{ #category : #accessing }
GtSnippetBelowRequestedAnnouncement >> secondSnippet: aGtSnippet [
	secondSnippet := aGtSnippet
]
