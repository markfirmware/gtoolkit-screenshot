Class {
	#name : #GtPlaygroundConstants,
	#superclass : #Object,
	#category : #'GToolkit-Playground-Constants'
}

{ #category : #ui }
GtPlaygroundConstants class >> editorElementName [
	^ #textEditor
]

{ #category : #ui }
GtPlaygroundConstants class >> elementPaddingInsets [
	^ BlInsets all: 5
]

{ #category : #ui }
GtPlaygroundConstants class >> labelElementName [
	^ #label
]

{ #category : #ui }
GtPlaygroundConstants class >> progressElementName [
	^ #progress
]

{ #category : #ui }
GtPlaygroundConstants class >> responseElementName [
	^ #response
]

{ #category : #ui }
GtPlaygroundConstants class >> resultElementName [
	^ #result
]

{ #category : #ui }
GtPlaygroundConstants class >> variableElementName [
	^ #variable
]
