package com.zw.bms.mapper;

import com.zw.bms.model.ImportRcjl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.Page;

/**
 * <p>
  * 海关系统入仓记录 Mapper 接口
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
public interface ImportRcjlMapper extends BaseMapper<ImportRcjl> {

	List<HashMap<String, Object>> selectRcDataList(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
}