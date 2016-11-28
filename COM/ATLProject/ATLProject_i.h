

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


 /* File created by MIDL compiler version 8.00.0603 */
/* at Mon Nov 28 11:25:11 2016
 */
/* Compiler settings for ATLProject.idl:
    Oicf, W1, Zp8, env=Win32 (32b run), target_arch=X86 8.00.0603 
    protocol : dce , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
/* @@MIDL_FILE_HEADING(  ) */

#pragma warning( disable: 4049 )  /* more than 64k source lines */


/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 475
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif // __RPCNDR_H_VERSION__

#ifndef COM_NO_WINDOWS_H
#include "windows.h"
#include "ole2.h"
#endif /*COM_NO_WINDOWS_H*/

#ifndef __ATLProject_i_h__
#define __ATLProject_i_h__

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

/* Forward Declarations */ 

#ifndef __ISmpMath_FWD_DEFINED__
#define __ISmpMath_FWD_DEFINED__
typedef interface ISmpMath ISmpMath;

#endif 	/* __ISmpMath_FWD_DEFINED__ */


#ifndef __SmpMath_FWD_DEFINED__
#define __SmpMath_FWD_DEFINED__

#ifdef __cplusplus
typedef class SmpMath SmpMath;
#else
typedef struct SmpMath SmpMath;
#endif /* __cplusplus */

#endif 	/* __SmpMath_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"

#ifdef __cplusplus
extern "C"{
#endif 


#ifndef __ISmpMath_INTERFACE_DEFINED__
#define __ISmpMath_INTERFACE_DEFINED__

/* interface ISmpMath */
/* [unique][nonextensible][dual][uuid][object] */ 


EXTERN_C const IID IID_ISmpMath;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("BFB088A8-8482-41AB-8C8B-0216256FFFBB")
    ISmpMath : public IDispatch
    {
    public:
        virtual /* [id] */ HRESULT STDMETHODCALLTYPE Add( 
            /* [in] */ DOUBLE f,
            /* [in] */ DOUBLE s,
            /* [retval][out] */ DOUBLE *o) = 0;
        
    };
    
    
#else 	/* C style interface */

    typedef struct ISmpMathVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            ISmpMath * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            _COM_Outptr_  void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            ISmpMath * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            ISmpMath * This);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            ISmpMath * This,
            /* [out] */ UINT *pctinfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            ISmpMath * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            ISmpMath * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [range][in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            ISmpMath * This,
            /* [annotation][in] */ 
            _In_  DISPID dispIdMember,
            /* [annotation][in] */ 
            _In_  REFIID riid,
            /* [annotation][in] */ 
            _In_  LCID lcid,
            /* [annotation][in] */ 
            _In_  WORD wFlags,
            /* [annotation][out][in] */ 
            _In_  DISPPARAMS *pDispParams,
            /* [annotation][out] */ 
            _Out_opt_  VARIANT *pVarResult,
            /* [annotation][out] */ 
            _Out_opt_  EXCEPINFO *pExcepInfo,
            /* [annotation][out] */ 
            _Out_opt_  UINT *puArgErr);
        
        /* [id] */ HRESULT ( STDMETHODCALLTYPE *Add )( 
            ISmpMath * This,
            /* [in] */ DOUBLE f,
            /* [in] */ DOUBLE s,
            /* [retval][out] */ DOUBLE *o);
        
        END_INTERFACE
    } ISmpMathVtbl;

    interface ISmpMath
    {
        CONST_VTBL struct ISmpMathVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define ISmpMath_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ISmpMath_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define ISmpMath_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define ISmpMath_GetTypeInfoCount(This,pctinfo)	\
    ( (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo) ) 

#define ISmpMath_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    ( (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo) ) 

#define ISmpMath_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    ( (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId) ) 

#define ISmpMath_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    ( (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr) ) 


#define ISmpMath_Add(This,f,s,o)	\
    ( (This)->lpVtbl -> Add(This,f,s,o) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __ISmpMath_INTERFACE_DEFINED__ */



#ifndef __ATLProjectLib_LIBRARY_DEFINED__
#define __ATLProjectLib_LIBRARY_DEFINED__

/* library ATLProjectLib */
/* [version][uuid] */ 


EXTERN_C const IID LIBID_ATLProjectLib;

EXTERN_C const CLSID CLSID_SmpMath;

#ifdef __cplusplus

class DECLSPEC_UUID("FF06C94D-06C2-4225-9CD4-7843C744DBD2")
SmpMath;
#endif
#endif /* __ATLProjectLib_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif


