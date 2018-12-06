package com.zw.bms.service;

import java.util.List;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.IService;
import com.zw.bms.model.ChargeItem;

/**
 * <p>
 * 计费子项 服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-18
 */
public interface IChargeItemService extends IService<ChargeItem> {
	
	/**
	 * 查询计费子项列表
	 * @param page
	 * @param chargeItem
	 * @return
	 */
	List<ChargeItem> selectChargeItemList(Page<ChargeItem> page,ChargeItem chargeItem);
	
	String validData(ChargeItem chargeItem);
	
	/**
	 * 根据计费类型获取计费子项
	 * @param typeId
	 * @return
	 */
	List<ChargeItem> selectItemsByChargeType(Long typeId);
}
