package com.zw.bms.mapper;

import com.zw.bms.model.StoreStatement;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.Page;

/**
 * <p>
  * 库房仓储表 Mapper 接口
 * </p>
 *
 * @author zhaiwei
 * @since 2018-08-31
 */
public interface StoreStatementMapper extends BaseMapper<StoreStatement> {

	/**
	 * 获取库房管理列表
	 * @param page
	 * @param queryParam
	 * @return
	 */
	public List<HashMap<String, Object>> getStoreManageList(Page<HashMap<String, Object>> page,@Param("param")Map<String, Object> queryParam);
}