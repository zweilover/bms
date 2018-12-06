package com.zw.bms.mapper;

import com.zw.bms.model.ChargeItem;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.Page;

/**
 * <p>
  * 计费子项 Mapper 接口
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-18
 */
public interface ChargeItemMapper extends BaseMapper<ChargeItem> {
	
	/**
	 * 查询计费子项列表
	 * @param page
	 * @param chargeItem
	 * @return
	 */
	List<ChargeItem> selectChargeItemList(Page<ChargeItem> page,@Param("chargeItem")ChargeItem chargeItem);
	
	/**
	 * 根据计费项目获取计费子项
	 * @param typeId
	 * @return
	 */
	List<ChargeItem> selectItemsByChargeType(@Param("typeId")Long typeId);
}