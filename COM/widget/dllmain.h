// dllmain.h: 模块类的声明。

class CwidgetModule : public ATL::CAtlDllModuleT< CwidgetModule >
{
public :
	DECLARE_LIBID(LIBID_widgetLib)
	DECLARE_REGISTRY_APPID_RESOURCEID(IDR_WIDGET, "{771F54D1-2CF0-45C3-9345-DF80E133718D}")
};

extern class CwidgetModule _AtlModule;
