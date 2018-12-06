package com.zw.bms.service.impl;

import com.zw.bms.model.CustomerItem;
import com.zw.bms.mapper.CustomerItemMapper;
import com.zw.bms.service.ICustomerItemService;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 客户计费子项关联表 服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2017-12-29
 */
@Service
public class CustomerItemServiceImpl extends ServiceImpl<CustomerItemMapper, CustomerItem> implements ICustomerItemService {
	
}
