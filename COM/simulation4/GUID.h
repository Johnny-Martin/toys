#include "stdafx.h"
#include"InterfaceDecl.h"

//{00000000-0000-0000-C000-000000000046} 统一的IID_IUnknown,所有COM组件的IID_IUnknown都相同
const IID IID_IUnknown = {
	0x00000000, 0x0000, 0x0000,{ 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46 }
};

// {2B7846C4-2005-47D9-BFC4-6E9DBF3730D9}
const IID IID_IDictionary = {
	0x2b7846c4, 0x2005, 0x47d9,{ 0xbf, 0xc4, 0x6e, 0x9d, 0xbf, 0x37, 0x30, 0xd9 }
};

// {687C9920-A4DB-4A57-9126-C5F4044D8704}
const IID IID_ISpellCheck = {
	0x687c9920, 0xa4db, 0x4a57,{ 0x91, 0x26, 0xc5, 0xf4, 0x4, 0x4d, 0x87, 0x4 }
};

// {8029EA17-3B21-42EA-950A-5D698ABC0717}
const IID  IID_IClassFactory = {
	0x8029ea17, 0x3b21, 0x42ea,{ 0x95, 0xa, 0x5d, 0x69, 0x8a, 0xbc, 0x7, 0x17 } 
};

const IID CLSID_DictionaryComponent = {
	0x354cd5c5, 0x839b, 0x4a1e,{ 0x80, 0x33, 0xe, 0xbc, 0x52, 0x46, 0xa4, 0xef} 
};


