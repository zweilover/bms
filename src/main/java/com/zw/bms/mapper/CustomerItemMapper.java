package com.zw.bms.mapper;

import com.zw.bms.model.CustomerItem;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.baomidou.mybatisplus.mapper.BaseMapper;

/**
 * <p>
  * 客户计费子项关联表 Mapper 接口
 * </p>
 *
 * @author zhaiwei
 * @since 2017-12-29
 */
public interface CustomerItemMapper extends BaseMapper<CustomerItem> {
	/**
	 * 根据客户id获取优惠计费子项
	 * @param customerId
	 * @return
	 */
	List<CustomerItem> getCustItemsByCustomerId(@Param("customerId")Long customerId);
}