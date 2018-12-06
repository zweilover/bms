package com.zw.bms.service;

import com.zw.bms.model.MatchRcjl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.IService;

/**
 * <p>
 * 入仓匹配表 服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
public interface IMatchRcjlService extends IService<MatchRcjl> {
	
	/**
	 * 查询入仓匹配列表
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String,Object>> selectMatchRcDataList(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
	/**
	 * 获取入仓匹配车辆列表
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String,Object>> selectMatchRcPickList(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
	/**
	 * 处理入仓自动匹配
	 * @param param
	 */
	void dealAutoMatchRcData(Map<String,Object> param);
}
