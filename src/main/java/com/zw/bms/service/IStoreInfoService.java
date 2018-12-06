package com.zw.bms.service;

import com.zw.bms.model.StoreInfo;
import com.baomidou.mybatisplus.service.IService;

/**
 * <p>
 * 仓库信息表 服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-08-31
 */
public interface IStoreInfoService extends IService<StoreInfo> {
	
	/**
	 * 库房唯一性校验
	 * @return
	 */
	void checkUnique4StoreInfo(StoreInfo storeInfo);
}
