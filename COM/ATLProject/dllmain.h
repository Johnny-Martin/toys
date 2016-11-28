// dllmain.h: 模块类的声明。

class CATLProjectModule : public ATL::CAtlDllModuleT< CATLProjectModule >
{
public :
	DECLARE_LIBID(LIBID_ATLProjectLib)
	DECLARE_REGISTRY_APPID_RESOURCEID(IDR_ATLPROJECT, "{C64C3261-B8F8-4D45-887F-48747BFD7577}")
};

extern class CATLProjectModule _AtlModule;
