package com.zw.bms.mapper;

import com.zw.bms.model.BigCustomer;
import com.zw.bms.model.ChargeItem;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.Page;

/**
 * <p>
  *  Mapper 接口
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-30
 */
public interface BigCustomerMapper extends BaseMapper<BigCustomer> {

	/**
	 * 获取大客户列表
	 * @param page
	 * @param bigCustomer
	 * @return
	 */
	List<BigCustomer> selectBigCustomerList(Page<BigCustomer> page,@Param("bigCustomer")BigCustomer bigCustomer);
	
	/**
	 * 根据计费子项和和客户id获取大客户信息
	 * @param id 客户id
	 * @param items 计费子项列表
	 * @return
	 */
	List<BigCustomer> getBigCustomerByChargeItem(@Param("id")Long id,@Param("items")List<ChargeItem> lst_items);
}