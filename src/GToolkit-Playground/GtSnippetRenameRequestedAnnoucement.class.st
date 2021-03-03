Class {
	#name : #GtSnippetRenameRequestedAnnoucement,
	#superclass : #GtSnippetAnnoucement,
	#instVars : [
		'variableName',
		'selector',
		'interestedSnippets'
	],
	#category : #'GToolkit-Playground-Announcements'
}

{ #category : #accessing }
GtSnippetRenameRequestedAnnoucement >> interestedSnippets [
	^ interestedSnippets
]

{ #category : #accessing }
GtSnippetRenameRequestedAnnoucement >> interestedSnippets: anObject [
	interestedSnippets := anObject
]

{ #category : #accessing }
GtSnippetRenameRequestedAnnoucement >> selector [
	^ selector
]

{ #category : #accessing }
GtSnippetRenameRequestedAnnoucement >> selector: aSymbol [
	selector := aSymbol
]

{ #category : #accessing }
GtSnippetRenameRequestedAnnoucement >> variableName [
	^ variableName
]

{ #category : #accessing }
GtSnippetRenameRequestedAnnoucement >> variableName: aString [
	variableName := aString
]
