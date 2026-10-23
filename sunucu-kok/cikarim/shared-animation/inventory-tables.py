"""Native inventory, upgrade and market record boundaries."""
import struct
def records(raw,kind):
    p=8;rows=[]
    def skip(p):return p+2+struct.unpack_from('<H',raw,p)[0]
    for _ in range(struct.unpack_from('<I',raw,4)[0]):
        start=p;ident=struct.unpack_from('<I',raw,p)[0]
        if kind==2:p=skip(p+4)+36;p=skip(p)+4;p=skip(p)+16
        elif kind==0xCC:
            p=skip(p+8)+8
            for _ in range(4):p=skip(p)
            p+=8
        else:p=skip(skip(p+12))+8
        rows.append((ident,raw[start:p]))
    assert p==len(raw),(hex(kind),p,len(raw))
    return rows