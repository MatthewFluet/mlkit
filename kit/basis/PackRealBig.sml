structure PackRealBig : PACK_REAL =
    struct
	type real = real
	val bytesPerElem = 8
	val isBigEndian = true
	fun toBytes (r:real) : Word8Vector.vector =
	    vrev(PackRealLittle.toBytes r)	    
	fun fromBytes (v: Word8Vector.vector) : real =	    
	    PackRealLittle.fromBytes(vrev v)
    end
