Class {
	#name : #PNGtEXtChunk,
	#superclass : #Object,
	#instVars : [
		'keyword',
		'text'
	],
	#category : #'Screenshot-Screenshot'
}

{ #category : #accessing }
PNGtEXtChunk class >> keyword: aKeyword text: aText [
	^ self new keyword: aKeyword text: aText
]

{ #category : #accessing }
PNGtEXtChunk >> keyword [
	^ keyword
]

{ #category : #accessing }
PNGtEXtChunk >> keyword: aKeyword text: aText [
	keyword := aKeyword.
	text := aText
]

{ #category : #accessing }
PNGtEXtChunk >> text [
	^ text
]

{ #category : #accessing }
PNGtEXtChunk >> writetEXtChunkOn: aStream [
	"Write a tEXt chunk"
	aStream nextPutAll: 'tEXt' asByteArray.
	aStream nextPutAll: self keyword asByteArray.
	aStream nextPutAll: #(0) asByteArray.
	aStream nextPutAll: self text asByteArray
]
