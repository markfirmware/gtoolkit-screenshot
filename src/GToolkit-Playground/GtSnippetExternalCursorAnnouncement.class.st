Class {
	#name : #GtSnippetExternalCursorAnnouncement,
	#superclass : #GtSnippetAnnoucement,
	#instVars : [
		'direction'
	],
	#category : #'GToolkit-Playground-Announcements'
}

{ #category : #accessing }
GtSnippetExternalCursorAnnouncement >> direction [
	^ direction
]

{ #category : #accessing }
GtSnippetExternalCursorAnnouncement >> direction: aSymbol [
	direction := aSymbol
]
