package com.zw.bms.service.impl;

import com.zw.bms.model.AccountDetail;
import com.zw.bms.mapper.AccountDetailMapper;
import com.zw.bms.service.IAccountDetailService;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 客户账户明细 服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-01-04
 */
@Service
public class AccountDetailServiceImpl extends ServiceImpl<AccountDetailMapper, AccountDetail> implements IAccountDetailService {
	
	@Autowired
	private AccountDetailMapper accountDetailMapper;
	
	@Override
	public List<AccountDetail> selectAccountDetailList(Page<AccountDetail> page,AccountDetail detail){
		return accountDetailMapper.selectAccountDetailList(page, detail);
	}
}
