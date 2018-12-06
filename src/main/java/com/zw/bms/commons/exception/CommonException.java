package com.zw.bms.commons.exception;

public class CommonException extends RuntimeException{

	private static final long serialVersionUID = 1L;
	
	public CommonException(){
		super();
	}
	
	public CommonException(String message, Throwable cause) {
		super(message, cause);
	}

	public CommonException(String message) {
		super(message);
	}

	public CommonException(Throwable cause) {
		super(cause);
	}

	/**
	 * 拼装异常，形成如"###100001#工作流找不到对应节点形式抛出去"
	 * @param exceptionCode 异常编码
	 * @param message 异常内容
	 * @param cause
	 */
	public CommonException( String exceptionCode, String message) {
		super( "###" +  exceptionCode + "###" + message);
	}

	/**
	 * 拼装异常，形成如"###100001#工作流找不到对应节点形式抛出去"
	 * @param exceptionCode 异常编码
	 * @param message 异常内容
	 * @param cause
	 */
	public CommonException( String exceptionCode, String message, Throwable cause) {
		super( "###" +  exceptionCode + "###" + message, cause);
	}

}
