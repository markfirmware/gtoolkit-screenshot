Class {
	#name : #GtPageSnippetsElement,
	#superclass : #BlInfiniteElement,
	#category : #'GToolkit-Playground-Page'
}

{ #category : #initialization }
GtPageSnippetsElement >> defaultDataSource [
	^ GtPageSnippetsDataSource new
]

{ #category : #initialization }
GtPageSnippetsElement >> defaultLayout [
	^ BlInfiniteLinearLayout new beVertical
]
