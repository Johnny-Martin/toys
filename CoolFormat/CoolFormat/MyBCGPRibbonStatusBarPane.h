/**
* @file MyBCGPRibbonStatusBarPane.h
* @brief ��չCMyBCGPRibbonStatusBarPaneʵ�ֲ����Ƽ�ͷ
* @author �޻�
* @date 2015-01-12
* @details
*/
#pragma once

//////////////////////////////////////////////////////////////////////////
// CMyBCGPRibbonStatusBarPane ����Ŀ��

class CMyBCGPRibbonStatusBarPane : public CBCGPRibbonStatusBarPane
{
	DECLARE_DYNCREATE(CMyBCGPRibbonStatusBarPane)
public:
	CMyBCGPRibbonStatusBarPane();

	CMyBCGPRibbonStatusBarPane(
		UINT		nCmdID,						// Pane command id
		LPCTSTR		lpszText,					// Pane label
		BOOL		bIsStatic = FALSE,			// Pane is static (non-clickable)
		HICON		hIcon = NULL,				// Pane icon
		LPCTSTR		lpszAlmostLargeText = NULL,	// The almost large text in pane
		BOOL		bAlphaBlendIcon = FALSE);	// The icon is 32 bit

	virtual ~CMyBCGPRibbonStatusBarPane();

protected:
	virtual void OnDrawMenuArrow(CDC* pDC, const CRect& rectMenuArrow);
};


