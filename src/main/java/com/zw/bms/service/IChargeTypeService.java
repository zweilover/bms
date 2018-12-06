package com.zw.bms.service;

import com.zw.bms.model.ChargeType;
import java.util.List;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.IService;

/**
 * <p>
 * 计费项目 服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-18
 */
public interface IChargeTypeService extends IService<ChargeType> {
	
	/**
	 * 查询计费项目
	 * @param page
	 * @param chargeType
	 * @return
	 */
	List<ChargeType> selectChargeTypeList(Page<ChargeType> page,ChargeType chargeType);
	
	/**
	 * 计费项目关联计费子项
	 * @param typeId
	 * @param itemIds
	 */
	public void updateChargeItemLink(Long typeId, String itemIds);
	
	/**
	 * 根据计费类型id获取已选择的计费子项
	 * @param id
	 * @return
	 */
	public List<Long> selectItemIdsListByTypeId(Long id);
	
	/**
	 * 获取所有计费项目，适用于下拉列表
	 * @param isAllStatus
	 * @return
	 */
	List<ChargeType> selectAllType(boolean isAllStatus);
	
}
