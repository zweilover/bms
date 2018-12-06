package com.zw.bms.service.impl;

import com.zw.bms.model.StoreInfo;
import com.zw.bms.commons.exception.CommonException;
import com.zw.bms.commons.utils.StringUtils;
import com.zw.bms.mapper.StoreInfoMapper;
import com.zw.bms.service.IStoreInfoService;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 仓库信息表 服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-08-31
 */
@Service
public class StoreInfoServiceImpl extends ServiceImpl<StoreInfoMapper, StoreInfo> implements IStoreInfoService {

	@Autowired
	private StoreInfoMapper storeInfoMapper;
	
	@Override
	public void checkUnique4StoreInfo(StoreInfo storeInfo) {
		Integer i = 0;
		if(StringUtils.isNotBlank(storeInfo.getName())){
			EntityWrapper<StoreInfo> ew = new EntityWrapper<StoreInfo>();
			ew.and("status != {0} and name = {1} and location = {2}", "2",storeInfo.getName(),storeInfo.getLocation());
			if(null != storeInfo.getId() && storeInfo.getId() != 0){
				ew.and("id != {0}",storeInfo.getId());
			}
			i = storeInfoMapper.selectCount(ew);
			if(i > 0){
				throw new CommonException("该库房名称重复，请核实！");
			}
		}
	}
	
}
