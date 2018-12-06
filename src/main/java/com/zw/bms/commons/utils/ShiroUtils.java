package com.zw.bms.commons.utils;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.shiro.SecurityUtils;

import com.zw.bms.commons.shiro.ShiroUser;

/**
 * 登录信息
 * @author zhaiwei
 * @date 2017年12月4日14:47:18
 */
public class ShiroUtils {
	private static final Logger LOGGER = LogManager.getLogger(ShiroUtils.class);
	
	/**
	 * 获取当前用户的登录名
	 * @return
	 */
	public static String getLoginName(){
		String loginName = null;
		try{
			loginName = SecurityUtils.getSubject().getPrincipals().getPrimaryPrincipal().toString();
		}catch(Exception e){
			LOGGER.error(e.getMessage(),e);
		}
		return loginName;
	}
	
	/**
	 * 获取当前登录的用户
	 * @return
	 */
	public static ShiroUser getShiroUser(){
		ShiroUser shiroUser = null;
		try{
			shiroUser = (ShiroUser)SecurityUtils.getSubject().getPrincipals().getPrimaryPrincipal();
		}catch(Exception e){
			LOGGER.error(e.getMessage(),e);
		}
		return shiroUser;
	}
}
