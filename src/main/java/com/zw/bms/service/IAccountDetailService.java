package com.zw.bms.service;

import com.zw.bms.model.AccountDetail;
import java.util.List;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.IService;

/**
 * <p>
 * 客户账户明细 服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-01-04
 */
public interface IAccountDetailService extends IService<AccountDetail> {
	/**
	 * 获取客户回款列表
	 * @param page
	 * @param detail
	 * @return
	 */
	List<AccountDetail> selectAccountDetailList(Page<AccountDetail> page,AccountDetail detail);
}
