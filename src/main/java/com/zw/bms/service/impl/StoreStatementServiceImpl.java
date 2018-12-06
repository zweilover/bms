package com.zw.bms.service.impl;

import com.zw.bms.model.StoreDetail;
import com.zw.bms.model.StoreStatement;
import com.zw.bms.commons.exception.CommonException;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.commons.utils.ShiroUtils;
import com.zw.bms.mapper.StoreDetailMapper;
import com.zw.bms.mapper.StoreStatementMapper;
import com.zw.bms.service.IStoreStatementService;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * <p>
 * 库房仓储表 服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-08-31
 */
@Service
public class StoreStatementServiceImpl extends ServiceImpl<StoreStatementMapper, StoreStatement> implements IStoreStatementService {

	@Autowired
	public StoreStatementMapper storeStatementMapper;
	
	@Autowired
	public StoreDetailMapper storeDetailMapper;
	
	@Autowired
	public StoreDetailServiceImpl storeDetailService;
	
	@Override
	public List<HashMap<String, Object>> getStoreManageList(Page<HashMap<String, Object>> page,Map<String, Object> queryParam) {
		return storeStatementMapper.getStoreManageList(page, queryParam);
	}

	@Override
	@Transactional
	public void saveStoreStateAndDetail(StoreStatement storeStatement, List<StoreDetail> storeDetailList) {
		if(null == storeDetailList || storeDetailList.isEmpty()){
			throw new CommonException("明细为空，请核对数据！");
		}
		
		storeStatement.setUpdateUser(ShiroUtils.getShiroUser().getLoginName());
		storeStatement.setUpdateTime(DateUtil.getNowDateTimeString());
		if(null != storeStatement.getId() && storeStatement.getId() > 0){
			storeStatementMapper.updateById(storeStatement);
			//删除所有明细
			StoreDetail delDetail = new StoreDetail();
			delDetail.setStatementId(storeStatement.getId());
			storeDetailMapper.delete(new EntityWrapper<StoreDetail>(delDetail));
		}else{
			storeStatement.setCreateUser(ShiroUtils.getShiroUser().getLoginName());
			storeStatement.setCreateTime(DateUtil.getNowDateTimeString());
			storeStatementMapper.insert(storeStatement);
		}
		
		//新增明细
		List<StoreDetail> batchList = new ArrayList<StoreDetail>();
		for(StoreDetail detail : storeDetailList){
			detail.setStatementId(storeStatement.getId());
			detail.setCarId(storeStatement.getCarId());
			detail.setCarNo(storeStatement.getCarNo());
			detail.setLocation(storeStatement.getLocation());
			detail.setCustomerId(storeStatement.getCustomerId());
			detail.setType(storeStatement.getType());
			detail.setBusiDate(storeStatement.getBusiDate());
			detail.setCreateUser(ShiroUtils.getShiroUser().getLoginName());
			detail.setUpdateUser(ShiroUtils.getShiroUser().getLoginName());
			detail.setCreateTime(DateUtil.getNowDateTimeString());
			detail.setUpdateTime(DateUtil.getNowDateTimeString());
			batchList.add(detail);
		}
		storeDetailService.insertBatch(batchList);
		
	}
	
}
