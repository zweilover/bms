package com.zw.bms.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.commons.utils.ShiroUtils;
import com.zw.bms.mapper.MatchRcjlMapper;
import com.zw.bms.model.MatchRcjl;
import com.zw.bms.service.IMatchRcjlService;

/**
 * <p>
 * 入仓匹配表 服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
@Service
public class MatchRcjlServiceImpl extends ServiceImpl<MatchRcjlMapper, MatchRcjl> implements IMatchRcjlService {

	@Autowired
	private MatchRcjlMapper matchRcjlMapper;
	
	@Override
	public List<HashMap<String, Object>> selectMatchRcDataList(Page<HashMap<String, Object>> page,Map<String, Object> queryParam) {
		return matchRcjlMapper.selectMatchRcDataList(page, queryParam);
	}
	
	@Override
	public List<HashMap<String, Object>> selectMatchRcPickList(Page<HashMap<String, Object>> page,
			Map<String, Object> queryParam) {
		return matchRcjlMapper.selectMatchRcPickList(page, queryParam);
	}

	@Override
	public void dealAutoMatchRcData(Map<String, Object> param) {
		Page<HashMap<String,Object>> pages = new Page<HashMap<String,Object>>(1,500);
		List<HashMap<String, Object>> importList = matchRcjlMapper.selectMatchRcDataList(pages, param); //获取入仓数据
		List<HashMap<String, Object>> carList = matchRcjlMapper.selectMatchRcPickList(pages, param); //获取待匹配车辆列表
		if(null == importList || importList.isEmpty() || null == carList || carList.isEmpty()){
			return;
		}
		
		String importCarNo,carNo = null;
		String importRcsj,inTime = null;
		MatchRcjl matchRc = null;
		List<MatchRcjl> matchRcjlList = new ArrayList<MatchRcjl>();
		for(HashMap<String,Object> importData : importList){
			importCarNo = ObjectUtils.toString(importData.get("ch"));
			importRcsj = StringUtils.substring(ObjectUtils.toString(importData.get("rcsj")), 0, 10);
			for(HashMap<String,Object> carData : carList){
				carNo = ObjectUtils.toString(carData.get("car_no"));
				inTime = StringUtils.substring(ObjectUtils.toString(carData.get("in_time")), 0, 10);
				//车牌号与入库时间相同
				if(StringUtils.isNotBlank(importCarNo) && importCarNo.equalsIgnoreCase(carNo) && importRcsj.equals(inTime)){
					matchRc = new MatchRcjl();
					matchRc.setRcId(Long.valueOf(ObjectUtils.toString(importData.get("id"))));
					matchRc.setRcNo(importCarNo);
					matchRc.setCarId(Long.valueOf(ObjectUtils.toString(carData.get("id"))));
					matchRc.setCarNo(carNo);
					matchRc.setRcsj(importRcsj);
					matchRc.setLocation(ObjectUtils.toString(param.get("location")));
					matchRc.setType("1");//自动匹配
					matchRc.setCreateTime(DateUtil.getNowDateTimeString());
					matchRc.setUpdateTime(DateUtil.getNowDateTimeString());
					matchRc.setCreateUser(ShiroUtils.getLoginName());
					matchRc.setUpdateUser(ShiroUtils.getLoginName());
					matchRcjlList.add(matchRc);
					carList.remove(carData);//匹配成功后从集合中删除
					break;
				}
			}
		}
		
		if(!matchRcjlList.isEmpty()){
			this.insertBatch(matchRcjlList);
		}
	}
	
}
