package com.zw.bms.service;

import com.zw.bms.model.GoodsInfo;
import com.baomidou.mybatisplus.service.IService;

/**
 * <p>
 * 货物信息 服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-09-20
 */
public interface IGoodsInfoService extends IService<GoodsInfo> {
	
	/**
	 * 货物名称唯一性校验
	 * @param goodsInfo
	 */
	void checkUnique4GoodsInfo(GoodsInfo goodsInfo);
}
