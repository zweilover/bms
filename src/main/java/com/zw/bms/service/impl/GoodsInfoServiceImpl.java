package com.zw.bms.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.zw.bms.commons.exception.CommonException;
import com.zw.bms.commons.utils.StringUtils;
import com.zw.bms.mapper.GoodsInfoMapper;
import com.zw.bms.model.GoodsInfo;
import com.zw.bms.service.IGoodsInfoService;

/**
 * <p>
 * 货物信息 服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-09-20
 */
@Service
public class GoodsInfoServiceImpl extends ServiceImpl<GoodsInfoMapper, GoodsInfo> implements IGoodsInfoService {

	@Autowired
	private GoodsInfoMapper goodsInfoMapper;
	
	
	@Override
	public void checkUnique4GoodsInfo(GoodsInfo goodsInfo) {
		Integer i = 0;
		if(StringUtils.isNotBlank(goodsInfo.getName())){
			EntityWrapper<GoodsInfo> ew = new EntityWrapper<GoodsInfo>();
			ew.and("status != {0} and name = {1}", "2",goodsInfo.getName());
			if(null != goodsInfo.getId() && goodsInfo.getId() != 0){
				ew.and("id != {0}",goodsInfo.getId());
			}
			i = goodsInfoMapper.selectCount(ew);
			if(i > 0){
				throw new CommonException("该货物名称重复，请核实！");
			}
		}
	}
}
