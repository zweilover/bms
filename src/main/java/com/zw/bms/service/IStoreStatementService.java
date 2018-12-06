package com.zw.bms.service;

import com.zw.bms.model.StoreDetail;
import com.zw.bms.model.StoreInfo;
import com.zw.bms.model.StoreStatement;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.IService;

/**
 * <p>
 * 库房仓储表 服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-08-31
 */
public interface IStoreStatementService extends IService<StoreStatement> {
	
	/**
	 * 获取库房管理列表
	 * @param page
	 * @param queryParam
	 * @return
	 */
	public List<HashMap<String,Object>> getStoreManageList(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
	/**
	 * 保存货物出入库信息
	 * @param storeStatement
	 * @param storeDetailList
	 */
	public void saveStoreStateAndDetail(StoreStatement storeStatement,List<StoreDetail> storeDetailList);
}
