package com.zw.bms.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.Page;
import com.zw.bms.model.ImportCcjl;

/**
 * <p>
  * 海关系统出仓记录 Mapper 接口
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
public interface ImportCcjlMapper extends BaseMapper<ImportCcjl> {

	List<HashMap<String, Object>> selectCcDataList(Page<HashMap<String,Object>> page,@Param("param")Map<String,Object> queryParam);
}