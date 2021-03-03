Class {
	#name : #GtSnippetProgressAnnouncement,
	#superclass : #GtSnippetAnnoucement,
	#instVars : [
		'total',
		'amount'
	],
	#category : #'GToolkit-Playground-Announcements'
}

{ #category : #'instance creation' }
GtSnippetProgressAnnouncement class >> fromHTTPProgress: anHTTPProgress [
	^ self new
		amount: anHTTPProgress amount;
		total: anHTTPProgress total
]

{ #category : #accessing }
GtSnippetProgressAnnouncement >> amount [
	<return: #Number or: nil>
	^ amount
]

{ #category : #accessing }
GtSnippetProgressAnnouncement >> amount: anObject [
	amount := anObject
]

{ #category : #'accessing-computed' }
GtSnippetProgressAnnouncement >> fraction [
	^ (self amount isNil or: [ self total isNil ])
		ifFalse: [ self amount / self total ]
		ifTrue: [ 40 atRandom / 100 ]
]

{ #category : #printing }
GtSnippetProgressAnnouncement >> printOn: aStream [
	aStream 
		nextPutAll: 'Progress ';
		print: self amount;
		nextPutAll: ' out of ';
		print: self total.
]

{ #category : #accessing }
GtSnippetProgressAnnouncement >> total [
	<return: #Number or: nil>
	^ total
]

{ #category : #accessing }
GtSnippetProgressAnnouncement >> total: anObject [
	total := anObject
]
