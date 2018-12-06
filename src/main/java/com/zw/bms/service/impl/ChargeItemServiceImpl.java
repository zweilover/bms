package com.zw.bms.service.impl;

import com.zw.bms.model.ChargeItem;
import com.zw.bms.commons.utils.StringUtils;
import com.zw.bms.mapper.ChargeItemMapper;
import com.zw.bms.service.IChargeItemService;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 计费子项 服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-18
 */
@Service
public class ChargeItemServiceImpl extends ServiceImpl<ChargeItemMapper, ChargeItem> implements IChargeItemService {

	@Autowired
	private ChargeItemMapper chargeItemMapper;
	
	public List<ChargeItem> selectChargeItemList(Page<ChargeItem> page,ChargeItem chargeItem){
		return chargeItemMapper.selectChargeItemList(page, chargeItem);
	}
	
	/**
	 * 子项新增和修改时，校验子项名称是否重复
	 */
	@Override
	public String validData(ChargeItem chargeItem) {
		Integer i = 0;
		if(StringUtils.isNotBlank(chargeItem.getName())){
			EntityWrapper<ChargeItem> ew = new EntityWrapper<ChargeItem>();
			ew.and("name = {0}",chargeItem.getName());
			//适用于修改
			if(null != chargeItem.getId() && chargeItem.getId() != 0){
				ew.and("id != {0}",chargeItem.getId());
			}
			i= chargeItemMapper.selectCount(ew);
			if(i > 0){
				return "计费子项名称已存在！";
			}
		}
		
		return null;
	}
	
	/**
	 * 根据计费类型获取计费子项
	 * @param typeId
	 * @return
	 */
	@Override
	public List<ChargeItem> selectItemsByChargeType(Long typeId){
		return chargeItemMapper.selectItemsByChargeType(typeId);
	}
	
}
