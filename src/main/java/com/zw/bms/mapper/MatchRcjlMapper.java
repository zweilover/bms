package com.zw.bms.mapper;

import com.zw.bms.model.MatchRcjl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.Page;

/**
 * <p>
  * 入仓匹配表 Mapper 接口
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
public interface MatchRcjlMapper extends BaseMapper<MatchRcjl> {

	/**
	 * 查询入仓匹配列表
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String, Object>> selectMatchRcDataList(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
	
	/**
	 * 获取入仓匹配车辆列表
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String, Object>> selectMatchRcPickList(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
}