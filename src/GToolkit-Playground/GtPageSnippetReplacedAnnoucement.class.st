Class {
	#name : #GtPageSnippetReplacedAnnoucement,
	#superclass : #GtPageSnippetAnnouncement,
	#instVars : [
		'previousSnippet'
	],
	#category : #'GToolkit-Playground-Announcements'
}

{ #category : #accessing }
GtPageSnippetReplacedAnnoucement >> previousSnippet [
	^ previousSnippet
]

{ #category : #accessing }
GtPageSnippetReplacedAnnoucement >> previousSnippet: anObject [
	previousSnippet := anObject
]
