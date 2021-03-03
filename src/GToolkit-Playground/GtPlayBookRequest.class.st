Class {
	#name : #GtPlayBookRequest,
	#superclass : #BrRequest,
	#category : #'GToolkit-Playground-PlayBook - Model'
}

{ #category : #initialization }
GtPlayBookRequest >> responseClass [
	^ GtPlayBookChanged
]
