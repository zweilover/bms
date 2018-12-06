package com.zw.bms.service.impl;

import com.zw.bms.model.ChargeLink;
import com.zw.bms.model.ChargeType;
import com.zw.bms.commons.utils.ShiroUtils;
import com.zw.bms.commons.utils.StringUtils;
import com.zw.bms.mapper.ChargeLinkMapper;
import com.zw.bms.mapper.ChargeTypeMapper;
import com.zw.bms.service.IChargeTypeService;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 计费项目 服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-18
 */
@Service
public class ChargeTypeServiceImpl extends ServiceImpl<ChargeTypeMapper, ChargeType> implements IChargeTypeService {
	
	@Autowired
	private ChargeLinkMapper chargeLinkMapper;
	@Autowired
	private ChargeTypeMapper chargeTypeMapper;
	
	public void updateChargeItemLink(Long typeId, String itemIds){
		//先删除所有计费子项
		ChargeLink link = new ChargeLink();
		link.setTypeId(typeId);
		chargeLinkMapper.delete(new EntityWrapper<ChargeLink>(link));
		
		if(StringUtils.isBlank(itemIds)){
			return;
		}
		String[] itemIdArray = itemIds.split(",");
		for(String item : itemIdArray){
			link = new ChargeLink();
			link.setTypeId(typeId);
			link.setItemId(Long.parseLong(item));
			chargeLinkMapper.insert(link);
		}
	}
	
	public List<Long> selectItemIdsListByTypeId(Long id){
		return chargeTypeMapper.selectItemIdsListByTypeId(id);
	}
	
	public List<ChargeType> selectChargeTypeList(Page<ChargeType> page,ChargeType chargeType){
		return chargeTypeMapper.selectChargeTypeList(page, chargeType);
	}

	@Override
	public List<ChargeType> selectAllType(boolean isAllStatus) {
		EntityWrapper<ChargeType> ew = new EntityWrapper<ChargeType>();
		ew.setEntity(new ChargeType());
		if(!isAllStatus){
			ew.and("status = {0}", "0");
		}
		if(StringUtils.isNotBlank(ShiroUtils.getShiroUser().getLocation())){
			ew.and(" location = {0} ", ShiroUtils.getShiroUser().getLocation());
		}
		ew.orderBy("seq");
		return chargeTypeMapper.selectList(ew);
	}
}
