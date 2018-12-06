package com.zw.bms.mapper;

import com.zw.bms.model.ChargeType;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.Page;

/**
 * <p>
  * 计费项目 Mapper 接口
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-18
 */
public interface ChargeTypeMapper extends BaseMapper<ChargeType> {
	
	List<ChargeType> selectChargeTypeList(Page<ChargeType> page,@Param("chargeType") ChargeType chargeType);
	
	List<Long> selectItemIdsListByTypeId(@Param("id") Long id);

}