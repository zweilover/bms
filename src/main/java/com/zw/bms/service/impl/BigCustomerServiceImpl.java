package com.zw.bms.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.zw.bms.commons.utils.StringUtils;
import com.zw.bms.mapper.BigCustomerMapper;
import com.zw.bms.mapper.CustomerItemMapper;
import com.zw.bms.model.BigCustomer;
import com.zw.bms.model.CustomerItem;
import com.zw.bms.service.IBigCustomerService;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-30
 */
@Service
public class BigCustomerServiceImpl extends ServiceImpl<BigCustomerMapper, BigCustomer> implements IBigCustomerService {

	@Autowired
	private BigCustomerMapper bigCustomerMapper;
	@Autowired
	private CustomerItemMapper customerItemMapper;
	
	@Override
	public List<BigCustomer> selectBigCustomerList(Page<BigCustomer> page, BigCustomer bigCustomer) {
		return bigCustomerMapper.selectBigCustomerList(page, bigCustomer);
	}

	@Override
	public String validData(BigCustomer bigCustomer) {
		Integer i = 0;
		if(StringUtils.isNotBlank(bigCustomer.getName())){
			EntityWrapper<BigCustomer> ew = new EntityWrapper<BigCustomer>();
			ew.and("status in('0','1') ");
			ew.and("name = {0} ",bigCustomer.getName());
			if(null != bigCustomer.getId() && bigCustomer.getId() != 0){
				ew.and("id != {0}",bigCustomer.getId());
			}
			i = bigCustomerMapper.selectCount(ew);
			if(i > 0){
				return "该客户名称重复，请核实！";
			}
		}
		return null;
	}
	
	@Override
	public String validItemData(CustomerItem customerItem){
		Integer i = 0;
		if(null != customerItem.getItemId() && customerItem.getItemId() != 0 &&
				null != customerItem.getCustomerId() && customerItem.getCustomerId() != 0){
			EntityWrapper<CustomerItem> ew = new EntityWrapper<CustomerItem>();
			ew.and("status in('0','1') ");
			ew.and("customer_id = {0} and item_id = {1} ",customerItem.getCustomerId(),customerItem.getItemId());
			if(null != customerItem.getId() && customerItem.getId() != 0){//编辑
				ew.and("id != {0}",customerItem.getId());
			}
			i = customerItemMapper.selectCount(ew);
			if(i > 0){
				return "当前客户已有该优惠项目，请核实！";
			}
		}
		return null;
	}

	@Override
	public List<BigCustomer> selectAllCustomer(boolean isAllStatus) {
		EntityWrapper<BigCustomer> ew = new EntityWrapper<BigCustomer>();
		ew.setEntity(new BigCustomer());
		if(!isAllStatus){
			ew.and("status = {0} ", "0");
		}
		ew.orderBy("seq");
		return bigCustomerMapper.selectList(ew);
	}

	@Override
	public List<CustomerItem> getCustItemsByCustomerId(Long customerId) {
		return customerItemMapper.getCustItemsByCustomerId(customerId);
	}
	
}
