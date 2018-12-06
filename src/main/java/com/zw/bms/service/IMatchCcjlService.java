package com.zw.bms.service;

import com.zw.bms.model.MatchCcjl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
public interface IMatchCcjlService extends IService<MatchCcjl> {
	/**
	 * 查询出仓匹配列表
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String,Object>> selectMatchCcDataList(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
	/**
	 * 获取出仓匹配车辆列表
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String,Object>> selectMatchCcPickList(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
	/**
	 * 处理出仓自动匹配
	 * @param param
	 */
	void dealAutoMatchCcData(Map<String,Object> param);
	
}
