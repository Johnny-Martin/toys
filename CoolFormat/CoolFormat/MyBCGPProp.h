/**
* @file MyBCGPProp.h
* @brief ��չCMyBCGPPropʵ�ִ洢������Ϣ
* @author �޻�
* @date 2014-12-11
* @details
*/
#pragma once

//////////////////////////////////////////////////////////////////////////
// CMyBCGPProp

class CMyBCGPProp : public CBCGPProp
{
	DECLARE_DYNAMIC(CMyBCGPProp)

	friend class CMyBCGPPropList;

public:
	// Group constructor
	CMyBCGPProp(const CString& strGroupName, DWORD_PTR dwData = 0,
		BOOL bIsValueList = FALSE);

	CMyBCGPProp(const CString& strName, const _variant_t& varValue,
		LPCTSTR lpszDescr = NULL, DWORD_PTR dwData = 0,
		LPCTSTR lpszEditMask = NULL, LPCTSTR lpszEditTemplate = NULL,
		LPCTSTR lpszValidChars = NULL);
	virtual ~CMyBCGPProp();

	/**
	 * ����������
	 * @param LPCTSTR lpszOption ������
	 * @param LPCTSTR lpszShort ��д��
	 * @param LPCTSTR lpszPreview Ԥ���ı�
	 * @param BOOL bInsertUnique �Ƿ�Ψһ
	 * @return BOOL 
	 */
	BOOL AddComboOption(LPCTSTR lpszOption, LPCTSTR lpszShort, LPCTSTR lpszPreview, BOOL bInsertUnique = TRUE);

	/**
	 * ����������
	 * @param int nMin ��Сֵ
	 * @param int nMax ���ֵ
	 * @param LPCTSTR lpszShort ��д��
	 * @param LPCTSTR lpszPreview Ԥ���ı�
	 * @param CMyBCGPProp* pBuddyToProp �󶨵�����������
	 * @return BOOL 
	 */
	BOOL SetNumberSpin(int nMin, int nMax, LPCTSTR lpszShort, LPCTSTR lpszPreview, CMyBCGPProp* pBuddyToProp = NULL);

	/**
	 * ���ӱ༭�ı���
	 * @param LPCTSTR lpszShort ��д��
	 * @param LPCTSTR lpszPreview Ԥ���ı�
	 * @return BOOL 
	 */
	BOOL SetEditText(LPCTSTR lpszShort, LPCTSTR lpszPreview);

	/**
	 * ���ѡ�����Ԥ���ı�
	 * @return LPCTSTR 
	 */
	LPCTSTR GetSelectedPreviewOption() const;

	/**
	 * ������д����������
	 * @param LPCTSTR lpszShort ��д��
	 * @return CBCGPProp* ��ָ��
	 */
	CBCGPProp* FindSubItemByShort(LPCTSTR lpszShort) const;

	/**
	 * �Ƿ������д��
	 * @param LPCTSTR lpszShort ��д��
	 * @return BOOL 
	 */
	BOOL IsExistShort(LPCTSTR lpszShort);

	/**
	 * ����ֵ
	 * @param LPCTSTR lpszShort ��д��
	 * @param const _variant_t & varValue
	 * @return void 
	 */
	void SetValueByShort(LPCTSTR lpszShort, const _variant_t& varValue);

	/**
	 * ��ȡ�����������д�ʽ��
	 * @param CString & strValue 
	 * @return void 
	 */
	void GetSubResultShorts(CString& strValue);

	/**
	 * ��ȡ��д�ʽ��
	 * @param CString & strValue
	 * @return void 
	 */
	void GetResultShort(CString& strValue);

	/**
	 * �Ƿ����б�
	 * @return BOOL 
	 */
	BOOL IsList() const;

	/**
	* �Ƿ����ı�
	* @return BOOL
	*/
	BOOL IsText() const;

	void GetSubShortOptions(CStringList& lstValue);

	void GetShortOptions(CStringList& lstValue);

protected:
	CStringList	m_lstShortOptions;	// ��д�ı�
	CStringList	m_lstPreviewOptions;	// Ԥ���ı�
	CMyBCGPProp* m_pBuddyProp;	// �󶨵����ԣ�һ�������༭���

	/**
	 * ������ʵ�������޶���Χ
	 * @param const CString & strText �ı�����
	 * @return BOOL 
	 */
	virtual BOOL TextToVar(const CString& strText);

	virtual void OnClickButton(CPoint point);
};


