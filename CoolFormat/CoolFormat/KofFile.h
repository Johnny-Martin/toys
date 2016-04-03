/** 
 * @file KofFile.h
 * @brief �򿪼������ļ�
 * @author �޻� 
 * @date 2012-4-3
 * @details �򿪼�����ANSI��UTF-8��UTF-8NoBom��UTF-16BE��UTF-16LE��Windows��UNIX��Mac��ͬ���з��µ��ı��ļ�
 */ 
#pragma once

/** �ĵ���ʽ���� */
enum FileFormatType{
	WIN_FORMAT,		/**< Windows��ʽ�ĵ� */
	UNIX_FORMAT,
	MAC_FORMAT
};

/** �ĵ��������� */
enum FileEncodeType{
	ANSI_ENCODE = 0,	/**< ANSI���� */
	UTF8_ENCODE,
	UTF8NB_ENCODE,
	UTF16BE_ENCODE,
	UTF16LE_ENCODE,
	END_ENCODE
};

/** ��������Ϣ���� */
const UINT MAX_ERROR_MSG = 1024;

class CKofFile
{
public:
	CKofFile(void);
	~CKofFile(void);

	/**
	 * ��ָ���ļ����ļ����������ݵ��ַ�������
	 * @param LPCTSTR lpszFileName �ļ���
	 * @param CString & strFileText �ַ�������
	 * @return BOOL �Ƿ�򿪳ɹ�
	 */
	BOOL OpenFile(LPCTSTR lpszFileName, CString &strFileText);

	/**
	 * ����ָ�����ݵ�ָ�����ļ����ļ�
	 * @param LPCTSTR lpszFileName �ļ��� 
	 * @param LPCTSTR lpszFileText �ַ�������
	 * @return BOOL �Ƿ񱣴�ɹ�
	 */
	BOOL SaveFile(LPCTSTR lpszFileName, LPCTSTR lpszFileText);
	
	/**
	 * ��ȡ���Ĵ�����Ϣ
	 * @return LPCTSTR ���ش�����Ϣָ��
	 */
	LPCTSTR GetLastErrorMsg(){return m_szErrorMsg;} 

	
	/**
	 * ��ȡ��ǰ�򿪵��ļ��ĵ���ʽ����
	 * @return FileFormatType �����ļ��ĵ���ʽ����
	 */
	FileFormatType GetFileFormatType(){return m_FormatType;}
	
	/**
	 * ��ȡ��ǰ�򿪵��ļ��ĵ���������
	 * @return FileEncodeType �����ļ��ĵ���������
	 */
	FileEncodeType GetFileEncodeType(){return m_EncodeType;}

	/**
	* ��ȡ��ǰ�򿪵��ļ��ĵ�����ҳ
	* @return UINT �����ļ��ĵ�����ҳ
	*/
	UINT GetCodepage(){ return m_nCodepage; }

	/**
	* ���õ�ǰ�򿪵��ļ��ĵ�����ҳ
	* @param UINT nCodePage ���ô���ҳ
	*/
	void SetCodepage(UINT nCodePage);

	/**
	* �Դ���ҳ��ȡ��������
	* @param UINT nCodePage ����ҳ
	*/
	FileEncodeType GetFileEncodeTypeByCodepage(UINT nCodePage);

	/**
	 * �ı��������
	 * @param FileEncodeType encodeType
	 * @return BOOL 
	 */
	BOOL ChangeFileEncodeType(FileEncodeType encodeType);

	/**
	* �ı��������
	* @param FileEncodeType encodeType
	* @return BOOL
	*/
	BOOL ChangeCodepage(UINT nCodePage, CString &strFileText);

	/**
	* ��ȡ�����ַ���
	* @return LPCTSTR ���ش�����Ϣָ��
	*/
	LPCTSTR GetCodepageString();

protected:
	void DetermineEncodeType(LPSTR lpszFileBuf, DWORD dwFileSize);
	void DetermineFormatType(LPSTR lpszFileBuf, DWORD dwFileSize);
	void ConvertEncodeToTChar(LPSTR lpszFileBuf, DWORD dwFileSize, CString &strFileText);
	void ConvertFormatToTChar(CString &strFileText);
	void ProcessTCharFormat(LPSTR lpszFileText, DWORD &dwFileSize);
	void SaveFileText(CFile &file, LPSTR lpszFileBuf, DWORD dwFileSize);
	void BigEndianSwapLittleEndian(LPSTR lpszFileBuf, DWORD dwFileSize);
	BOOL IsTextUtf8(LPCSTR lpszFileBuf, DWORD dwFileSize);
	void SetLastErrorMsg(LPCTSTR lpszErrorMsg){lstrcpy(m_szErrorMsg, lpszErrorMsg);}
	void DetectCodepage(LPSTR lpszFileBuf, DWORD dwFileSize);
	UINT GetEncodingFromString(const char *encodingAlias);

private:
	FileFormatType m_FormatType;
	FileEncodeType m_EncodeType;
	TCHAR m_szErrorMsg[MAX_ERROR_MSG];
	UINT m_nSkip;
	UINT m_nCodepage;
	static const UCHAR m_EncodeBoms[END_ENCODE][3];
};
