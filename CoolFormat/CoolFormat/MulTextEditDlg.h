#pragma once

// CMulTextEditDlg �Ի���

class CMulTextEditDlg : public CBCGPDialog
{
	DECLARE_DYNAMIC(CMulTextEditDlg)

public:
	CMulTextEditDlg(CWnd* pParent = NULL);   // ��׼���캯��
	virtual ~CMulTextEditDlg();

	void SetText(LPCTSTR lpszText);
	LPCTSTR GetText();

// �Ի�������
	enum { IDD = IDD_MULTEXT_EDIT_DLG };

	virtual BOOL OnInitDialog();

protected:
	CString m_strValue;
	void InitLang();

	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

	DECLARE_MESSAGE_MAP()
};
