package com.zw.bms.service;

import java.util.List;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.IService;
import com.zw.bms.model.BigCustomer;
import com.zw.bms.model.CustomerItem;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-30
 */
public interface IBigCustomerService extends IService<BigCustomer> {
	/**
	 * 获取大客户列表
	 * @param page
	 * @param bigCustomer
	 * @return
	 */
	List<BigCustomer> selectBigCustomerList(Page<BigCustomer> page,BigCustomer bigCustomer);
	
	String validData(BigCustomer bigCustomer);
	
	/**
	 * 计费子项增加和修改前数据校验
	 * @param customerItem
	 * @return
	 */
	String validItemData(CustomerItem customerItem);
	
	/**
	 * 获取所有客户信息，适用于下拉列表
	 * @param isAllStatus
	 * @return
	 */
	List<BigCustomer> selectAllCustomer(boolean isAllStatus);
	
	/**
	 * 根据客户id获取优惠计费子项
	 * @param customerId 客户id
	 * @return
	 */
	List<CustomerItem> getCustItemsByCustomerId(Long customerId);
	
}
