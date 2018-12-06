package com.zw.bms.mapper;

import com.zw.bms.model.MatchCcjl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.Page;

/**
 * <p>
  *  Mapper 接口
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
public interface MatchCcjlMapper extends BaseMapper<MatchCcjl> {

	/**
	 * 查询出仓匹配列表
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String, Object>> selectMatchCcDataList(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
	
	/**
	 * 获取出仓匹配车辆列表
	 * @param page
	 * @param queryParam
	 * @return
	 */
	List<HashMap<String, Object>> selectMatchCcPickList(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
}