/**
* @file MyBCGPPropList.h
* @brief ��չCBCGPPropListʵ��ѡ��ı��¼�
* @author �޻�
* @date 2014-12-11
* @details
*/
#pragma once

//////////////////////////////////////////////////////////////////////////
// CMyBCGPPropList

class CMyBCGPPropList : public CBCGPPropList
{
	DECLARE_DYNAMIC(CMyBCGPPropList)

public:
	virtual ~CMyBCGPPropList();

	/**
	 * ����Ԥ���ı��ؼ�ָ��
	 * @param CWnd * pWnd
	 * @return void 
	 */
	void SetPreviewWnd(CWnd* pWnd);

	/**
	 * ����ָ������д��
	 * @param LPCTSTR lpszShort
	 * @param BOOL bSearchSubItems
	 * @return CBCGPProp* 
	 */
	CBCGPProp* FindItemByShort(LPCTSTR lpszShort, BOOL bSearchSubItems = TRUE) const;

	/**
	 * �õ����յ���д�����
	 * @param CString & strValue
	 * @return void 
	 */
	void GetResultShorts(CString& strValue);

	/**
	 * ��֤�Ƿ������ͬ��д��
	 * @return BOOL ��ͨ���Ļ�������FALSE
	 */
	BOOL ValidateShort();

protected:
	DECLARE_MESSAGE_MAP()

	void Init();
	void OnChangeSelection(CBCGPProp* /*pNewSel*/, CBCGPProp* /*pOldSel*/);
	void OnPropertyChanged(CBCGPProp* pProp) const;

	void PreviewSelProperty(CBCGPProp* pProp, BOOL bCheck = FALSE) const;

protected:
	CWnd* m_pWndPreview;
};


