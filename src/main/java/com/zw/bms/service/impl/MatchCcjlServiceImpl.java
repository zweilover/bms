package com.zw.bms.service.impl;

import com.zw.bms.model.MatchCcjl;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.commons.utils.ShiroUtils;
import org.apache.commons.lang.StringUtils;
import com.zw.bms.mapper.MatchCcjlMapper;
import com.zw.bms.service.IMatchCcjlService;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.ObjectUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
@Service
public class MatchCcjlServiceImpl extends ServiceImpl<MatchCcjlMapper, MatchCcjl> implements IMatchCcjlService {

	@Autowired
	private MatchCcjlMapper matchCcjlMapper;
	
	@Override
	public List<HashMap<String, Object>> selectMatchCcDataList(Page<HashMap<String, Object>> page,Map<String, Object> queryParam) {
		return matchCcjlMapper.selectMatchCcDataList(page, queryParam);
	}

	@Override
	public List<HashMap<String, Object>> selectMatchCcPickList(Page<HashMap<String, Object>> page,
			Map<String, Object> queryParam) {
		return matchCcjlMapper.selectMatchCcPickList(page, queryParam);
	}

	@Override
	@Transactional
	public void dealAutoMatchCcData(Map<String, Object> param) {
		Page<HashMap<String,Object>> pages = new Page<HashMap<String,Object>>(1,500);
		List<HashMap<String, Object>> importList = matchCcjlMapper.selectMatchCcDataList(pages, param); //获取出仓数据
		List<HashMap<String, Object>> carList = matchCcjlMapper.selectMatchCcPickList(pages, param); //获取待匹配车辆列表
		if(null == importList || importList.isEmpty() || null == carList || carList.isEmpty()){
			return;
		}
		
		String importCarNo,carNo = null;
		String importCcsj,outTime = null;
		MatchCcjl matchCc = null;
		List<MatchCcjl> matchCcjlList = new ArrayList<MatchCcjl>();
		for(HashMap<String,Object> importData : importList){
			importCarNo = ObjectUtils.toString(importData.get("ch"));
			importCcsj = StringUtils.substring(ObjectUtils.toString(importData.get("ccsj")), 0, 10);
			for(HashMap<String,Object> carData : carList){
				carNo = ObjectUtils.toString(carData.get("car_no"));
				outTime = StringUtils.substring(ObjectUtils.toString(carData.get("out_time")), 0, 10);
				//车牌号与出库时间相同
				if(StringUtils.isNotBlank(importCarNo) && importCarNo.equalsIgnoreCase(carNo) && importCcsj.equals(outTime)){
					matchCc = new MatchCcjl();
					matchCc.setCcId(Long.valueOf(ObjectUtils.toString(importData.get("id"))));
					matchCc.setCcNo(importCarNo);
					matchCc.setCarId(Long.valueOf(ObjectUtils.toString(carData.get("id"))));
					matchCc.setCarNo(carNo);
					matchCc.setCcsj(importCcsj);
					matchCc.setLocation(ObjectUtils.toString(param.get("location")));
					matchCc.setType("1");//自动匹配
					matchCc.setCreateTime(DateUtil.getNowDateTimeString());
					matchCc.setUpdateTime(DateUtil.getNowDateTimeString());
					matchCc.setCreateUser(ShiroUtils.getLoginName());
					matchCc.setUpdateUser(ShiroUtils.getLoginName());
					matchCcjlList.add(matchCc);
					carList.remove(carData);//匹配成功后从集合中删除
					break;
				}
			}
		}
		
		if(!matchCcjlList.isEmpty()){
			this.insertBatch(matchCcjlList);
		}
	}
	
}
