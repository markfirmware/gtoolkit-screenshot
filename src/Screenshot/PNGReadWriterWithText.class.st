Class {
	#name : #PNGReadWriterWithText,
	#superclass : #PNGReadWriter,
	#instVars : [
		'keywordAndTexts'
	],
	#category : #Screenshot
}

{ #category : #accessing }
PNGReadWriterWithText class >> putForm: aForm onFileNamed: fileName with: texts [

	
	"PNGReadWriter putForm: PolymorphSystemSettings pharoLogoForm onFileNamed: 'test.png'"
	"PluginBasedJPEGReadWriter putForm: PolymorphSystemSettings pharoLogoForm onFileNamed: 'test.jpg'"
	
	fileName asFileReference 
		binaryWriteStreamDo: [ :out | (self on: out) nextPutImage: aForm with: texts]
]

{ #category : #writing }
PNGReadWriterWithText >> nextPutImage: aForm interlace: aMethod filter: aFilterType [ 
	"Note: For now we keep it simple - interlace and filtering are simply ignored"

	| crcStream |
	bigEndian := EndianDetector isBigEndian.
	form := aForm.
	width := aForm width.
	height := aForm height.
	aForm depth <= 8 
		ifTrue: 
			[bitsPerChannel := aForm depth.
			colorType := 3.
			bytesPerScanline := (width * aForm depth + 7) // 8]
		ifFalse: 
			[bitsPerChannel := 8.
			colorType := 6.
			bytesPerScanline := width * 4].
	self writeFileSignature.
	crcStream := (ByteArray new: 1000) writeStream.
	crcStream resetToStart.
	self writeIHDRChunkOn: crcStream.
	self writeChunk: crcStream.
	form depth <= 8 
		ifTrue: 
			[crcStream resetToStart.
			self writePLTEChunkOn: crcStream.
			self writeChunk: crcStream.
			form isColorForm 
				ifTrue: 
					[crcStream resetToStart.
					self writeTRNSChunkOn: crcStream.
					self writeChunk: crcStream]].
	form depth = 16 
		ifTrue: 
			[crcStream resetToStart.
			self writeSBITChunkOn: crcStream.
			self writeChunk: crcStream].
	crcStream resetToStart.
	self writeIDATChunkOn: crcStream.
	self writeChunk: crcStream.
	crcStream resetToStart.
	keywordAndTexts do: [ :x |
		self writetEXtChunkOn: crcStream withKeyword: x key text: x value.
		self writeChunk: crcStream
	].
	crcStream resetToStart.
	self writeIENDChunkOn: crcStream.
	self writeChunk: crcStream
]

{ #category : #accessing }
PNGReadWriterWithText >> nextPutImage: aForm with: texts [
	"Write out the given form. We're keeping it simple here, no interlacing, no filters."
	keywordAndTexts := texts.
	^self nextPutImage: aForm interlace: 0 filter: 0. "no filtering"
]

{ #category : #writing }
PNGReadWriterWithText >> writetEXtChunkOn: aStream withKeyword: keyword text: text [
	"Write a tEXt chunk"
	aStream nextPutAll: 'tEXt' asByteArray.
	aStream nextPutAll: keyword asByteArray.
	aStream nextPutAll: #(0) asByteArray.
	aStream nextPutAll: text asByteArray
]
